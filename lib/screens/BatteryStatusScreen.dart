import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryStatusWidget extends StatefulWidget {
  const BatteryStatusWidget({Key? key}) : super(key: key);

  @override
  _BatteryStatusWidgetState createState() => _BatteryStatusWidgetState();
}

class _BatteryStatusWidgetState extends State<BatteryStatusWidget> {
  final Battery _battery = Battery();
  int? _batteryLevel;
  BatteryState? _batteryState;

  @override
  void initState() {
    super.initState();
    _fetchBatteryLevel();
    _battery.onBatteryStateChanged.listen((BatteryState state) {
      setState(() {
        _batteryState = state;
      });
    });
  }

  Future<void> _fetchBatteryLevel() async {
    try {
      final level = await _battery.batteryLevel;
      setState(() {
        _batteryLevel = level;
      });
    } catch (e) {
      setState(() {
        _batteryLevel = -1; // Handle error as needed.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Battery Status',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _batteryLevel != null && _batteryLevel! >= 0
                  ? 'Battery Level: $_batteryLevel%'
                  : 'Unable to get battery level',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              _batteryState != null
                  ? 'Battery State: ${_batteryState.toString().split('.').last}'
                  : 'Loading battery state...',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchBatteryLevel,
              child: const Text('Refresh Battery Level'),
            ),
          ],
        ),
      ),
    );
  }
}

class BatteryStatusScreen extends StatelessWidget {
  const BatteryStatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery Status'),
      ),
      body: const Center(
        child: BatteryStatusWidget(),
      ),
    );
  }
}
