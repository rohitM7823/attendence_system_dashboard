import 'package:attendence_system_dashboard/models/device.dart';

class Employee {
  String name;
  String empId;
  String designation;
  String address;
  double salary;
  Device? device;
  DateTime? clockInTime;
  DateTime? clockOutTime;
  String status; // Status: 'Not Clocked In', 'Clocked In', 'Clocked Out'

  Employee({
    required this.name,
    required this.empId,
    this.designation = '',
    this.address = '',
    this.salary = 0.0,
    this.device,
    this.status = 'Not Clocked In',
  });
}