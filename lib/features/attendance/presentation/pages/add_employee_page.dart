import 'package:attendence_system_dashboard/data/mock.dart';
import 'package:attendence_system_dashboard/models/device.dart';
import 'package:attendence_system_dashboard/models/employee.dart';
import 'package:flutter/material.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _empIdController = TextEditingController();

  final TextEditingController _designationController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _salaryController = TextEditingController();

  Device? selectedDeviceId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name')),
          SizedBox(height: 10),
          TextField(
              controller: _empIdController,
              decoration: InputDecoration(labelText: 'Employee ID')),
          SizedBox(height: 10),
          TextField(
              controller: _designationController,
              decoration: InputDecoration(labelText: 'Designation')),
          SizedBox(height: 10),
          TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address')),
          SizedBox(height: 10),
          TextField(
              controller: _salaryController,
              decoration: InputDecoration(labelText: 'Salary')),
          SizedBox(height: 10),
          DropdownButtonFormField<Device>(
            decoration: InputDecoration(labelText: 'Assign Device'),
            items: MockData.devices.map((device) {
              return DropdownMenuItem<Device>(
                value: device,
                child: Text(device.name ?? device.model ?? ''),
              );
            }).toList(),
            onChanged: (value) {
              selectedDeviceId = value;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (selectedDeviceId != null) {
                MockData.addEmployee(Employee(
                  name: _nameController.text,
                  empId: _empIdController.text,
                  designation: _designationController.text,
                  address: _addressController.text,
                  salary: double.tryParse(_salaryController.text) ?? 0,
                  device: selectedDeviceId!,
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Employee Added')),
                );
              }
            },
            child: Text('Add Employee'),
          )
        ],
      ),
    );
  }
}
