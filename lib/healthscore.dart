import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class HealthScoreScreen extends StatefulWidget {
  @override
  _HealthScoreScreenState createState() => _HealthScoreScreenState();
}

class _HealthScoreScreenState extends State<HealthScoreScreen> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = 'initializing', _steps = '90';

  double _height = 1.5;
  double _weight = 75.0;
  int _age = 30;
  String _sex = 'Male';
  double _sleepHours = 7.0;
  late String _uid; // Add UID variable

  @override
  void initState() {
    super.initState();
    // Start listening for pedestrian status updates
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream.listen(onPedestrianStatusChanged).onError(onPedestrianStatusError);

    // Start listening for step count updates
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    // Get the current user's UID


    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _uid = user.uid;
      });
    }

    // _uid = 'replace_with_your_uid'; // Replace with actual UID
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  double _calculateBMI(double height, double weight) {
    return weight / (height * height);
  }

  String _getHealthScore(double bmi, int age, String sex, double sleepHours) {
    if (sex == 'Male') {
      if (age <= 39) {
        if (bmi < 20.7) {
          return 'Underweight';
        } else if (bmi < 26.4) {
          return 'Normal weight';
        } else if (bmi < 27.8) {
          return 'Overweight';
        } else {
          return 'Obese';
        }
      } else {
        if (bmi < 21.5) {
          return 'Underweight';
        } else if (bmi < 27.8) {
          return 'Normal weight';
        } else if (bmi < 30.1) {
          return 'Overweight';
        } else {
          return 'Obese';
        }
      }
    } else {
      if (age <= 39) {
        if (bmi < 19.1) {
          return 'Underweight';
        } else if (bmi < 25.8) {
          return 'Normal weight';
        } else if (bmi < 27.3) {
          return 'Overweight';
        } else {
          return 'Obese';
        }
      } else {
        if (bmi < 20.7) {
          return 'Underweight';
        } else if (bmi < 27.3) {
          return 'Normal weight';
        } else if (bmi < 32.3) {
          return 'Overweight';
        } else {
          return 'Obese';
        }
      }
    }
  }

  // Adjust health score based on sleep duration and return as percentage
  double _adjustHealthScoreForSleep(double bmi, double sleepHours) {
    double percentage = 0.0;

    if (_sex == 'Male') {
      if (_age <= 39) {
        if (bmi < 20.7) {
          percentage = 25.0;
        } else if (bmi < 26.4) {
          percentage = 50.0;
        } else if (bmi < 27.8) {
          percentage = 75.0;
        } else {
          percentage = 100.0;
        }
      } else {
        if (bmi < 21.5) {
          percentage = 25.0;
        } else if (bmi < 27.8) {
          percentage = 50.0;
        } else if (bmi < 30.1) {
          percentage = 75.0;
        } else {
          percentage = 100.0;
        }
      }
    } else {
      if (_age <= 39) {
        if (bmi < 19.1) {
          percentage = 25.0;
        } else if (bmi < 25.8) {
          percentage = 50.0;
        } else if (bmi < 27.3) {
          percentage = 75.0;
        } else {
          percentage = 100.0;
        }
      } else {
        if (bmi < 20.7) {
          percentage = 25.0;
        } else if (bmi < 27.3) {
          percentage = 50.0;
        } else if (bmi < 32.3) {
          percentage = 75.0;
        } else {
          percentage = 100.0;
        }
      }
    }

    if (sleepHours < 7.0) {
      percentage -= 10.0;
    } else if (sleepHours > 9.0) {
      percentage += 10.0;
    }

    return percentage.clamp(0.0, 100.0);
  }

  Future<String> _fetchSymptoms() async {
    String symptom = '';
    try {
      // Fetch symptoms from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data()!;
        if (userData.containsKey('symptoms')) {
          symptom = userData['symptoms'] ?? ''; // Retrieve the symptom directly
        }
      }
    } catch (error) {
      print('Error fetching symptoms: $error');
    }
    return symptom;
  }


  Future<String> _searchSymptomsOnline(String symptom) async {
    String result = '';
    try {
      // Check for specific symptoms
      if (symptom.toLowerCase() == 'acidity') {
        result = 'To prevent future occurrences of acidity, it\'s crucial to make lifestyle changes and dietary adjustments. Avoid trigger foods like spicy, fatty, and acidic foods, eat smaller meals, and refrain from eating close to bedtime. Maintain a healthy weight, elevate the head of your bed, and practice good posture. Consider stress-reduction techniques, quit smoking if applicable, and follow prescribed medications as directed. Regularly monitor symptoms and seek medical advice if symptoms persist or worsen despite lifestyle modifications.';
      } else if (symptom.toLowerCase() == 'headaches') {
        result = 'To prevent future occurrences of headaches, it\'s crucial to make lifestyle changes and dietary adjustments. Ensure proper hydration, maintain regular sleep patterns, manage stress levels, and practice relaxation techniques. Identify and avoid triggers such as certain foods, caffeine, alcohol, and environmental factors. Practice good posture, take breaks from screen time, and engage in regular physical activity. If headaches persist or worsen, consult a healthcare professional for further evaluation and management.';
      } else {
        result = 'No specific advice found for $symptom';
      }
    } catch (error) {
      print('Error searching for $symptom: $error');
      result = 'Error searching for $symptom';
    }
    return result;
  }



  @override
  Widget build(BuildContext context) {
    double bmi = _calculateBMI(_height, _weight);
    String healthScore = _getHealthScore(bmi, _age, _sex, _sleepHours);
    double adjustedHealthScore = _adjustHealthScoreForSleep(bmi, _sleepHours);

    return Scaffold(
      appBar: AppBar(
        title: Text('Health Score'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 4,
            color: Color(0xFFF2EFE5),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Steps Taken:',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Text(
                    _steps,
                    style: TextStyle(fontSize: 40),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 4,
            color: Color(0xFFF8E8EE),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedestrian Status:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Icon(
                    _status == 'walking'
                        ? Icons.directions_walk
                        : _status == 'stopped'
                        ? Icons.accessibility_new
                        : Icons.error,
                    size: 60,
                  ),
                  Text(
                    _status,
                    style: _status == 'walking' || _status == 'stopped'
                        ? TextStyle(fontSize: 20)
                        : TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your height (m):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _height,
                  min: 0.5,
                  max: 2.5,
                  divisions: 20,
                  onChanged: (value) {
                    setState(() {
                      _height = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your weight (kg):',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _weight,
                  min: 20,
                  max: 150,
                  divisions: 130,
                  onChanged: (value) {
                    setState(() {
                      _weight = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your age:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _age.toDouble(),
                  min: 18,
                  max: 100,
                  divisions: 82,
                  onChanged: (value) {
                    setState(() {
                      _age = value.toInt();
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter your sleep hours:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Slider(
                  value: _sleepHours,
                  min: 4,
                  max: 12,
                  divisions: 16,
                  onChanged: (value) {
                    setState(() {
                      _sleepHours = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select your gender:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: _sex,
                  onChanged: (String? newValue) {
                    setState(() {
                      _sex = newValue!;
                    });
                  },
                  items: <String>['Male', 'Female'].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

              ],
            ),
          ),
          SizedBox(height: 20),
          Card(
            elevation: 4,
            color: Colors.blueGrey[50],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Health Score:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: adjustedHealthScore / 100,
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      adjustedHealthScore >= 50 ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      '${adjustedHealthScore.toStringAsFixed(1)}%',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                // Fetch symptoms from Firestore
                String symptom = await _fetchSymptoms();
                // Search symptoms online
                String searchResult = await _searchSymptomsOnline(symptom);
                // Navigate to the new screen with AI suggestions and search result
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AISuggestionsScreen(
                      healthScore: adjustedHealthScore,
                      steps: int.parse(_steps),
                      searchResults: [searchResult], // Wrap the search result in a list
                    ),
                  ),
                );
              },
              child: Text('AI Suggestions ✨'),
            ),
          ),
        ],
      ),
    );
  }
}

class AISuggestionsScreen extends StatefulWidget {
  final double healthScore;
  final int steps;
  final List<String> searchResults;

  AISuggestionsScreen({required this.healthScore, required this.steps, required this.searchResults});

  @override
  _AISuggestionsScreenState createState() => _AISuggestionsScreenState();
}

class _AISuggestionsScreenState extends State<AISuggestionsScreen> {
  late String aiMessage;

  @override
  void initState() {
    super.initState();
    // Determine AI message based on health score and steps
    if (widget.healthScore < 80) {
      aiMessage = 'Your health score has decreased. Take necessary actions.';
    } else {
      aiMessage = 'Your health is in good condition. Keep up the good work!';
    }
    if (widget.steps < 10000) {
      aiMessage = 'You haven\'t met your step goal. At least 10,000 steps are recommended.';
    } else {
      aiMessage = 'Your health is in good condition. Keep up the good work!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Suggestions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          color: Colors.grey[100], // Light color for the card
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Suggestions:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  aiMessage,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Search Results:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.searchResults.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(widget.searchResults[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: HealthScoreScreen(),
  ));
}
