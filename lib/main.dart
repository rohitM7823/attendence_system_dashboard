import 'package:attendence_system_dashboard/core/helpers/storage_helper.dart';
import 'package:attendence_system_dashboard/data/apis.dart';
import 'package:attendence_system_dashboard/features/attendance/presentation/pages/admin_login.dart';
import 'package:attendence_system_dashboard/features/attendance/presentation/pages/all_sites_page.dart';
import 'package:attendence_system_dashboard/features/attendance/presentation/pages/deparment_management_page.dart';
import 'package:attendence_system_dashboard/features/attendance/presentation/pages/employee_management_page.dart';
import 'package:attendence_system_dashboard/features/attendance/presentation/pages/entry_screen.dart';
import 'package:attendence_system_dashboard/features/attendance/presentation/pages/settings.dart';
import 'package:flutter/material.dart';

import 'routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageHelper.init();
  runApp(const AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Routes.initial,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case Routes.dashboard:
            return MaterialPageRoute(builder: (_) => const AdminHomePage());
          case Routes.login:
            return MaterialPageRoute(builder: (_) => const AdminLoginScreen());
          default:
            return MaterialPageRoute(builder: (_) => const EntryScreen());
        }
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AllSitesPage(), //AddSitePage(),
    const EmployeeManagementPage(),
    const DepartmentManagementPage(),
    const SettingsPage(),
  ];

  final List<String> _titles = [
    'Manage Sites',
    'Manage Employees',
    'Manage Department',
    'Configure shifts',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer
  }

  bool loading = false;

  void _logout() async {
    setState(() {
      loading = true;
    });
    final key = await StorageHelper().getAdminToken();
    if (key?.isNotEmpty == true) {
      await Apis.logout(key!).then(
        (value) async {
          if (value) {
            setState(() {
              loading = false;
            });
            await StorageHelper().clearToken();
            _showSnackbar('Logout successful');
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.login, (route) => false);
          }
        },
      ).catchError((error) {
        setState(() {
          loading = false;
        });
        _showSnackbar(error.toString(), error: false);
      });
    }
  }

  void _showSnackbar(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8).copyWith(right: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: loading ? Colors.grey.shade200 : Colors.redAccent),
            child: InkWell(
              onTap: loading ? null : _logout,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.output_outlined,
                    color: Colors.white,
                  ),
                  Text(
                    " Logout",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Admin Panel',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text(_titles[0]),
              onTap: () => _onItemTapped(0),
              selected: _selectedIndex == 0,
              tileColor: _selectedIndex == 0 ? Colors.blue.shade100 : null,
            ),
            ListTile(
              title: Text(_titles[1]),
              onTap: () => _onItemTapped(1),
              selected: _selectedIndex == 1,
              tileColor: _selectedIndex == 1 ? Colors.blue.shade100 : null,
            ),
            ListTile(
              title: Text(_titles[2]),
              onTap: () => _onItemTapped(2),
              selected: _selectedIndex == 2,
              tileColor: _selectedIndex == 2 ? Colors.blue.shade100 : null,
            ),
            ListTile(
                title: Text(_titles[3]),
                onTap: () => _onItemTapped(3),
                selected: _selectedIndex == 3,
                tileColor: _selectedIndex == 3 ? Colors.blue.shade100 : null),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
