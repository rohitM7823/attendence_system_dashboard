import 'package:attendence_system_dashboard/data/apis.dart';
import 'package:attendence_system_dashboard/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateEmployeeForm extends StatefulWidget {
  const UpdateEmployeeForm({super.key, required this.employee});

  final Employee employee;

  @override
  _UpdateEmployeeFormState createState() => _UpdateEmployeeFormState();
}

class _UpdateEmployeeFormState extends State<UpdateEmployeeForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();

  Site? _selectedSite;
  Shift? _selectedShift;

  List<Site> _sites = [];
  List<Shift> _shifts = [];

  bool _updateLoadingState = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _nameController.text = widget.employee.name ?? '';
        _employeeIdController.text = widget.employee.empId ?? '';
        _addressController.text = widget.employee.address ?? '';
        _accountNumberController.text = widget.employee.accountNumber ?? '';
        _aadharController.text = widget.employee.aadharCard ?? '';
        _mobileNumberController.text = widget.employee.mobileNumber ?? '';
        Apis.shifts().then(
          (value) {
            if (value?.isNotEmpty == true) {
              setState(() {
                _shifts = value!;
                _selectedShift = value.firstWhere(
                  (element) => element.id == widget.employee.shift?.id,
                );
              });
            }
          },
        );
        Apis.availableSties().then((value) {
          if (value?.isNotEmpty == true) {
            setState(() {
              _sites = value!;
              _selectedSite = value.firstWhere(
                (e) =>
                    e.name?.toLowerCase() ==
                    widget.employee.siteName?.toLowerCase(),
              );
            });
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F3FC),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Update Employee Info',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _buildTextField(_nameController, 'Employee Name'),
                _buildTextField(_employeeIdController, 'Employee ID'),
                _buildTextField(_addressController, 'Address'),
                _buildTextField(_accountNumberController, 'Account Number'),
                _buildTextField(_aadharController, 'Aadhar Card'),
                _buildTextField(_mobileNumberController, 'Mobile Number'),
                _buildDropdownSite(_sites, _selectedSite, 'Site', (value) {
                  setState(() => _selectedSite = value);
                }),
                _buildDropdown(_shifts, _selectedShift, 'Shift', (value) {
                  setState(() => _selectedShift = value);
                }),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _updateLoadingState = true);
                      Apis.updateEmployee(
                        Employee(
                          id: widget.employee.id,
                          name: _nameController.text.trim(),
                          empId: _employeeIdController.text.trim(),
                          address: _addressController.text.trim(),
                          accountNumber: _accountNumberController.text.trim(),
                          siteName: _selectedSite?.name,
                          shift: _selectedShift,
                          aadharCard: _aadharController.text.trim(),
                          mobileNumber: _mobileNumberController.text.trim(),
                        ),
                      ).then((value) {
                        setState(() {
                          _updateLoadingState = false;
                        });
                        if(value == true){

                        }
                      },);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildDropdown(List<Shift> items, Shift? selectedItem, String label,
      Function(Shift?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<Shift>(
        value: selectedItem,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        items: items.map((item) {
          return DropdownMenuItem(
              value: item,
              child: Text(
                  DateFormat('MMM d, yyyy hh:mm a').format(item.clockIn!)));
        }).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select $label' : null,
      ),
    );
  }

  Widget _buildDropdownSite(List<Site> items, Site? selectedItem, String label,
      Function(Site?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<Site>(
        value: selectedItem,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          isDense: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        items: items.map((item) {
          return DropdownMenuItem(value: item, child: Text(item.name ?? ''));
        }).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select $label' : null,
      ),
    );
  }
}
