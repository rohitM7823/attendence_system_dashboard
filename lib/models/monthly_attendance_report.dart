class MonthlyAttendanceReport {
  final bool status;
  final String message;
  final List<EmployeeAttendance> attendanceReport;
  final PaginationInfo pagination;

  MonthlyAttendanceReport({
    required this.status,
    required this.message,
    required this.attendanceReport,
    required this.pagination,
  });

  factory MonthlyAttendanceReport.fromJson(Map<String, dynamic> json) {
    return MonthlyAttendanceReport(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      attendanceReport: (json['attendence_report'] as List?)
              ?.map((e) => EmployeeAttendance.fromJson(e))
              .toList() ??
          [],
      pagination: PaginationInfo.fromJson(json['pagination'] ?? {}),
    );
  }
}

class EmployeeAttendance {
  final String name;
  final String empId;
  final List<String> daily;

  EmployeeAttendance({
    required this.name,
    required this.empId,
    required this.daily,
  });

  factory EmployeeAttendance.fromJson(Map<String, dynamic> json) {
    return EmployeeAttendance(
      name: json['name'] ?? '',
      empId: json['empId'] ?? '',
      daily: (json['daily'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class PaginationInfo {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int from;
  final int to;

  PaginationInfo({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.from,
    required this.to,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      from: json['from'] ?? 0,
      to: json['to'] ?? 0,
    );
  }
}
