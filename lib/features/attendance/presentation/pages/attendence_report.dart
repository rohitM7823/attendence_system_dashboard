import 'package:attendence_system_dashboard/data/mock.dart';
import 'package:attendence_system_dashboard/models/attendence.dart';
import 'package:flutter/material.dart';


class AttendanceReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Attendance> attendances = MockData.attendances;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Employee ID')),
                  DataColumn(label: Text('Clock In')),
                  DataColumn(label: Text('Clock Out')),
                  DataColumn(label: Text('Working')),
                ],
                rows: attendances.map((att) {
                  return DataRow(cells: [
                    DataCell(Text(att.empId)),
                    DataCell(Text(att.clockIn.toString())),
                    DataCell(Text(att.clockOut?.toString() ?? '-')),
                    DataCell(Text(att.isWorking ? 'Yes' : 'No')),
                  ]);
                }).toList(),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('CSV Download (Mocked)')),
              );
            },
            child: Text('Download CSV'),
          ),
        ],
      ),
    );
  }
}