import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> activityHistory;

  HistoryScreen({required this.activityHistory});

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity History'),
      ),
      body: activityHistory.isEmpty
          ? Center(
              child: Text(
                'No history yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            )
          : ListView.builder(
              itemCount: activityHistory.length,
              itemBuilder: (context, index) {
                final activity = activityHistory[index];
                return ListTile(
                  title: Text(activity['name']!),
                  subtitle: Text('Price: ${activity['price']}'),
                );
              },
            ),
    );
  }
}



