import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';


class StepCounterScreen extends StatefulWidget {
  const StepCounterScreen({Key? key}) : super(key: key);

  @override
  _StepCounterScreenState createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  int stepCount = 0;
  final double threshold = 12.0;
  DateTime? lastStepTime;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    // Listen to the accelerometer events
    _subscription = accelerometerEvents.listen(_onAccelerometerEvent);
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    double acceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    
    if (acceleration > threshold) {
      final now = DateTime.now();
      if (lastStepTime == null || now.difference(lastStepTime!) > const Duration(milliseconds: 300)) {
        lastStepTime = now;
        setState(() {
          stepCount++;
        });
      }
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Step Counter"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Steps: $stepCount', style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  stepCount = 0;
                });
              },
              child: const Text("Reset Steps"),
            ),
          ],
        ),
      ),
    );
  }
}
