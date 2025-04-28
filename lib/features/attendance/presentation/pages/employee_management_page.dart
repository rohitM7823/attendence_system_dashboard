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
  }

  // Method to delete employee
  void _deleteEmployee(Employee employee) {
    setState(() {
      employees.remove(employee); // Remove the employee from the list
    });
    _showDialog('Deleted', 'Employee removed successfully!');
  }

  // Method to add or update employee
  void _saveEmployee() {
    final name = _nameController.text;
    final empId = _empIdController.text;
    final designation = _designationController.text;
    final address = _addressController.text;
    final salary = double.tryParse(_salaryController.text);

    if (name.isEmpty ||
        empId.isEmpty ||
        designation.isEmpty ||
        address.isEmpty ||
        salary == null ||
        _selectedDeviceId == null) {
      _showDialog('Error', 'Please fill all fields correctly!');
      return;
    }

    setState(() {
      if (_isUpdateMode && _selectedEmployee != null) {
        // Update existing employee
        _selectedEmployee!.name = name;
        _selectedEmployee!.empId = empId;
        _selectedEmployee!.designation = designation;
        _selectedEmployee!.address = address;
        _selectedEmployee!.salary = salary;
        _selectedEmployee!.device = _selectedDeviceId;
        _showDialog('Updated', 'Employee details updated successfully!');
      } else {
        // Add new employee
        employees.add(Employee(
          name: name,
          empId: empId,
          designation: designation,
          address: address,
          salary: salary,
          device: _selectedDeviceId!,
          status: 'Not Clocked In',
        ));
        _showDialog('Added', 'New employee added successfully!');
      }

      // Clear form and reset
      _nameController.clear();
      _empIdController.clear();
      _designationController.clear();
      _addressController.clear();
      _salaryController.clear();
      _isUpdateMode = false;
      _selectedEmployee = null;
      _selectedDeviceId = null;
    });
  }

  // Show custom dialog
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
            // Form Fields
            Text(
              _isUpdateMode ? 'Update Employee' : 'Add New Employee',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildInputField(
              controller: _nameController,
              label: 'Name',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16),
            _buildInputField(
              controller: _empIdController,
              label: 'Employee ID',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16),
            _buildInputField(
              controller: _designationController,
              label: 'Designation',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16),
            _buildInputField(
              controller: _addressController,
              label: 'Address',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16),

            // Dropdown for Registered Devices
            Row(
              children: [
                // Salary Field
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: _buildInputField(
                      controller: _salaryController,
                      label: 'Salary',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                // Registered Device Dropdown
                // Custom Dropdown for Registered Devices with ShadCN style
                Expanded(
                  child: Container(
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
                    child: DropdownButton<Device>(
                      hint: const Text('Select Device'),
                      value: _selectedDeviceId,
                      onChanged: (Device? newValue) {
                        setState(() {
                          _selectedDeviceId = newValue;
                        });
                      },
                      items: devices
                          .where((device) => device.isApproved == true)
                          .map<DropdownMenuItem<Device>>((Device device) {
                        return DropdownMenuItem<Device>(
                          value: device,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(device.name ?? device.model ?? ''),
                          ),
                        );
                      }).toList(),
                      isExpanded: true,
                      underline: SizedBox(),
                      // Removes default underline
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      style: TextStyle(color: Colors.black),
                      dropdownColor: Colors.white,
                      focusColor: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Save Button
            ElevatedButton(
              onPressed: _saveEmployee,
              child: Text(_isUpdateMode ? 'Update Employee' : 'Add Employee'),
            ),
            const SizedBox(height: 16),

            // Employee List
            Expanded(
              child: ListView.builder(
                itemCount: employees.length,
                itemBuilder: (context, index) {
                  final employee = employees[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(employee.name,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          'Emp ID: ${employee.empId}\nDesignation: ${employee.designation}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Update Button
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _selectedEmployee = employee;
                                _isUpdateMode = true;

                                // Populate form fields with employee data
                                _nameController.text = employee.name;
                                _empIdController.text = employee.empId;
                                _designationController.text =
                                    employee.designation;
                                _addressController.text = employee.address;
                                _salaryController.text =
                                    employee.salary.toString();
                                _selectedDeviceId = employee.device;
                              });
                            },
                          ),
                          // Delete Button
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteEmployee(employee);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
