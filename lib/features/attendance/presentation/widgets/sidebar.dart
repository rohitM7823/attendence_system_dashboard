import 'package:flutter/material.dart';



class SidebarMenu extends StatefulWidget {
  const SidebarMenu({super.key, required this.pages});
   final List<Widget> pages;
  @override
  _SidebarMenuState createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  int _selectedIndex = 0; // Track the currently selected menu item

  // List of pages
    // Method to handle navigation and close the drawer
  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
    Navigator.pop(context); // Close the drawer

    // Navigate to the selected page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget.pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Admin Panel',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          // Menu items
          ListTile(
            title: Text('Dashboard'),
            selected: _selectedIndex == 0,
            onTap: () => _onItemTapped(0, context),
            tileColor: _selectedIndex == 0 ? Colors.blue.shade100 : null,
          ),
          ListTile(
            title: Text('Employee Management'),
            selected: _selectedIndex == 1,
            onTap: () => _onItemTapped(1, context),
            tileColor: _selectedIndex == 1 ? Colors.blue.shade100 : null,
          ),
          ListTile(
            title: Text('Attendance Report'),
            selected: _selectedIndex == 2,
            onTap: () => _onItemTapped(2, context),
            tileColor: _selectedIndex == 2 ? Colors.blue.shade100 : null,
          ),
          ListTile(
            title: Text('Device Management'),
            selected: _selectedIndex == 3,
            onTap: () => _onItemTapped(3, context),
            tileColor: _selectedIndex == 3 ? Colors.blue.shade100 : null,
          ),
          ListTile(
            title: Text('Force Attendance'),
            selected: _selectedIndex == 4,
            onTap: () => _onItemTapped(4, context),
            tileColor: _selectedIndex == 4 ? Colors.blue.shade100 : null,
          ),
        ],
      ),
    );
  }
}
