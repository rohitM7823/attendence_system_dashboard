import 'package:attendence_system_dashboard/data/apis.dart';
import 'package:flutter/material.dart';

class AddSitePage extends StatefulWidget {
  @override
  _AddSitePageState createState() => _AddSitePageState();
}

class _AddSitePageState extends State<AddSitePage> {
  final _formKey = GlobalKey<FormState>();
  final _siteNameController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  final _radiusController = TextEditingController();

  bool _isSubmitting = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    await Apis.addSite({
      'name': _siteNameController.text,
      'location': {
        'lat': double.parse(_latController.text),
        'lng': double.parse(_lngController.text)
      },
      'radius': int.parse(_radiusController.text),
    }).then(
      (value) {
        if (value == true) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("Submitted"),
              content: Text("✔ Site: ${_siteNameController.text}\n"
                  "✔ Lat: ${_latController.text}, Lng: ${_lngController.text}\n"
                  "✔ Radius: ${_radiusController.text} m"),
            ),
          );
        }
      },
    );

    setState(() => _isSubmitting = false);
  }

  Widget buildField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        const SizedBox(height: 8),
        Focus(
          child: Builder(builder: (context) {
            final hasFocus = Focus.of(context).hasFocus;
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
                  borderSide:
                      BorderSide(color: Colors.red.shade400, width: 1.5),
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
        _siteNameController.text.trim().isNotEmpty &&
        double.tryParse(_latController.text) != null &&
        double.tryParse(_lngController.text) != null &&
        int.tryParse(_radiusController.text) != null;
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
                  children: [
                    Text('Site Info',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87)),
                    const SizedBox(height: 24),
                    buildField(
                      label: 'Site Name',
                      controller: _siteNameController,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Site name is required'
                              : null,
                    ),
                    buildField(
                      label: 'Latitude',
                      controller: _latController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        final lat = double.tryParse(value ?? '');
                        if (lat == null || lat < -90 || lat > 90) {
                          return 'Latitude must be between -90 and 90';
                        }
                        return null;
                      },
                    ),
                    buildField(
                      label: 'Longitude',
                      controller: _lngController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        final lng = double.tryParse(value ?? '');
                        if (lng == null || lng < -180 || lng > 180) {
                          return 'Longitude must be between -180 and 180';
                        }
                        return null;
                      },
                    ),
                    buildField(
                      label: 'Radius (meters)',
                      controller: _radiusController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        final radius = int.tryParse(value ?? '');
                        if (radius == null || radius <= 0) {
                          return 'Radius must be > 0';
                        }
                        return null;
                      },
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
                            : Text('Submit', style: TextStyle(fontSize: 16)),
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
