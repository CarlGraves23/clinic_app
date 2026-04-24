import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/appointment_provider.dart';
import '../models/appointment_model.dart';

class BookAppointmentScreen extends StatefulWidget {
  const BookAppointmentScreen({super.key});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _symptomsController = TextEditingController();
  
  DateTime? _selectedDate;
  String? _selectedTimeSlot;
  String? _selectedDoctor;
  
  final List<String> _timeSlots = [
    '09:00 AM', '10:00 AM', '11:00 AM', 
    '02:00 PM', '03:00 PM', '04:00 PM'
  ];
  
  final List<Map<String, String>> _doctors = [
    {'name': 'Dr. Sarah Johnson', 'specialty': 'Cardiologist'},
    {'name': 'Dr. Michael Chen', 'specialty': 'Dermatologist'},
    {'name': 'Dr. Emily Brown', 'specialty': 'Pediatrician'},
    {'name': 'Dr. David Wilson', 'specialty': 'Neurologist'},
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Doctor',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ..._doctors.map((doctor) => RadioListTile<String>(
                        title: Text(doctor['name']!),
                        subtitle: Text(doctor['specialty']!),
                        value: doctor['name']!,
                        groupValue: _selectedDoctor,
                        onChanged: (value) {
                          setState(() {
                            _selectedDoctor = value;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Date',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        onTap: _selectDate,
                        leading: const Icon(Icons.calendar_today),
                        title: Text(
                          _selectedDate == null
                              ? 'Choose appointment date'
                              : DateFormat('EEEE, MMM dd, yyyy').format(_selectedDate!),
                        ),
                        trailing: const Icon(Icons.arrow_drop_down),
                        tileColor: Colors.grey[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Time Slot',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _timeSlots.map((slot) {
                          return FilterChip(
                            label: Text(slot),
                            selected: _selectedTimeSlot == slot,
                            onSelected: (selected) {
                              setState(() {
                                _selectedTimeSlot = selected ? slot : null;
                              });
                            },
                            selectedColor: Theme.of(context).primaryColor,
                            checkmarkColor: Colors.white,
                            labelStyle: TextStyle(
                              color: _selectedTimeSlot == slot ? Colors.white : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Symptoms',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _symptomsController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Describe your symptoms...',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please describe your symptoms';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (appointmentProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _selectedDoctor != null && _selectedDate != null && _selectedTimeSlot != null
                      ? () => _bookAppointment(authProvider, appointmentProvider)
                      : null,
                  child: const Text('Confirm Booking'),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _bookAppointment(AuthProvider authProvider, AppointmentProvider appointmentProvider) async {
    if (_formKey.currentState!.validate()) {
      AppointmentModel appointment = AppointmentModel(
        patientId: authProvider.userModel!.id,
        patientName: authProvider.userModel!.name,
        doctorId: _selectedDoctor?.replaceAll(' ', '_').toLowerCase(),
        doctorName: _selectedDoctor,
        appointmentDate: _selectedDate,
        timeSlot: _selectedTimeSlot,
        symptoms: _symptomsController.text,
        status: 'pending',
        clinicLocation: '123 Healthcare Street, Medical District',
      );
      
      bool success = await appointmentProvider.bookAppointment(appointment);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment booked successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to book appointment. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
  }
}