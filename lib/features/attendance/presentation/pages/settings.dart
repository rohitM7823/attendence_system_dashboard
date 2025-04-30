import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay? _clockIn;
  TimeOfDay? _clockOut;
  TimeOfDay? _windowStart;
  TimeOfDay? _windowEnd;
  final _radiusController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _pickTime(BuildContext context, TimeOfDay? currentValue,
      Function(TimeOfDay) onPicked) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: currentValue ?? TimeOfDay.now(),
    );
    if (picked != null) {
      onPicked(picked);
    }
  }

  Widget buildTimeField(String label, TimeOfDay? time, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              time != null ? time.format(context) : 'Select time',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.number,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        const SizedBox(height: 8),
        Focus(
          child: Builder(builder: (context) {
            return TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  BorderSide(color: Colors.grey.shade300, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.indigo, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.red.shade400, width: 2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  bool get _isFormValid {
    return !_isSubmitting &&
        _clockIn != null &&
        _clockOut != null &&
        _windowStart != null &&
        _windowEnd != null &&
        int.tryParse(_radiusController.text) != null;
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_clockIn == null || _clockOut == null || _windowStart == null || _windowEnd == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select all time fields")));
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() => _isSubmitting = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Saved"),
        content: Text(
          "Clock In: ${_clockIn!.format(context)}\n"
              "Clock Out: ${_clockOut!.format(context)}\n"
              "Radius: ${_radiusController.text} meters\n"
              "Window: ${_windowStart!.format(context)} - ${_windowEnd!.format(context)}",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Card(
            elevation: 6,
            shadowColor: Colors.black12,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                onChanged: () => setState(() {}),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Settings',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: buildTimeField('Clock In Time', _clockIn,
                                  () => _pickTime(context, _clockIn, (t) => setState(() => _clockIn = t))),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: buildTimeField('Clock Out Time', _clockOut,
                                  () => _pickTime(context, _clockOut, (t) => setState(() => _clockOut = t))),
                        ),
                      ],
                    ),
                    buildTextField(
                      label: 'Radius (meters)',
                      controller: _radiusController,
                      validator: (value) {
                        final r = int.tryParse(value ?? '');
                        if (r == null || r <= 0) return 'Enter valid radius';
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: buildTimeField('Attendance Start', _windowStart,
                                  () => _pickTime(context, _windowStart, (t) => setState(() => _windowStart = t))),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: buildTimeField('Attendance End', _windowEnd,
                                  () => _pickTime(context, _windowEnd, (t) => setState(() => _windowEnd = t))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isFormValid ? _submit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          disabledBackgroundColor: Colors.grey.shade300,
                          disabledForegroundColor: Colors.grey.shade700,
                        ),
                        child: _isSubmitting
                            ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text('Save Settings',
                            style: TextStyle(fontSize: 16)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
