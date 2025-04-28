class Attendance {
  final String empId;
  final DateTime clockIn;
  DateTime? clockOut;
  bool isWorking;

  Attendance({
    required this.empId,
    required this.clockIn,
    this.clockOut,
    this.isWorking = true,
  });
}