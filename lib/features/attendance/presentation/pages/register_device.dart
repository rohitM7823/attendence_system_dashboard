import 'package:attendence_system_dashboard/data/apis.dart';
import 'package:attendence_system_dashboard/data/mock.dart';
import 'package:attendence_system_dashboard/models/device.dart';
import 'package:flutter/material.dart';

import 'employee_management_page.dart';

class RegisterDevicePage extends StatefulWidget {
  const RegisterDevicePage({super.key});

  @override
  _RegisterDevicePageState createState() => _RegisterDevicePageState();
}

class _RegisterDevicePageState extends State<RegisterDevicePage> {
  List<Device> devices = MockData.devices;


  @override
  initState() {
    super.initState();// Get the list of devices
    Apis.registeredDevices().then((value) {
      if(value != null) {
        setState(() {
          devices = value;
        });
      }
    },);
  }

  void _approveDevice(int index) async {
    await Apis.updateDeviceStatus('Approved', devices[index].token!).then(
      (value) {
        if (value) {
          setState(() {
            devices[index].status = 'Approved';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Device ${devices[index].name} Approved')),
          );
          //_showRedirectDialog(devices[index]);
        }
      },
    );
  }

  // Method to show a redirect confirmation dialog
  void _showRedirectDialog(Device? selectedDevice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Device Approved'),
          content: Text(
              'Device has been approved. Do you want to assign ${selectedDevice?.deviceId} to an Employee ?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog and stay on the current page
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EmployeeManagementPage(
                            preselectedDevice: selectedDevice,
                          )), // Redirect to the Device Management Page
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Reject Device
  Future<void> _rejectDevice(int index) async {
    await Apis.updateDeviceStatus('Rejected', devices[index].token!).then(
      (value) {
        setState(() {
          devices[index].status = 'Rejected';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Device ${devices[index].deviceId} Rejected')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: devices.isEmpty
            ? Center(child: Text('No devices pending approval.'))
            : ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  Device device = devices[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                          'Device Name: ${device.name} | Device Model: ${device.model}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          'Device Type: ${device.platform}\nStatus: ${device.isApproved == null ? 'Pending' : (device.isApproved! ? 'Approved' : 'Rejected')}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Approve Button with Icon and Text Change
                          TextButton.icon(
                            onPressed: device.isApproved == null
                                ? () => _approveDevice(index)
                                : null, // Disable if already approved/rejected
                            icon: Icon(Icons.check, color: Colors.green),
                            label: Text(
                              device.isApproved == true
                                  ? 'Approved'
                                  : 'Approve',
                              style: TextStyle(color: Colors.green),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: device.isApproved == null
                                  ? Colors.green.shade50
                                  : Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                          ),
                          SizedBox(width: 8),
                          // Reject Button with Icon and Text Change
                          TextButton.icon(
                            onPressed: device.isApproved == null
                                ? () => _rejectDevice(index)
                                : null, // Disable if already approved/rejected
                            icon: Icon(Icons.clear, color: Colors.red),
                            label: Text(
                              device.isApproved == false
                                  ? 'Rejected'
                                  : 'Reject',
                              style: TextStyle(color: Colors.red),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: device.isApproved == null
                                  ? Colors.red.shade50
                                  : Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
