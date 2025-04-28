import 'package:attendence_system_dashboard/data/mock.dart';
import 'package:flutter/material.dart';


class OverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the statistics data
    int totalEmployees = MockData.employees.length;
    int employeesWithDevices = MockData.devices.length;
    int presentEmployees = MockData.attendances.where((att) => att.isWorking).toList().length;
    int absentEmployees = totalEmployees - presentEmployees;
    int clockedIn = MockData.attendances.where((att) => att.clockOut == null).toList().length;
    int clockedOut = MockData.attendances.where((att) => att.clockOut != null).toList().length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Overview', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Text(
              'Employee Dashboard',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: GridView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,  // Tailwind-like spacing
                    mainAxisSpacing: 16,   // Tailwind-like spacing
                    childAspectRatio: 2,
                  ),
                  children: [
                    _buildStatCard('Total Employees', totalEmployees.toString(), context),
                    _buildStatCard('Employees with Registered Devices', employeesWithDevices.toString(), context),
                    _buildStatCard('Employees Present', presentEmployees.toString(), context, isPresent: true),
                    _buildStatCard('Employees Absent', absentEmployees.toString(), context, isPresent: false),
                    _buildStatCard('Clocked In', clockedIn.toString(), context, isClockedIn: true),
                    _buildStatCard('Clocked Out', clockedOut.toString(), context, isClockedIn: false),
                  ],
                ),
              ),
            )
            // Tailwind-Inspired Grid Layout with utility spacin,
          ],
        ),
      ),
    );
  }

  // Tailwind-Inspired Card Builder for Stats
  Widget _buildStatCard(String title, String value, BuildContext context, {bool isPresent = false, bool isClockedIn = false}) {
    Color valueColor = isPresent != null
        ? (isPresent ? Colors.green : Colors.red)
        : (isClockedIn ? Colors.blue : Colors.orange);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),  // rounded corners (like Tailwind's default)
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black.withOpacity(0.1))],  // soft shadow
      ),
      padding: EdgeInsets.all(16),  // Tailwind-like padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey[700]), // Tailwind-like text style
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10), // Tailwind-like spacing
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: valueColor,  // Green/Red for present/absent or Blue/Orange for clocked in/out
            ),
          ),
        ],
      ),
    );
  }
}
