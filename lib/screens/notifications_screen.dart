import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _getNotifications().length,
        itemBuilder: (context, index) {
          final notification = _getNotifications()[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: notification['isRead'] == false
                    ? Colors.blue
                    : Colors.grey[300],
                child: Icon(
                  notification['icon'],
                  color: notification['isRead'] == false ? Colors.white : Colors.grey,
                  size: 20,
                ),
              ),
              title: Text(
                notification['title']!,
                style: TextStyle(
                  fontWeight: notification['isRead'] == false 
                      ? FontWeight.bold 
                      : FontWeight.normal,
                ),
              ),
              subtitle: Text(notification['message']!),
              trailing: Text(
                notification['time']!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              onTap: () {
                // Mark as read
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(notification['title']!),
                    content: Text(notification['message']!),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getNotifications() {
    return [
      {
        'title': 'Appointment Reminder',
        'message': 'You have an appointment with Dr. Sarah Johnson tomorrow at 10:00 AM',
        'time': '5 min ago',
        'icon': Icons.event_available,
        'isRead': false,
      },
      {
        'title': 'Appointment Confirmed',
        'message': 'Your appointment on March 20th has been confirmed',
        'time': '1 hour ago',
        'icon': Icons.check_circle,
        'isRead': false,
      },
      {
        'title': 'Health Tip',
        'message': 'Remember to bring your medical records to your appointment',
        'time': '2 hours ago',
        'icon': Icons.medical_services,
        'isRead': true,
      },
      {
        'title': 'Clinic Location',
        'message': "Don't forget to check the clinic location before your visit",
        'time': 'Yesterday',
        'icon': Icons.location_on,
        'isRead': true,
      },
    ];
  }
}