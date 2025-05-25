import 'dart:developer';

import 'package:attendence_system_dashboard/core/utils/time_utils.dart';
import 'package:attendence_system_dashboard/data/apis.dart';
import 'package:attendence_system_dashboard/models/employee.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<Shift> _clockIns = [];

  @override
  void initState() {
    super.initState();
    Apis.shifts().then(
      (value) {
        if (value?.isNotEmpty == true) {
          setState(() {
            _clockIns = value ?? [];
          });
        }
      },
    );
  }

  TimeOfDay _addHours(TimeOfDay time, int hours) {
    final totalMinutes = time.hour * 60 + time.minute + hours * 60;
    return TimeOfDay(
        hour: (totalMinutes ~/ 60) % 24, minute: totalMinutes % 60);
  }

  TimeOfDay _addMinutes(TimeOfDay time, int minutes) {
    final totalMinutes = time.hour * 60 + time.minute + minutes;
    return TimeOfDay(
        hour: (totalMinutes ~/ 60) % 24, minute: totalMinutes % 60);
  }

  Future<void> _pickTime(int index) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _clockIns[index].clockIn?.toTimeOfDay ??
          const TimeOfDay(hour: 8, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _clockIns[index] = _clockIns[index].copyWith(
          clockIn: picked.toDateTime,
        );
      });
    }
  }

  String _format(TimeOfDay? time) => time?.format(context) ?? '--:--';

  Widget _buildShiftCard(int index) {
    final clockIn = _clockIns[index];
    final clockOut = clockIn.clockIn != null
        ? _addHours(clockIn.clockIn!.toTimeOfDay, 8)
        : null;
    final clockInStart = clockIn.clockIn != null
        ? _addMinutes(clockIn.clockIn!.toTimeOfDay, -30)
        : null;
    final clockInEnd = clockIn.clockIn != null
        ? _addMinutes(clockIn.clockIn!.toTimeOfDay, 30)
        : null;
    final clockOutStart = clockOut != null ? _addMinutes(clockOut, -120) : null;
    final clockOutEnd = clockOut != null ? _addMinutes(clockOut, 120) : null;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shift ${index + 1}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Clock In Time',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _pickTime(index),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  clockIn.clockIn != null
                      ? _format(clockIn.clockIn!.toTimeOfDay)
                      : '--:--',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (clockOut != null) ...[
              _infoRow('Clock Out Time', _format(clockOut)),
              _infoRow('Clock-In Window',
                  '${_format(clockInStart)} - ${_format(clockInEnd)}'),
              _infoRow('Clock-Out Window',
                  '${_format(clockOutStart)} - ${_format(clockOutEnd)}'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }

  bool saveLoading = false;

  void _saveSettings() async {
    final allSet = _clockIns.every((time) => time.clockIn != null);
    if (!allSet) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select all clock-in times")),
      );
      return;
    }

    setState(() {
      saveLoading = true;
    });
    for (var time in _clockIns) {
      log('index: ${_clockIns.indexOf(time) + 1} clockIn: ${time.clockIn?.toTimeOfDay}',
          name: 'SettingsPage');
      await Apis.addShift({
        'id': time.id,
        'clock_in': time.clockIn?.toIso8601String(),
      });
    }
    setState(() {
      saveLoading = false;
    });
    // Handle saving logic here (e.g., save to Firestore or shared preferences)
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Settings Saved"),
        content: Text("All shift timings configured successfully."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Current Shifts",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: _addMoreShift,
                          child: Row(children: [
                            Icon(Icons.add),
                            Text('Add More Shift')
                          ]))
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(_clockIns.length, (index) => _buildShiftCard(index)).reversed,
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveLoading ? null : _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("${saveLoading ? "Saving" : "Save"} Settings",
                    style: TextStyle(fontSize: 16)),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _addMoreShift() {
    setState(() {
      _clockIns.add(Shift());
    });
  }
}
