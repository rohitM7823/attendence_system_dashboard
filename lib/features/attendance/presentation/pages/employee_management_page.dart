import 'package:attendence_system_dashboard/data/apis.dart';
import 'package:attendence_system_dashboard/data/mock.dart';
import 'package:attendence_system_dashboard/models/device.dart';
import 'package:attendence_system_dashboard/models/employee.dart';
import 'package:flutter/material.dart';

class EmployeeManagementPage extends StatefulWidget {
  final Device? preselectedDevice; // To accept preselected device

  const EmployeeManagementPage(
      {this.preselectedDevice}); // Constructor with optional preselected device

  @override
  _EmployeeManagementPageState createState() => _EmployeeManagementPageState();
}

class _EmployeeManagementPageState extends State<EmployeeManagementPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _empIdController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();

  // Employee list
  List<Employee> employees = MockData.employees;

  // List of approved devices (this can be from your mock data or API)
  List<Device> devices = MockData.devices;

  // Current employee for updating
  Employee? _selectedEmployee;

  // Form mode (Add, Update)
  bool _isUpdateMode = false;

  // Selected device
  Device? _selectedDeviceId;

  @override
  void initState() {
    super.initState();
    // If a preselected device is passed, set it as the default selected device
    if (widget.preselectedDevice != null) {
      _selectedDeviceId = widget.preselectedDevice;
    }

    Apis.employees().then(
      (value) {
        if (value != null) {
          setState(() {
            employees = value;
          });
        }
      },
    );
  }

  // Method to delete employee
  /*void _deleteEmployee(Employee employee) {
    setState(() {
      employees.remove(employee); // Remove the employee from the list
    });
    _showDialog('Deleted', 'Employee removed successfully!');
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.preselectedDevice != null
          ? AppBar(
              title: Text('Employee Management'),
              leading: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Flexible(
              child: employees.isNotEmpty ? ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(employee.name ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            'Emp ID: ${employee.empId}\nAadhar Card: ${employee.aadharCard} | Mobile Number: ${employee.mobileNumber}\nLocation: ${employee.location} | Address ${employee.address}'),
                      ));
                },
              ) : Center(child: Text('No employees are registered!.')),
            ),
          ],
        ),
      ),
    );
  }

  // Custom input field with ShadCN UI style
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        ),
      ),
    );
  }
}
