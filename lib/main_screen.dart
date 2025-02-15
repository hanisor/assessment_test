import 'package:flutter/material.dart';
import 'package:assessment_test/history_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String activityName = "Press 'Next' to get an activity!";
  String activityPrice = "";
  List<Map<String, dynamic>> activityHistory = []; // To store activity history


  // Fetch a random activity from the API
  Future<void> fetchActivity() async {
    final url = Uri.parse("https://bored.api.lewagon.com/api/activity");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newActivity = {
          'name': data['activity'] ?? "Unknown activity",
          'price': (data['price'] as double).toStringAsFixed(2),
        };

        setState(() {
          activityName = newActivity['name']!;
          activityPrice = "Price: ${newActivity['price']}";

          // Add the new activity to the history list
          activityHistory.insert(0, newActivity);

          // Keep the history to the most recent 50 activities
          if (activityHistory.length > 50) {
            activityHistory = activityHistory.sublist(0, 50);
          }
        });
      } else {
        setState(() {
          activityName = "Failed to fetch activity.";
          activityPrice = "";
        });
      }
    } catch (e) {
      setState(() {
        activityName = "Error: Unable to fetch activity.";
        activityPrice = "";
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Random Activity'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display activity name
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      activityName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      activityPrice,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // "Next" Button
              ElevatedButton(
                onPressed: fetchActivity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryScreen(activityHistory: activityHistory),
                        ),
                      );
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'History',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
