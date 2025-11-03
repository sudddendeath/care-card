import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReportHistoryScreen extends StatefulWidget {
  const ReportHistoryScreen({super.key});

  @override
  State<ReportHistoryScreen> createState() => _ReportHistoryScreenState();
}

class _ReportHistoryScreenState extends State<ReportHistoryScreen> {
  List<Map<String, dynamic>> _reports = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User is not authenticated.');
      }

      final response = await supabase
          .from('incident_reports')
          .select('*')
          .eq('user_id', user.id)
          .order('incident_date', ascending: false);

      setState(() {
        _reports = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report History'),
        backgroundColor: const Color(0xFFBF092F),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : _reports.isEmpty
          ? const Center(child: Text('No reports found.'))
          : ListView.builder(
              itemCount: _reports.length,
              itemBuilder: (context, index) {
                final report = _reports[index];
                final date = DateTime.parse(report['incident_date']);
                final time = report['incident_time'];
                final categories = List<String>.from(report['categories']);
                final details = report['details'];
                final attachments = List<String>.from(
                  report['attachments'] ?? [],
                );

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat.yMMMd().format(date),
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('Time: $time'),
                        const SizedBox(height: 8),
                        Text('Categories: ${categories.join(', ')}'),
                        const SizedBox(height: 8),
                        Text('Description: $details'),
                        if (attachments.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('Attachments: ${attachments.length}'),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
