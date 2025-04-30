import 'package:attendence_system_dashboard/features/attendance/presentation/pages/add_stite_page.dart';
import 'package:attendence_system_dashboard/features/attendance/presentation/pages/attendence_report.dart';
import 'package:attendence_system_dashboard/features/attendance/presentation/pages/employee_management_page.dart';
import 'package:attendence_system_dashboard/features/attendance/presentation/pages/force_attendence.dart';
import 'package:attendence_system_dashboard/features/attendance/presentation/pages/overview_page.dart';
import 'package:attendence_system_dashboard/features/attendance/presentation/pages/register_device.dart';
import 'package:attendence_system_dashboard/features/attendance/presentation/pages/settings.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AdminHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    RegisterDevicePage(),
    AddSitePage(),
    EmployeeManagementPage(),
    AttendanceReportPage(),
    ForceAttendancePage(),
    SettingsPage(),
    OverviewPage()
  ];

  final List<String> _titles = [
    'Register Device',
    'Site Add',
    'Manage Employees',
    'Attendance Report',
    'Force Attendance',
    'Settings Page',
    'Overview'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Admin Panel', style: TextStyle(color: Colors.white, fontSize: 24)),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text('Register Device'),
              onTap: () => _onItemTapped(0),
              selected: _selectedIndex == 0,
              tileColor: _selectedIndex == 0 ? Colors.blue.shade100 : null,
            ),
            ListTile(
              title: Text('Add Your Site'),
              onTap: () => _onItemTapped(1),
              selected: _selectedIndex == 1,
              tileColor: _selectedIndex == 1 ? Colors.blue.shade100 : null,
            ),
            ListTile(
              title: const Text('Manage Employees'),
              onTap: () => _onItemTapped(2),
              selected: _selectedIndex == 2,
              tileColor: _selectedIndex == 2 ? Colors.blue.shade100 : null,
            ),
            ListTile(
              title: Text('Attendance Report'),
              onTap: () => _onItemTapped(3),
              selected: _selectedIndex == 3,
              tileColor: _selectedIndex == 3 ? Colors.blue.shade100 : null,
            ),
            ListTile(
              title: Text('Force Attendance'),
              onTap: () => _onItemTapped(4),
              selected: _selectedIndex == 4,
              tileColor: _selectedIndex == 4 ? Colors.blue.shade100 : null,
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () => _onItemTapped(5),
              selected: _selectedIndex == 5,
              tileColor: _selectedIndex == 5 ? Colors.blue.shade100 : null),
            ListTile(
              title: Text('Overview'),
              onTap: () => _onItemTapped(6),
              selected: _selectedIndex == 6,
              tileColor: _selectedIndex == 6 ? Colors.blue.shade100 : null,
            )
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}