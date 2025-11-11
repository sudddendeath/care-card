/*
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Added for date formatting

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital ID Creator',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        ),
      ),
      // Start the app with the input form
      home: const InputFormScreen(),
    );
  }
}


// SCREEN 1: Input Form

class InputFormScreen extends StatefulWidget {
  const InputFormScreen({Key? key}) : super(key: key);

  @override
  _InputFormScreenState createState() => _InputFormScreenState();
}

class _InputFormScreenState extends State<InputFormScreen> {
  // One controller for each text field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeOfDisabilityController = TextEditingController();
  final TextEditingController _idNoController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _dateIssuedController = TextEditingController();
  final TextEditingController _sexController = TextEditingController(); // Will be updated by dropdown
  final TextEditingController _bloodTypeController = TextEditingController();
  final TextEditingController _emergencyNameController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();

  String? _selectedSex; // State variable for the Sex Dropdown

  // Clean up controllers
  @override
  void dispose() {
    _nameController.dispose();
    _typeOfDisabilityController.dispose();
    _idNoController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    _dateIssuedController.dispose();
    _sexController.dispose();
    _bloodTypeController.dispose();
    _emergencyNameController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  // Function to show date picker and update controller
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      helpText: 'Select Date',
    );
    if (picked != null) {
      // Format the date as "MONTH DAY, YEAR"
      controller.text = DateFormat('MMMM d, yyyy').format(picked).toUpperCase();
    }
  }

  void _generateID() {
    // Navigate to the display screen, passing all the text data
    Navigator.push(
      context,
      MaterialPageRoute<DisplayIDScreen>(
        builder: (BuildContext context) => DisplayIDScreen(
          name: _nameController.text,
          typeOfDisability: _typeOfDisabilityController.text,
          idNo: _idNoController.text,
          address: _addressController.text,
          dateOfBirth: _dateOfBirthController.text,
          dateIssued: _dateIssuedController.text,
          sex: _sexController.text, // Use the value from the controller
          bloodType: _bloodTypeController.text,
          emergencyName: _emergencyNameController.text,
          emergencyContact: _emergencyContactController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter ID Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text('ID Front Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name (e.g., JUAN DELA CRUZ)')),
            const SizedBox(height: 10),
            TextField(controller: _typeOfDisabilityController, decoration: const InputDecoration(labelText: 'Type of Disability')),
            const SizedBox(height: 10),
            TextField(controller: _idNoController, decoration: const InputDecoration(labelText: 'ID No. (e.g., 01-123456789)')),
            
            const Divider(height: 30, thickness: 1),
            
            const Text('ID Back Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(controller: _addressController, decoration: const InputDecoration(labelText: 'Address')),
            const SizedBox(height: 10),
            // Date of Birth field with date picker
            TextFormField(
              controller: _dateOfBirthController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date of Birth (e.g., JANUARY 1, 1990)',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _selectDate(context, _dateOfBirthController),
            ),
            const SizedBox(height: 10),
            // Date Issued field with date picker
            TextFormField(
              controller: _dateIssuedController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Date Issued (e.g., OCTOBER 26, 2023)',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _selectDate(context, _dateIssuedController),
            ),
            const SizedBox(height: 10),
            // Sex dropdown
            DropdownButtonFormField<String>(
              // Fix: Replaced 'value' with 'initialValue' as 'value' is deprecated.
              // The DropdownButtonFormField will manage its internal state after initialValue.
              // The onChanged callback correctly updates _selectedSex and _sexController.text.
              initialValue: _selectedSex,
              decoration: const InputDecoration(
                labelText: 'Sex',
                hintText: 'Select Sex',
              ),
              items: <String>['MALE', 'FEMALE'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSex = newValue;
                  _sexController.text = newValue ?? ''; // Update controller for passing data
                });
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please select your sex';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextField(controller: _bloodTypeController, decoration: const InputDecoration(labelText: 'Blood Type (e.g., O+)')),
            const SizedBox(height: 10),
            TextField(controller: _emergencyNameController, decoration: const InputDecoration(labelText: 'Emergency Contact Name')),
            const SizedBox(height: 10),
            TextField(controller: _emergencyContactController, decoration: const InputDecoration(labelText: 'Emergency Contact Number')),
            
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _generateID,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Generate ID', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}


// SCREEN 2: Display Generated ID

class DisplayIDScreen extends StatelessWidget {
  // All the data from the form
  final String name;
  final String typeOfDisability;
  final String idNo;
  final String address;
  final String dateOfBirth;
  final String dateIssued;
  final String sex;
  final String bloodType;
  final String emergencyName;
  final String emergencyContact;

  const DisplayIDScreen({
    Key? key,
    required this.name,
    required this.typeOfDisability,
    required this.idNo,
    required this.address,
    required this.dateOfBirth,
    required this.dateIssued,
    required this.sex,
    required this.bloodType,
    required this.emergencyName,
    required this.emergencyContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Digital ID'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Pass the user data to the IDCardFront widget
              IDCardFront(
                name: name,
                typeOfDisability: typeOfDisability,
                idNo: idNo,
              ),
              const SizedBox(height: 30),
              // Pass the user data to the IDCardBack widget
              IDCardBack(
                address: address,
                dateOfBirth: dateOfBirth,
                dateIssued: dateIssued,
                sex: sex,
                bloodType: bloodType,
                emergencyName: emergencyName,
                emergencyContact: emergencyContact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ID Card Front

class IDCardFront extends StatelessWidget {
  final String name;
  final String typeOfDisability;
  final String idNo;

  const IDCardFront({
    Key? key,
    required this.name,
    required this.typeOfDisability,
    required this.idNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.purple, width: 2), // Purple border
      ),
      child: Container(
        width: 380, // Approximate width for an ID card
        height: 240, // Approximate height for an ID card
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container( // Left Circle
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    shape: BoxShape.circle,
                  ),
                ),
                Column(
                  children: const <Widget>[
                    Text(
                      'REPUBLIC OF THE PHILIPPINES',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Province of Guimaras',
                      style: TextStyle(fontSize: 9),
                    ),
                    Text(
                      'MUNICIPALITY OF JORDAN',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container( // Right Circle 1
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container( // Right Circle 2
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 10),
                        _buildUnderlinedText(name, label: 'NAME'),
                        const SizedBox(height: 15),
                        _buildUnderlinedText(typeOfDisability, label: 'TYPE OF DISABILITY'),
                        const Spacer(), // Pushes signature and ID down
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: _buildUnderlinedText('', label: 'SIGNATURE'),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: _buildUnderlinedText(idNo, label: 'ID NO.', alignment: TextAlign.center),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Photo Placeholder
                  Container(
                    width: 90, // Adjust size as needed
                    height: 120, // Adjust size as needed
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: const Center(child: Icon(Icons.person, size: 50, color: Colors.grey)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'VALID ANYWHERE IN THE COUNTRY',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for text with underline and label
  Widget _buildUnderlinedText(String text, {String? label, TextAlign alignment = TextAlign.start}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          text.isEmpty ? ' ' : text, // Add a space to ensure line renders
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          textAlign: alignment,
        ),
        Container(
          height: 1,
          color: Colors.black,
          margin: const EdgeInsets.only(top: 2),
        ),
        if (label != null)
          Text(
            label,
            style: const TextStyle(fontSize: 8),
          ),
      ],
    );
  }
}


// ID Card Back
class IDCardBack extends StatelessWidget {
  final String address;
  final String dateOfBirth;
  final String dateIssued;
  final String sex;
  final String bloodType;
  final String emergencyName;
  final String emergencyContact;

  const IDCardBack({
    Key? key,
    required this.address,
    required this.dateOfBirth,
    required this.dateIssued,
    required this.sex,
    required this.bloodType,
    required this.emergencyName,
    required this.emergencyContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.purple, width: 2), // Purple border
      ),
      child: Container(
        width: 380, // Approximate width
        height: 249, // Approximate height - Adjusted from 240 to 249 to fix 9.0px overflow
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildInfoRow('ADDRESS:', address),
            Row(
              children: <Widget>[
                Expanded(child: _buildInfoRow('DATE OF BIRTH:', dateOfBirth)),
                Expanded(child: _buildInfoRow('SEX:', sex)),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(child: _buildInfoRow('DATE ISSUED:', dateIssued)),
                Expanded(child: _buildInfoRow('BLOOD TYPE:', bloodType)),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'IN CASE OF EMERGENCY, PLEASE NOTIFY:',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
            _buildInfoRow('NAME:', emergencyName),
            _buildInfoRow('CONTACT:', emergencyContact),
            const Spacer(), // Pushes signatures and disclaimer to bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: _buildSignatureBlock('LOLITA G. GARQUE, RSW', 'MSWD OFFICER')),
                Expanded(child: _buildSignatureBlock('ATTY. JOHN EDWARD G. GANDO', 'MUNICIPAL MAYOR', alignment: CrossAxisAlignment.end)),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'THE HOLDER OF THIS CARD IS A PERSON WITH DISABILITY AND IS ENTITLED TO DISCOUNTS ON MEDICAL AND DENTAL SERVICES, PURCHASE OF MEDICINES, BASIC COMMODITIES, TRANSPORTATION, ADMISSION FEES IN ALL ESTABLISHMENT AND EDUCATIONAL ASSISTANCE AS AUTHORIZED BY RA 9442 ITS IMPLEMENTING AND REGULATIONS ANY VIOLATION THEREOF IS PUNISHABLE BY LAW THIS CARD IS NON-TRANSFERABLE.',
              style: TextStyle(fontSize: 5),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 5),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'VALID FOR 5 YEARS',
                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 10, color: Colors.black),
          children: <TextSpan>[
            TextSpan(
              text: '$label ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureBlock(String name, String title, {CrossAxisAlignment alignment = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: alignment,
      children: <Widget>[
        Container(
          height: 1,
          width: 120, // Adjust width for signature line
          color: Colors.black,
          margin: const EdgeInsets.only(bottom: 2),
        ),
        Text(
          name,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
          textAlign: alignment == CrossAxisAlignment.start ? TextAlign.left : TextAlign.right,
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 8),
          textAlign: alignment == CrossAxisAlignment.start ? TextAlign.left : TextAlign.right,
        ),
      ],
    );
  }
}
*/
