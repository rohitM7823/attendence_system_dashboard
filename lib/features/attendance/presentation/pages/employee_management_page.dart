import 'dart:async';

import 'package:attendence_system_dashboard/data/apis.dart';
import 'package:attendence_system_dashboard/features/attendance/presentation/pages/edit_employee.dart';
import 'package:attendence_system_dashboard/models/device.dart';
import 'package:attendence_system_dashboard/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmployeeManagementPage extends StatefulWidget {
  final Device? preselectedDevice;

  const EmployeeManagementPage({super.key, this.preselectedDevice});

  @override
  _EmployeeManagementPageState createState() => _EmployeeManagementPageState();
}

class _EmployeeManagementPageState extends State<EmployeeManagementPage> {
  List<Employee> employees = [];
  List<Employee> filteredEmployees = [];

  bool isLoading = false;
  bool isSearching = false;
  int currentPage = 1;
  bool hasMore = true;
  Timer? debounce;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchEmployees(reset: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        _fetchEmployees();
      }
    });
  }

  Future<void> _fetchEmployees({bool reset = false}) async {
    setState(() => isLoading = true);
    final newEmployees = await Apis.employees(page: reset ? 1 : currentPage);
    if (newEmployees != null && newEmployees.isNotEmpty) {
      setState(() {
        if (reset) {
          employees = newEmployees;
          currentPage = 2;
        } else {
          employees.addAll(newEmployees);
          currentPage++;
        }
        filteredEmployees = List.from(employees);
      });
    } else {
      setState(() => hasMore = false);
    }
    setState(() => isLoading = false);
  }

  Future<void> _searchEmployees(String keyword) async {
    debounce?.cancel();
    setState(() {
      isSearching = true;
      isLoading = true;
    });
    debounce = Timer(
      const Duration(milliseconds: 400),
      () async {
        final results = await Apis.employees(search: keyword);
        setState(() {
          filteredEmployees = results ?? [];
          isLoading = false;
        });
      },
    );
  }

  Future<void> _deleteEmployee(Employee employee) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Employee"),
        content: Text("Are you sure you want to delete ${employee.name}?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Cancel")),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Delete")),
        ],
      ),
    );
    if (confirm == true) {
      final result = await Apis.deleteEmployee(employee.id);
      if (result == true) {
        setState(() {
          employees.removeWhere((e) => e.id == employee.id);
          filteredEmployees.removeWhere((e) => e.id == employee.id);
        });
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      isSearching = false;
      filteredEmployees = List.from(employees);
    });
  }

  void _editEmployee(Employee employee) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UpdateEmployeeForm(employee: employee)),
    );
    if (result == true) {
      _fetchEmployees(reset: true);
    }
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.search),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  _clearSearch();
                } else {
                  _searchEmployees(value);
                }
              },
              decoration: const InputDecoration(
                hintText: 'Search by name, mobile, site...',
                border: InputBorder.none,
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
            ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(Employee emp) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${emp.name}',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text("Emp ID: ${emp.empId} | Aadhaar: ${emp.aadharCard}"),
          Text("Mobile: ${emp.mobileNumber} | Site: ${emp.siteName}"),
          Text("Address: ${emp.address}"),
          Text(
              "Shift Time Window(Start|End): ${_formatDate(emp.shift?.clockInWindow?.start, format: 'hh:mm a')} - ${_formatDate(emp.shift?.clockInWindow?.end, format: 'hh:mm a')} | ${_formatDate(emp.shift?.clockOutWindow?.start, format: 'hh:mm a')} - ${_formatDate(emp.shift?.clockOutWindow?.end, format: 'hh:mm a')}"),
          Text('Account Number: ${emp.accountNumber}'),
          Text('Department: ${emp.department?.name ?? 'N/A'}'),
          const Divider(),
          Text("Clock In: ${_formatDate(emp.clockInTime)}"),
          Text("Clock Out: ${_formatDate(emp.clockOutTime)}"),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _editEmployee(emp),
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _deleteEmployee(emp),
                icon: const Icon(Icons.delete),
                label: const Text("Delete"),
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              ),
            ],
          )
        ],
      ),
    );
  }

  String _formatDate(DateTime? dt, {String format = 'MMM d, yyyy hh:mm a'}) {
    return dt != null ? DateFormat(format).format(dt) : 'N/A';
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dataToShow = isSearching ? filteredEmployees : employees;

    return Scaffold(
      appBar: widget.preselectedDevice != null
          ? AppBar(
              title: const Text('Employee Management'),
              leading: BackButton(color: Colors.black),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: dataToShow.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < dataToShow.length) {
                    return _buildEmployeeCard(dataToShow[index]);
                  } else {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
