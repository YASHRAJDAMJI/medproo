import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PollProgressWidget extends StatelessWidget {
  final String bhajiType; // 'bhaji1' or 'bhaji2'

  PollProgressWidget({required this.bhajiType});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('/messvala/messfooddetails/messfoods/viitmess/poli_data/poll')
          .doc(bhajiType) // 'bhaji1' or 'bhaji2'
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator(); // Display a loading indicator while data is loading.
        }

        final pollData = snapshot.data!;
        final totalVotes = pollData['votes'] ?? 0;

        // Calculate the progress based on the number of votes.
        final progress = totalVotes > 0 ? (totalVotes / 100) : 0.0;

        return Column(
          children: [
            Text('$bhajiType Votes: $totalVotes'),
            LinearProgressIndicator(
              value: progress,
              minHeight: 10.0,
              backgroundColor: Colors.grey,
            ),
          ],
        );
      },
    );
  }
}

class PollProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Poll Progress'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PollProgressWidget(bhajiType: 'bhaji1'),
            SizedBox(height: 16.0),
            PollProgressWidget(bhajiType: 'bhaji2'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PollProgressScreen(),
  ));
}
