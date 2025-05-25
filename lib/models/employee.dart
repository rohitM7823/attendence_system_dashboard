import 'dart:convert';

import 'package:attendence_system_dashboard/models/department.dart';

class Employee {
  final int? id;
  final String? name;
  final String? empId;
  final String? address;
  final String? token;
  final String? accountNumber;
  final String? siteName;
  final Map<String, dynamic>? location;
  final DateTime? clockInTime;
  final DateTime? clockOutTime;
  final String? aadharCard;
  final String? mobileNumber;
  final Shift? shift;
  final Department? department;
  final String? faceData;

  const Employee(
      {this.id,
      this.name,
      this.empId,
      this.address,
      this.token,
      this.accountNumber,
      this.siteName,
      this.location,
      this.clockInTime,
      this.clockOutTime,
      this.aadharCard,
      this.mobileNumber,
      this.faceData,
      this.department,
      this.shift});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
        name: json['name'],
        empId: json['emp_id'],
        aadharCard: json['aadhar_card'],
        address: json['address'],
        clockInTime: json['clock_in'] != null
            ? DateTime.tryParse(json['clock_in'])
            : null,
        clockOutTime: json['clock_out'] != null
            ? DateTime.tryParse(json['clock_out'])
            : null,
        location: json['location'] as Map<String, dynamic>?,
        mobileNumber: json['mobile_number'],
        accountNumber: json['account_number'],
        siteName: json['site_name'],
        token: json['token'],
        faceData: json["face_metadata"],
        shift: json['shift'] != null ? Shift.fromJson(json['shift']) : null,
        department: json['department'] != null
            ? Department.fromJson(json['department'])
            : null);
  }

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "name": name,
        "emp_id": empId,
        "address": address,
        "account_number": accountNumber,
        "token": token,
        "site_name": siteName,
        "location": location,
        "face_metadata": faceData,
        "clock_in": clockInTime?.toIso8601String(),
        "clock_out": clockOutTime?.toIso8601String(),
        "aadhar_card": aadharCard,
        "mobile_number": mobileNumber,
        "shift_id": shift?.id,
        "shift": shift?.toJson(),
        'department': department?.toJson()
      };
}

class Shift {
  final int? id;
  final DateTime? clockIn;
  final DateTime? clockOut;
  final ClockWindow? clockInWindow;
  final ClockWindow? clockOutWindow;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Shift({
    this.id,
    this.clockIn,
    this.clockOut,
    this.clockInWindow,
    this.clockOutWindow,
    this.createdAt,
    this.updatedAt,
  });

  Shift copyWith({
    int? id,
    DateTime? clockIn,
    DateTime? clockOut,
    ClockWindow? clockInWindow,
    ClockWindow? clockOutWindow,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Shift(
        id: id ?? this.id,
        clockIn: clockIn ?? this.clockIn,
        clockOut: clockOut ?? this.clockOut,
        clockInWindow: clockInWindow ?? this.clockInWindow,
        clockOutWindow: clockOutWindow ?? this.clockOutWindow,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Shift.fromRawJson(String str) => Shift.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Shift.fromJson(Map<String, dynamic> json) => Shift(
        id: json["id"],
        clockIn: json["clock_in"] == null
            ? null
            : DateTime.parse(json["clock_in"]),
        clockOut: json["clock_out"] == null
            ? null
            : DateTime.parse(json["clock_out"]),
        clockInWindow: json["clock_in_window"] == null
            ? null
            : ClockWindow.fromJson(json["clock_in_window"]),
        clockOutWindow: json["clock_out_window"] == null
            ? null
            : ClockWindow.fromJson(json["clock_out_window"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "clock_in": clockIn?.toIso8601String(),
        "clock_out": clockOut?.toIso8601String(),
        "clock_in_window": clockInWindow?.toJson(),
        "clock_out_window": clockOutWindow?.toJson(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class ClockWindow {
  final DateTime? start;
  final DateTime? end;

  ClockWindow({
    this.start,
    this.end,
  });

  ClockWindow copyWith({
    DateTime? start,
    DateTime? end,
  }) =>
      ClockWindow(
        start: start ?? this.start,
        end: end ?? this.end,
      );

  factory ClockWindow.fromRawJson(String str) =>
      ClockWindow.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ClockWindow.fromJson(Map<String, dynamic> json) => ClockWindow(
        start: json["start"] == null
            ? null
            : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
      );

  Map<String, dynamic> toJson() => {
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
      };
}

class Site {
  final int? id;
  final String? name;
  final Location? location;
  final int? radius;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Site({
    this.id,
    this.name,
    this.location,
    this.radius,
    this.createdAt,
    this.updatedAt,
  });

  Site copyWith({
    int? id,
    String? name,
    Location? location,
    int? radius,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Site(
        id: id ?? this.id,
        name: name ?? this.name,
        location: location ?? this.location,
        radius: radius ?? this.radius,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Site.fromRawJson(String str) => Site.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Site.fromJson(Map<String, dynamic> json) => Site(
        id: json["id"],
        name: json["name"],
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        radius: json["radius"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location?.toJson(),
        "radius": radius,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Location {
  final double? lat;
  final double? lng;

  Location({
    this.lat,
    this.lng,
  });

  Location copyWith({
    double? lat,
    double? lng,
  }) =>
      Location(
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
      );

  factory Location.fromRawJson(String str) =>
      Location.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        lat: json["lat"]?.toDouble(),
        lng: json["lng"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
