import 'package:attendence_system_dashboard/data/mock.dart';
import 'package:attendence_system_dashboard/models/employee.dart';
import 'package:flutter/material.dart';

class ForceAttendancePage extends StatefulWidget {
  const ForceAttendancePage({super.key});

  @override
  _ForceAttendancePageState createState() => _ForceAttendancePageState();
}

class _ForceAttendancePageState extends State<ForceAttendancePage> {
  // List of employees (using mock data)
  List<Employee> employees = MockData.employees;

  // Minimum threshold time for clock-out (e.g., 30 minutes)
  final Duration clockOutThreshold = const Duration(minutes: 30);

  // Method to force clock in
  void _clockIn(Employee employee) {
    setState(() {
      employee.clockInTime = DateTime.now();
      employee.status = "Clocked In";
    });
    _showDialog('Clock In', '${employee.name} has been clocked in successfully.');
  }

  // Method to force clock out
  void _clockOut(Employee employee) {
    // Check if the employee has been clocked in for at least the threshold time
    if (employee.clockInTime == null) {
      _showDialog('Error', 'Employee has not clocked in yet!');
      return;
    }

    final timeIn = DateTime.now().difference(employee.clockInTime!);

    // Check if the employee has been clocked in for long enough
    if (timeIn < clockOutThreshold) {
      _showDialog('Error', 'Cannot clock out before 30 minutes.');
      return;
    }

    setState(() {
      employee.clockOutTime = DateTime.now();
      employee.status = "Clocked Out";
    });

    _showDialog('Clock Out', '${employee.name} has been clocked out successfully.');
  }

  // Show a custom dialog
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter out employees that don't have registered devices
    List<Employee> employeesWithDevices = employees.where((employee) {
      return MockData.devices.any((device) => device.deviceId == employee.device?.deviceId && device.isApproved == true);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Force Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: employeesWithDevices.isEmpty
            ? Center(child: Text('No employees with registered devices.'))
            : ListView.builder(
          itemCount: employeesWithDevices.length,
          itemBuilder: (context, index) {
            Employee employee = employeesWithDevices[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(employee.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Emp ID: ${employee.empId}\nStatus: ${employee.status}\nClocked In: ${employee.clockInTime?.toLocal() ?? 'N/A'}\nClocked Out: ${employee.clockOutTime?.toLocal() ?? 'N/A'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Clock In Button
                    TextButton(
                      onPressed: employee.status != "Clocked In"
                          ? () => _clockIn(employee)
                          : null, // Disable if already clocked in
                      child: Text(
                        'Clock In',
                        style: TextStyle(color: Colors.green),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: employee.status != "Clocked In" ? Colors.green.shade50 : Colors.transparent,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    SizedBox(width: 8),
                    // Clock Out Button
                    TextButton(
                      onPressed: employee.status == "Clocked In"
                          ? () => _clockOut(employee)
                          : null, // Disable if not clocked in
                      child: Text(
                        'Clock Out',
                        style: TextStyle(color: Colors.red),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: employee.status == "Clocked In" ? Colors.red.shade50 : Colors.transparent,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
