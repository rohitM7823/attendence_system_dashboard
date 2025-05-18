import 'package:attendence_system_dashboard/data/apis.dart';
import 'package:attendence_system_dashboard/data/mock.dart';
import 'package:attendence_system_dashboard/features/attendance/presentation/pages/edit_employee.dart';
import 'package:attendence_system_dashboard/models/device.dart';
import 'package:attendence_system_dashboard/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeManagementPage extends StatefulWidget {
  final Device? preselectedDevice; // To accept preselected device

  const EmployeeManagementPage(
      {this.preselectedDevice}); // Constructor with optional preselected device

  @override
  _EmployeeManagementPageState createState() => _EmployeeManagementPageState();
}

class _EmployeeManagementPageState extends State<EmployeeManagementPage> {

  // Employee list
  List<Employee> employees = [];

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

  Future<void> deleteEmployee(Employee emp) async {
    await Apis.deleteEmployee(emp.id).then(
      (value) {
        if (value == true) {
          setState(() {
            employees =
                employees.where((element) => element.id != emp.id).toList();
          });
        }
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
            const SizedBox(height: 16),
            Flexible(
              child: employees.isNotEmpty
                  ? ListView.builder(
                      itemCount: employees.length,
                      itemBuilder: (context, index) {
                        final employee = employees[index];
                        return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  title: Text('${index + 1},  ${employee.name}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                      'Emp ID: ${employee.empId}\nAadhar Card: ${employee.aadharCard} | Mobile Number: ${employee.mobileNumber}\n\nShift:\n${_shiftClockIn(employee.shift)}\n${_shiftClockOut(employee.shift)}\n\nAddress: ${employee.address}\nAccount Number: ${employee.accountNumber} | Site Name: ${employee.siteName}\nClock In: ${_clockInTime(employee)} | Clock Out: ${_clockOutTime(employee)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.all(8),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .45,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.amberAccent),
                                        child: InkWell(
                                          onTap: () => editEmployee(employee),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Edit",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              IconButton(
                                                  onPressed: () =>
                                                      editEmployee(employee),
                                                  icon: Icon(
                                                    Icons.edit,
                                                    color: Colors.black,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: EdgeInsets.all(8),
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .45,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.redAccent),
                                        child: InkWell(
                                          onTap: () => deleteEmployee(employee),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Delete",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    deleteEmployee(employee);
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ));
                      },
                    )
                  : Center(child: Text('No employees are registered!.')),
            ),
          ],
        ),
      ),
    );
  }

  void editEmployee(Employee employee) async {
    var result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => UpdateEmployeeForm(
        employee: employee,
      ),
    ));
    if (result is bool && result == true) {
      Apis.employees().then((value) {
        if (value != null) {
          setState(() {
            employees = value;
          });
        }
      });
    }
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

  String _clockInTime(Employee emp) {
    if (emp
        case Employee(
          id: _,
          name: _,
          empId: _,
          address: _,
          token: _,
          accountNumber: _,
          siteName: _,
          location: _,
          clockInTime: DateTime clockIn,
          clockOutTime: _,
          aadharCard: _,
          mobileNumber: _,
          shift: _,
          faceData: _
        )) {
      return DateFormat('MMM d, yyyy hh:mm a').format(clockIn);
    }
    return 'Not clocked in';
  }

  String _clockOutTime(Employee emp) {
    if (emp
        case Employee(
          id: _,
          name: _,
          empId: _,
          address: _,
          token: _,
          accountNumber: _,
          siteName: _,
          location: _,
          clockInTime: _,
          clockOutTime: DateTime clockOut,
          aadharCard: _,
          mobileNumber: _,
          shift: _,
          faceData: _
        )) {
      return DateFormat('MMM d, yyyy hh:mm a').format(clockOut);
    }
    return 'Not clocked out';
  }

  String _shiftClockIn(Shift? shift) {
    switch (shift) {
      case Shift(
          id: _,
          clockIn: _,
          clockOut: _,
          clockInWindow: ClockWindow(
            start: DateTime windowStart,
            end: DateTime windowEnd
          ),
          clockOutWindow: _,
          createdAt: _,
          updatedAt: _
        ):
        return 'Start: ${DateFormat('MMM d, yyyy hh:mm a').format(windowStart)} - End: ${DateFormat('MMM d, yyyy hh:mm a').format(windowEnd)}';
      default:
        return 'Clock-in window is not available';
    }
  }

  String _shiftClockOut(Shift? shift) {
    switch (shift) {
      case Shift(
          id: _,
          clockIn: _,
          clockOut: _,
          clockInWindow: _,
          clockOutWindow: ClockWindow(
            start: DateTime windowStart,
            end: DateTime windowEnd
          ),
          createdAt: _,
          updatedAt: _
        ):
        return 'Start: ${DateFormat('MMM d, yyyy hh:mm a').format(windowStart)} - End ${DateFormat('MMM d, yyyy hh:mm a').format(windowEnd)}';
      default:
        return 'Clock-out window is not available';
    }
  }
}
