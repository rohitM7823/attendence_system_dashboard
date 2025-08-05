import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
import 'package:attendence_system_dashboard/data/apis.dart';
import 'package:attendence_system_dashboard/models/department.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/employee.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  // State variables
  int _currentPage = 1;
  static const int _itemsPerPage = 10;
  int _totalPages = 1;
  String? _selectedMonth;
  Site? _selectedSite;
  Department? _selectedDepartment;
  List<Map<String, dynamic>> reportData = [];
  int daysInMonth = 30;
  bool _isLoading = false;
  List<Site> _sites = [];
  List<Department> _departments = [];
  bool _loadingDropdowns = true;

  @override
  void initState() {
    super.initState();
    _loadDropdownData();
  }

  // void _updateDaysInMonth() {
  //   daysInMonth =
  //       DateUtils.getDaysInMonth(selectedMonth.year, selectedMonth.month);
  // }

  Future<void> _loadDropdownData() async {
    setState(() => _loadingDropdowns = true);
    final sites = await Apis.availableSties();
    final depts = await Apis.departments();
    setState(() {
      _sites = sites ?? [];
      _departments = depts ?? [];
      _loadingDropdowns = false;
    });
  }

  Future<void> _fetchReport() async {
    if (_selectedMonth == null || _selectedSite == null || _selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all filters')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final report = await Apis.getMonthlyAttendanceReport(
      month: _selectedMonth!,
      siteName: _selectedSite!.name ?? "Not Available",
      departmentId: _selectedDepartment!.id ?? 0,
      page: _currentPage,
      limit: _itemsPerPage,
    );

    if (report != null) {
      setState(() {
        reportData = report.attendanceReport
            .map((e) => {
                  'name': e.name,
                  'empId': e.empId,
                  'daily': e.daily,
                })
            .toList();
        _totalPages = report.pagination.lastPage;
        _isLoading = false;
      });
    } else {
      setState(() {
        reportData = [];
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch attendance report')),
      );
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    _fetchReport();
  }

  // Add this method to handle PDF download
  Future<void> _downloadReport() async {
    if (_selectedMonth == null || _selectedSite == null || _selectedDepartment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all filters')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final downloadUrl = await Apis.downloadReport(
      month: _selectedMonth!,
      siteName: _selectedSite!.name!,
      departmentId: _selectedDepartment!.id!,
    );

    setState(() => _isLoading = false);

    if (downloadUrl != null) {
      // Launch URL in browser
      launchUrl(Uri.parse(downloadUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate PDF report')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(context)
        .textTheme
        .labelLarge
        ?.copyWith(fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(title: const Text("Monthly Attendance")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildFilters(),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text("Generating Report..."),
                        ],
                      ),
                    )
                  : reportData.isEmpty
                      ? const Center(child: Text("No data. Tap Generate Report"))
                      : Center(
                          child: _buildAttendanceTable(headerStyle),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    if (_loadingDropdowns) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _siteDropdown(),
        _departmentDropdown(),
        _monthPicker(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: _fetchReport,
              icon: const Icon(Icons.bar_chart_rounded, color: Colors.white),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Text(
                  "Generate Report",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 4,
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _downloadReport,
              icon: const Icon(Icons.download_rounded, color: Colors.white),
              label: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: Text(
                  "Download PDF",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 4,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _siteDropdown() {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<Site>(
        value: _selectedSite,
        decoration: const InputDecoration(
          labelText: "Site",
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12)
        ),
        isExpanded: true,
        items: _sites.map((site) => DropdownMenuItem<Site>(
          value: site,
          child: Text(
            site.name ?? site.id?.toString() ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15),
          ),
        )).toList(),
        onChanged: (site) => setState(() => _selectedSite = site),
      ),
    );
  }

  Widget _departmentDropdown() {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<Department>(
        value: _selectedDepartment,
        decoration: const InputDecoration(
          labelText: "Department",
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 12)
        ),
        isExpanded: true,
        items: _departments.map((dept) => DropdownMenuItem<Department>(
          value: dept,
          child: Text(
            dept.name ?? "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15),
          ),
        )).toList(),
        onChanged: (dept) => setState(() => _selectedDepartment = dept),
      ),
    );
  }

  Widget _monthPicker() {
    return SizedBox(
      width: 180,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: "Month",
          border: OutlineInputBorder()
        ),
        child: InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              initialDatePickerMode: DatePickerMode.year,
              helpText: "Select month & year",
            );
            if (date != null) {
              setState(() {
                _selectedMonth = DateFormat('yyyy-MM').format(date);
                daysInMonth = DateUtils.getDaysInMonth(date.year, date.month);
              });
            }
          },
          child: Text(_selectedMonth ?? 'Select Month'),
        ),
      ),
    );
  }


  double _colWidth(int index) {
    if (index == 0) return 60;
    if (index == 1) return 140;
    if (index == 2) return 80;
    return 40;
  }

  String _headerLabel(int col) {
    if (col == 0) return "S.No";
    if (col == 1) return "Name";
    if (col == 2) return "ID";
    if (col >= 3 && col < 3 + daysInMonth) return "${col - 2}".padLeft(2, '0');
    if (col == 3 + daysInMonth) return "P";
    if (col == 4 + daysInMonth) return "A";
    return "";
  }

  String _dataLabel(int row, int col) {
    final emp = reportData[row];
    final daily = emp['daily'] as List<String>;
    final totP = daily.where((d) => d == "P").length;
    final totA = daily.where((d) => d == "A").length;

    if (col == 0) return "${row + 1}";
    if (col == 1) return emp["name"];
    if (col == 2) return emp["empId"];
    if (col >= 3 && col < 3 + daysInMonth) return daily[col - 3];
    if (col == 3 + daysInMonth) return "$totP";
    if (col == 4 + daysInMonth) return "$totA";
    return "";
  }

  Widget _buildCell(String text, TextStyle? style, {bool isHeader = false}) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey.shade200 : Colors.white,
        border: Border(
            right: BorderSide(color: Colors.grey.shade300),
            bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Text(text,
          style: style,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center),
    );
  }

  Widget _buildAttendanceTable(TextStyle? headerStyle) {
    final cols = 3 + daysInMonth + 2;

    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.center,
            child: TableView.builder(
              columnCount: cols,
              rowCount: reportData.length + 1, // +1 for header
              pinnedColumnCount: 3,
              pinnedRowCount: 1,
              mainAxis: Axis.vertical,
              verticalDetails: ScrollableDetails(direction: AxisDirection.down),
              columnBuilder: (i) => TableSpan(
                extent: FixedTableSpanExtent(_colWidth(i)),
              ),
              rowBuilder: (r) => TableSpan(
                extent: FixedTableSpanExtent(40),
              ),
              cellBuilder: (c, v) {
                final r = v.row, i = v.column;
                if (r == 0) {
                  return TableViewCell(child: _buildCell(_headerLabel(i), headerStyle, isHeader: true));
                } else {
                  return TableViewCell(child: _buildCell(_dataLabel(r - 1, i), const TextStyle(fontSize: 12)));
                }
              },
            ),
          ),
        ),
        if (reportData.isNotEmpty) ...[
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _currentPage > 1
                    ? () => _onPageChanged(_currentPage - 1)
                    : null,
              ),
              Text('Page $_currentPage of $_totalPages'),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _currentPage < _totalPages
                    ? () => _onPageChanged(_currentPage + 1)
                    : null,
              ),
            ],
          ),
        ],
      ],
    );
  }
}
