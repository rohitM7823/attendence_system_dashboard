class Device {
  final String deviceId;
  final String deviceType;
  bool? isApproved; // Can be null, true (approved), false (rejected)

  Device({
    required this.deviceId,
    required this.deviceType,
    this.isApproved,
  });
}
