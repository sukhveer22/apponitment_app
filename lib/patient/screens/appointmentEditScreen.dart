import 'package:flutter/material.dart';

class EditAppointmentScreen extends StatefulWidget {
  final Map<String, dynamic> appointment;

  EditAppointmentScreen({required this.appointment});

  @override
  _EditAppointmentScreenState createState() => _EditAppointmentScreenState();
}

class _EditAppointmentScreenState extends State<EditAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _doctorNameController;
  late TextEditingController _appointmentDateController;

  @override
  void initState() {
    super.initState();
    _doctorNameController = TextEditingController(text: widget.appointment['doctorName']);
    _appointmentDateController = TextEditingController(text: widget.appointment['appointmentDate']);
  }

  @override
  void dispose() {
    _doctorNameController.dispose();
    _appointmentDateController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Implement save functionality
      final updatedAppointment = {
        'doctorName': _doctorNameController.text,
        'appointmentDate': _appointmentDateController.text,
        // Add other fields as needed
      };
      // TODO: Update the appointment in the database
      Navigator.pop(context, updatedAppointment); // Pass updated data back
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Appointment'),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _doctorNameController,
                decoration: InputDecoration(labelText: 'Doctor Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a doctor name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _appointmentDateController,
                decoration: InputDecoration(labelText: 'Appointment Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an appointment date';
                  }
                  return null;
                },
              ),
              // Add additional form fields as needed
            ],
          ),
        ),
      ),
    );
  }
}
