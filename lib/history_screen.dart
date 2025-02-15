import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> activityHistory;
  final String? preferredType;

  const HistoryScreen({
    required this.activityHistory,
    this.preferredType,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity History'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: activityHistory.length,
        itemBuilder: (context, index) {
          final activity = activityHistory[index];
          final isHighlighted =
              preferredType != null && activity['type'] == preferredType;

          return ListTile(
            title: Text(activity['name']),
            subtitle: Text("Price: ${activity['price']}"),
            trailing: Text(activity['type']),
            tileColor: isHighlighted ? Colors.yellow[100] : null, // Highlight activities
          );
        },
      ),
    );
  }
}
