import 'package:attendence_system_dashboard/data/apis.dart';
import 'package:attendence_system_dashboard/models/department.dart';
import 'package:flutter/material.dart';

class DepartmentManagementPage extends StatefulWidget {
  const DepartmentManagementPage({super.key});

  @override
  State<DepartmentManagementPage> createState() =>
      _DepartmentManagementPageState();
}

class _DepartmentManagementPageState extends State<DepartmentManagementPage> {
  List<Department> departments = [];
  bool addLoading = false;
  bool updateLoading = false;
  bool fetchLoading = false;

  List<Department> filteredDepartments = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allDepartments();
  }

  void _searchDepartments(String query) {
    final results = departments.where((dept) {
      return dept.name!.toLowerCase().contains(query.toLowerCase()) ||
          dept.id!.toString().contains(query.toLowerCase());
    }).toList();
    setState(() {
      filteredDepartments = results;
    });
  }

  void _addDepartment(String name) async {
    setState(() {
      addLoading = true;
    });
    final response = await Apis.addDepartment(name);
    setState(() {
      addLoading = false;
    });
    if (response) {
      final result = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Department Added"),
          content: Text("✔ Department: $name"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Close'))
          ],
        ),
      );
      if (result is bool && result) {
        _allDepartments();
      }
    }
  }

  void _allDepartments() async {
    setState(() {
      fetchLoading = true;
    });
    final data = await Apis.departments();
    setState(() {
      fetchLoading = false;
      departments = data;
      filteredDepartments = List.from(departments);
    });
  }

  void _updateDepartment(Department department) async {
    setState(() {
      updateLoading = true;
    });
    final response = await Apis.updateDepartment(department);
    setState(() {
      updateLoading = false;
    });
    if (response) {
      final result = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Department Updated"),
          content: Text("✔ Department: ${department.name}"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Close'))
          ],
        ),
      );
      if (result is bool && result) {
        _allDepartments();
      }
    }
  }

  void _editDepartment(Department department) {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController(text: department.name);
        return AlertDialog(
          title: const Text('Edit Department'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name')),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _updateDepartment(
                    department.copyWith(name: nameController.text.trim()));
              },
              child: const Text('Update'),
            )
          ],
        );
      },
    );
  }

  void _deleteDepartment(Department department) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Department'),
        content: Text('Are you sure you want to delete "${department.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              var result = await Apis.deleteDepartment(department.id!);
              if (result) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Department "${department.name}" deleted successfully'),
                    backgroundColor: Colors.red.shade600,
                  ),
                );
                setState(() {
                  departments.remove(department);
                  filteredDepartments = List.from(departments);
                });
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddDepartmentDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Department"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Department Name")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: !addLoading
                ? () {
                    if (nameController.text.isNotEmpty) {
                      _addDepartment(nameController.text);
                      Navigator.pop(context);
                    }
                  }
                : null,
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.search),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search departments...',
                border: InputBorder.none,
              ),
              onChanged: _searchDepartments,
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _searchDepartments('');
              },
            )
        ],
      ),
    );
  }

  Widget _buildDepartmentCard(Department dept) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${dept.name}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text("Department ID: ${dept.id}"),
          SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.edit, size: 18),
                label: Text("Edit"),
                onPressed: () => _editDepartment(dept),
              ),
              SizedBox(width: 10),
              ElevatedButton.icon(
                icon: Icon(Icons.delete, size: 18),
                label: Text("Delete"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => _deleteDepartment(dept),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Departments")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchBar(),
            fetchLoading
                ? const Expanded(
                    child: Center(
                    child: Text('Loading...'),
                  ))
                : filteredDepartments.isEmpty
                    ? const Expanded(
                        child: Center(
                        child: Text('No Departments are found!'),
                      ))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: filteredDepartments.length,
                          itemBuilder: (_, index) =>
                              _buildDepartmentCard(filteredDepartments[index]),
                        ),
                      ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDepartmentDialog,
        child: Icon(Icons.add),
        tooltip: "Add Department",
      ),
    );
  }
}
