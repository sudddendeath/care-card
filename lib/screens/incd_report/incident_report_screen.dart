import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'report_history_screen.dart';

class IncidentReportScreen extends StatefulWidget {
  const IncidentReportScreen({super.key});

  @override
  State<IncidentReportScreen> createState() => _IncidentReportScreenState();
}

class _IncidentReportScreenState extends State<IncidentReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final List<String> _selectedCategories = [];
  final List<File> _attachments = [];
  bool _isLoading = false;
  bool _isLocationLoading = true;

  GoogleMapController? _mapController;
  CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(37.7749, -122.4194), // Default to San Francisco
    zoom: 11.0,
  );
  final Set<Marker> _markers = {};

  final List<String> _categories = [
    'Harassment',
    'Abuse',
    'Neglect',
    'Scam',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _detailsController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!mounted) return;
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    if (!mounted) return;
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime && mounted) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLocationLoading = true;
    });

    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location services are disabled.')),
          );
        }
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location permissions are denied.')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permissions are permanently denied.'),
            ),
          );
        }
        return;
      }

      // Fast strategy: use last known position immediately if available,
      // then try to fetch a fresh position in background with lower accuracy
      // and a short timeout to avoid long waits.
      Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null && mounted) {
        setState(() {
          _initialCameraPosition = CameraPosition(
            target: LatLng(lastKnown.latitude, lastKnown.longitude),
            zoom: 15.0,
          );
          _markers.removeWhere((m) => m.markerId.value == 'currentLocation');
          _markers.add(
            Marker(
              markerId: const MarkerId('currentLocation'),
              position: LatLng(lastKnown.latitude, lastKnown.longitude),
            ),
          );
        });
        // animate if controller is ready
        if (_mapController != null) {
          try {
            _mapController!.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition),
            );
          } catch (_) {
            // ignore animation errors
          }
        }
      }

      // Attempt to get a fresh location but don't block UI for long.
      try {
        final fresh = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low, // lower accuracy => faster
          ),
        ).timeout(const Duration(seconds: 6));

        if (mounted) {
          setState(() {
            _initialCameraPosition = CameraPosition(
              target: LatLng(fresh.latitude, fresh.longitude),
              zoom: 16.0,
            );
            _markers.removeWhere((m) => m.markerId.value == 'currentLocation');
            _markers.add(
              Marker(
                markerId: const MarkerId('currentLocation'),
                position: LatLng(fresh.latitude, fresh.longitude),
              ),
            );
          });
          if (_mapController != null) {
            try {
              _mapController!.animateCamera(
                CameraUpdate.newCameraPosition(_initialCameraPosition),
              );
            } catch (_) {}
          }
        }
      } catch (_) {
        // if fresh location fails/times out, keep last known position
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLocationLoading = false;
        });
      }
    }
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null && mounted) {
      setState(() {
        _attachments.addAll(result.paths.map((path) => File(path!)).toList());
      });
    }
  }

  Future<void> _submitReport() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategories.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one category.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final supabase = Supabase.instance.client;
        final user = supabase.auth.currentUser;
        if (user == null) {
          throw Exception('User is not authenticated.');
        }

        final List<String> attachmentUrls = [];
        for (final file in _attachments) {
          final fileName = path.basename(file.path);
          final response = await supabase.storage
              .from('attachments')
              .upload(
                '${user.id}/$fileName',
                file,
                fileOptions: const FileOptions(
                  cacheControl: '3600',
                  upsert: false,
                ),
              );
          attachmentUrls.add(response);
        }

        await supabase.from('incident_reports').insert({
          'details': _detailsController.text,
          'categories': _selectedCategories,
          'incident_date': _selectedDate.toIso8601String(),
          'incident_time': '${_selectedTime.hour}:${_selectedTime.minute}',
          'latitude': _initialCameraPosition.target.latitude,
          'longitude': _initialCameraPosition.target.longitude,
          'user_id': user.id,
          'attachments': attachmentUrls,
        });
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Success'),
                content: const Text('Incident report submitted successfully.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _detailsController.clear();
                        _selectedDate = DateTime.now();
                        _selectedTime = TimeOfDay.now();
                        _selectedCategories.clear();
                        _attachments.clear();
                        _markers.clear();
                        _getCurrentLocation();
                      });
                      _formKey.currentState!.reset();
                    },
                    child: const Text('ok'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to submit report: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportHistoryScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.history),
              label: const Text('View Report History'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBF092F),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Incident Details',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Category', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: _categories.map((category) {
                        return FilterChip(
                          label: Text(category),
                          selected: _selectedCategories.contains(category),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedCategories.add(category);
                              } else {
                                _selectedCategories.remove(category);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _detailsController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please describe the incident.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: _initialCameraPosition,
                            onMapCreated: (controller) {
                              _mapController = controller;
                            },
                            markers: _markers,
                          ),
                          if (_isLocationLoading)
                            Container(
                              color: Color.fromRGBO(0, 0, 0, 0.3),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Attachments', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _pickFiles,
                      icon: const Icon(Icons.attach_file),
                      label: const Text('Add Files'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBF092F),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                    ),
                    if (_attachments.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: _attachments.map((file) {
                          return Chip(
                            label: Text(file.path.split('/').last),
                            onDeleted: () {
                              setState(() {
                                _attachments.remove(file);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Date'),
                    trailing: Text(DateFormat.yMMMd().format(_selectedDate)),
                    onTap: () => _selectDate(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: const Text('Time'),
                    trailing: Text(_selectedTime.format(context)),
                    onTap: () => _selectTime(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitReport,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}
