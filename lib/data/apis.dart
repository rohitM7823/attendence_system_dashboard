import 'dart:convert';
import 'dart:developer';

import 'package:attendence_system_dashboard/models/device.dart';
import 'package:http/http.dart' as http;

class Apis {
  static Future<List<Device>?> registeredDevices() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.5:8000/api/device/all'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> deviceList = json.decode(response.body)['devices'];
        return deviceList.map((e) => Device.fromJson(e)).toList();
      }
    } catch (ex) {
      log(ex.toString(), name: 'REGISTER_DEVICE_ISSUE');
      return null;
    }

    return null;
  }

  static Future<bool> updateDeviceStatus(
      String status, String deviceToken) async {
    try {
      final response = await http.post(
          Uri.parse('http://192.168.0.5:8000/api/device/status'),
          headers: {
            'device_token': deviceToken,
            'platform': 'web',
          },
          body: {
            'status': status
          });
      if (response.statusCode == 200) {
        final String? status = json.decode(response.body)['status'];
        return status != null;
      }
    } catch (ex) {
      log(ex.toString(), name: 'UPDATE_DEVICE_STATUS_ISSUE');
      return false;
    }

    return false;
  }

  static Future<void> deleteDevices() async {
    try {
      final response = await http.delete(
          Uri.parse('http://192.168.0.5:8000/api/device/all'),
          headers: {
            'platform': 'web',
          });

    } catch (ex) {
      log(ex.toString(), name: 'DELETE_DEVICES_ISSUE');
    }
  }
}
