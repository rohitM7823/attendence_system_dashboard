import 'package:attendence_system_dashboard/models/device.dart';

class Employee {
  final String? name;
  final String? empId;
  final String? address;
  final String? token;
  final double? salary;
  final String? siteName;
  final Map<String, dynamic>? location;
  final Device? device;
  final DateTime? clockInTime;
  final DateTime? clockOutTime;
  final String? aadharCard;
  final String? mobileNumber;

  const Employee({
    this.name,
    this.empId,
    this.address,
    this.token,
    this.salary,
    this.siteName,
    this.location,
    this.device,
    this.clockInTime,
    this.clockOutTime,
    this.aadharCard,
    this.mobileNumber,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'],
      empId: json['emp_id'],
      aadharCard: json['aadhar_card'],
      address: json['address'],
      clockInTime:
          json['clock_in'] != null ? DateTime.tryParse(json['clock_in']) : null,
      clockOutTime: json['clock_out'] != null
          ? DateTime.tryParse(json['clock_out'])
          : null,
      location: json['location'] as Map<String, dynamic>?,
      mobileNumber: json['mobile_number'],
      salary: json['salary'],
      siteName: json['site_name'],
      token: json['token'],
    );
  }
}
