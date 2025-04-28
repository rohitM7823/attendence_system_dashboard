import 'dart:convert';

class Device {
  final int? id;
  final String? name;
  final String? osVersion;
  final String? platform;
  final String? model;
  final String? readId;
  String? status;
  final String? deviceId;
  final String? token;
  final String? empId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Device({
    this.id,
    this.name,
    this.osVersion,
    this.platform,
    this.model,
    this.readId,
    this.status,
    this.deviceId,
    this.token,
    this.empId,
    this.createdAt,
    this.updatedAt,
  });

  Device copyWith({
    int? id,
    String? name,
    String? osVersion,
    String? platform,
    String? model,
    String? readId,
    String? status,
    String? deviceId,
    String? token,
    String? empId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Device(
        id: id ?? this.id,
        name: name ?? this.name,
        osVersion: osVersion ?? this.osVersion,
        platform: platform ?? this.platform,
        model: model ?? this.model,
        readId: readId ?? this.readId,
        status: status ?? this.status,
        deviceId: deviceId ?? this.deviceId,
        token: token ?? this.token,
        empId: empId ?? this.empId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  bool? get isApproved => status == null ? null : status?.toLowerCase() == 'approved';

  factory Device.fromRawJson(String str) => Device.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        id: json["id"],
        name: json["name"],
        osVersion: json["os_version"],
        platform: json["platform"],
        model: json["model"],
        readId: json["read_id"],
        status: json["status"],
        deviceId: json["device_id"],
        token: json["token"],
        empId: json["emp_id"],
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
        "os_version": osVersion,
        "platform": platform,
        "model": model,
        "read_id": readId,
        "status": status,
        "device_id": deviceId,
        "token": token,
        "emp_id": empId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
