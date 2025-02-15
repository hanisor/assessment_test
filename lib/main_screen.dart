import 'package:assessment_test/history_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String activityName = "Press 'Next' to get an activity!";
  String activityPrice = "";
  String? selectedType; // Preferred activity type
  List<Map<String, dynamic>> activityHistory = [];

  @override
  void initState() {
    super.initState();
    _loadData(); // Load saved data on app start
  }

  // Load activity history and selected type from SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedHistory = prefs.getString('activityHistory') ?? '[]';
    final savedType = prefs.getString('preferredType');

    setState(() {
      activityHistory = List<Map<String, dynamic>>.from(
          json.decode(savedHistory) as List<dynamic>);
      selectedType = savedType;
    });
  }

  // Save activity history and selected type to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('activityHistory', json.encode(activityHistory));
    await prefs.setString('preferredType', selectedType ?? '');
  }

  // Fetch a random activity from the API
  Future<void> fetchActivity() async {
    final url = selectedType == null
        ? Uri.parse("https://bored.api.lewagon.com/api/activity")
        : Uri.parse("https://bored.api.lewagon.com/api/activity?type=$selectedType");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final newActivity = {
          'name': data['activity'] ?? "Unknown activity",
          'price': (data['price'] as double).toStringAsFixed(2),
          'type': data['type'] ?? "Unknown type",
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

        // Save updated data to SharedPreferences
        _saveData();
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
              DropdownButton<String>(
                value: selectedType,
                hint: const Text("Select a preferred type"),
                onChanged: (value) {
                  setState(() {
                    selectedType = value;
                  });
                  _saveData(); // Save selected type
                },
                items: const [
                  DropdownMenuItem(value: 'education', child: Text('Education')),
                  DropdownMenuItem(value: 'recreational', child: Text('Recreational')),
                  DropdownMenuItem(value: 'social', child: Text('Social')),
                  DropdownMenuItem(value: 'diy', child: Text('DIY')),
                  DropdownMenuItem(value: 'charity', child: Text('Charity')),
                  DropdownMenuItem(value: 'cooking', child: Text('Cooking')),
                  DropdownMenuItem(value: 'relaxation', child: Text('Relaxation')),
                  DropdownMenuItem(value: 'music', child: Text('Music')),
                  DropdownMenuItem(value: 'busywork', child: Text('Busywork')),
                ],
              ),
              const SizedBox(height: 16),
              // Display activity name
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
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

              const SizedBox(height: 12),

              // "History" Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HistoryScreen(
                        activityHistory: activityHistory,
                        preferredType: selectedType,
                      ),
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