import 'package:flutter/material.dart';

class AnalysisScreen extends StatelessWidget {
  final Map<String, dynamic> result;

  AnalysisScreen({required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Who can consume: ${result['consumers']}'),
            Text('Purposes: ${result['purposes']}'),
            Text('Side effects: ${result['sideEffects']}'),
            Text('Manufacturer: ${result['manufacturer']}'),
            Text('Expiry date: ${result['expiryDate']}'),
          ],
        ),
      ),
    );
  }
}
