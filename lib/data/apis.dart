import 'dart:convert';
import 'dart:developer';

import 'package:attendence_system_dashboard/models/device.dart';
import 'package:attendence_system_dashboard/models/employee.dart';
import 'package:http/http.dart' as http;

class Apis {
  
  static const BASE_URL = 'https://gsa.ezonedigital.com/api';
  
  static Future<List<Device>?> registeredDevices() async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/device/all'),
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

  static Future<List<Device>?> approvedDevices() async {
    try {
      final response = await http.get(
          Uri.parse('$BASE_URL/devices/approved'),
          headers: {'platform': 'web'});
      if (response.statusCode == 200) {
        final List<dynamic> deviceList = json.decode(response.body)['devices'];
        return deviceList.map((e) => Device.fromJson(e)).toList();
      }
    } catch (ex) {
      log(ex.toString(), name: 'APPROVED_DEVICE_ISSUE');
      return null;
    }

    return null;
  }

  static Future<bool> updateDeviceStatus(
      String status, String deviceToken) async {
    try {
      final response = await http.post(
          Uri.parse('$BASE_URL/device/status'),
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
          Uri.parse('$BASE_URL/device/all'),
          headers: {
            'platform': 'web',
          });
    } catch (ex) {
      log(ex.toString(), name: 'DELETE_DEVICES_ISSUE');
    }
  }

  static Future<List<Employee>?> employees() async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/employee/all'),
      );
      if (response.statusCode == 200) {
        return List<Employee>.from(json
            .decode(response.body)['employees']!
            .map((e) => Employee.fromJson(e)));
      }
    } catch (ex) {
      log(ex.toString(), name: 'EMPLOYEES_ISSUE');
      return null;
    }

    return null;
  }

  static Future<bool?> addSite(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(Uri.parse('$BASE_URL/site/add'),  headers: {
        'Content-Type': 'application/json',
      }, body: jsonEncode(data));
      if (response.statusCode == 200) {
        return json.decode(response.body)['status'] as bool?;
      }
    } catch (ex) {
      log(ex.toString(), name: 'ADD_SITE_ISSUE');
      return null;
    }

    return null;
  }

  static Future<bool?> addShift(Map<String, dynamic> data) async {
    try {
      final response =
          await http.post(Uri.parse('$BASE_URL/shifts'),
              headers: {
                'Content-Type': 'application/json',
              },
              body: jsonEncode(data));
      return true;
    } catch (ex) {
      log(ex.toString(), name: 'ADD_SHIFT_ISSUE');
      return null;
    }
  }

  static Future<List<Shift>?> shifts() async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/shifts'),
      );
      if (response.statusCode == 200) {
        return List<Shift>.from(json
            .decode(response.body)['shifts']!
            .map((e) => Shift.fromJson(e)));
      }
      return null;
    } catch (ex) {
      log(ex.toString(), name: 'SHIFTS_ISSUE');
      return null;
    }
  }
}
