import 'package:attendence_system_dashboard/models/attendence.dart';
import 'package:attendence_system_dashboard/models/device.dart';

import '../models/employee.dart';

class MockData {
  static List<Device> devices = [
    Device(deviceId: 'D001', platform: 'Android', status: 'Approved'),
    Device(deviceId: 'D002', platform: 'iOS', status: 'Approved'),
    Device(deviceId: 'D003', platform: 'web', status: 'Rejected'),
    Device(deviceId: 'D004', platform: 'Android', status: 'Approved'),
    Device(deviceId: 'D005', platform: 'iOS', status: 'Approved'),
  ];
  static List<Employee> employees = [
    Employee(empId: 'E001', name: 'John Doe', status: 'Not Clocked In', device: devices.first),
    Employee(empId: 'E002', name: 'Jane Smith', status: 'Not Clocked In', device: devices[1]),
    Employee(empId: 'E003', name: 'Mark Johnson', status: 'Not Clocked In', device: devices.last),
  ];
  static List<Attendance> attendances = [];

  static void registerDevice(String deviceId) {
    devices.add(Device(deviceId: 'D001', platform: 'Android', status: 'Approved'),);
  }

  static void addEmployee(Employee employee) {
    employees.add(employee);
  }

  static void forceClockIn(String empId) {
    attendances.add(Attendance(empId: empId, clockIn: DateTime.now()));
  }
}