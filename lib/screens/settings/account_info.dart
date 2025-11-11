import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      debugPrint('Fetching data for user ID: ${user.id}');
      debugPrint('User phone number from auth: ${user.phone}');
      debugPrint('User metadata: ${user.userMetadata}');

      // Get data from users table
      final response = await Supabase.instance.client
          .from('users')
          .select('*')
          .eq('id', user.id)
          .maybeSingle();

      debugPrint('User table response: $response');

      if (response != null) {
        setState(() {
          _userData = {
            ...response,
            'email': user.email,
            'phone_number':
                response['phone_number'], // Get phone from users table
            // Format the birthdate
            'birth_date': response['birth_date'] != null
                ? DateTime.parse(response['birth_date']).toLocal()
                : null,
          };
          _isLoading = false;
        });
      } else {
        // If no registration data, use auth metadata
        setState(() {
          _userData = {
            'name': user.userMetadata?['full_name'],
            'email': user.email,
            'phone_number': 'Not provided',
            'type': 'unregistered',
          };
          _isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      debugPrint('Error details: $e');
      debugPrint('Stack trace: $stackTrace');
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching user data: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'Not provided',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Information'), elevation: 0),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
          ? const Center(child: Text('No user data found'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            'Account Information',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          // This is where the error was. The stray ), is now gone.
                          _buildInfoRow('Full Name', _userData!['name']),
                          _buildInfoRow('Email', _userData!['email']),
                          _buildInfoRow(
                            'Phone Number',
                            _userData!['phone_number'],
                          ),
                          if (_userData!['type'] != 'unregistered')
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 24),
                                Text(
                                  'Registration Details',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 16),
                                _buildInfoRow(
                                  'ID Number',
                                  _userData!['id_number'],
                                ),
                                _buildInfoRow('Sex', _userData!['sex']),
                                _buildInfoRow('Address', _userData!['address']),
                                if (_userData!['birth_date'] != null)
                                  _buildInfoRow(
                                    'Birth Date',
                                    '${_userData!['birth_date'].day}/${_userData!['birth_date'].month}/${_userData!['birth_date'].year}',
                                  ),
                                if (_userData!['type'] == 'pwd')
                                  _buildInfoRow(
                                    'Condition',
                                    _userData!['condition'],
                                  ),
                                _buildInfoRow(
                                  'Registration Type',
                                  _userData!['type']?.toUpperCase() ??
                                      'Not specified',
                                ),
                                if (_userData!['created_at'] != null)
                                  _buildInfoRow(
                                    'Created At',
                                    DateTime.parse(
                                      _userData!['created_at'],
                                    ).toLocal().toString().split('.')[0],
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
