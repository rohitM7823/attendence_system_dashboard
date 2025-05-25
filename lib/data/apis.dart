import 'dart:convert';
import 'dart:developer';

import 'package:attendence_system_dashboard/models/department.dart';
import 'package:attendence_system_dashboard/models/device.dart';
import 'package:attendence_system_dashboard/models/employee.dart';
import 'package:http/http.dart' as http;

class Apis {
  static const BASE_URL = 'https://gsa.ezonedigital.com/api'; //'http://192.168.0.2:8000/api';

  static Future<String?> login(String userId, String password) async {
    try {
      //log({'user_id': userId, 'password': password}.toString(), name: 'BODY');
      final response = await http.post(Uri.parse('$BASE_URL/admin/login'),
          body: {'admin_id': userId, 'password': password});

      //log(response.statusCode.toString(), name: 'LOGIN');
      if (response.statusCode == 200) {
        //log(json.decode(response.body)['token'] as String, name: 'LOGIN');
        return json.decode(response.body)['token'] as String?;
      }
      return null;
    } catch (ex) {
      rethrow;
    }
  }

  static Future<bool> logout(String token) async {
    try {
      final response = await http.post(Uri.parse('$BASE_URL/admin/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });
      log('${response.statusCode}', name: 'LOGOUT');
      return response.statusCode == 200;
    } catch (ex) {
      rethrow;
    }
  }

  static Future<bool> forgotPassword(String adminId, String newPassword) async {
    try {
      final response = await http.post(
          Uri.parse('$BASE_URL/admin/forgot-password'),
          body: {'admin_id': adminId, 'new_password': newPassword});

      log(response.body.toString(), name: 'FORGOT_PASSWORD');
      return response.statusCode == 200;
    } catch (ex) {
      rethrow;
    }
  }

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
      final response = await http.get(Uri.parse('$BASE_URL/devices/approved'),
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
      final response =
          await http.post(Uri.parse('$BASE_URL/device/status'), headers: {
        'device_token': deviceToken,
        'platform': 'web',
      }, body: {
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
      final response =
          await http.delete(Uri.parse('$BASE_URL/device/all'), headers: {
        'platform': 'web',
      });
    } catch (ex) {
      log(ex.toString(), name: 'DELETE_DEVICES_ISSUE');
    }
  }

  static Future<List<Employee>?> employees(
      {String search = '', int? page = 1, int limit = 10}) async {
    try {
      final response = await http.get(
        Uri.parse(
            '$BASE_URL/employee/all?search=$search&page=$page&limit=$limit'),
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
      final response = await http.post(Uri.parse('$BASE_URL/site/add'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data));
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
      final response = await http.post(Uri.parse('$BASE_URL/shifts'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(data));
      log('${response.body}', name: 'ADD_SHIFT');
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
      log('${response.body}', name: 'SHIFTS');
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

  static Future<List<Site>?> availableSties({String search = ''}) async {
    try {
      final response =
          await http.get(Uri.parse('$BASE_URL/sites?search=$search'), headers: {
        'platform': 'web',
      });
      return List.from(
          json.decode(response.body)['sites']!.map((e) => Site.fromJson(e)));
    } catch (ex) {
      log(ex.toString(), name: 'AVAILABLE_STIES_ISSUE');
      return null;
    }
  }

  static Future<bool?> updateEmployee(Employee employee) async {
    try {
      final response =
          await http.post(Uri.parse('$BASE_URL/employee/${employee.id}/update'),
              headers: {
                'platform': 'web',
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
              body: jsonEncode(employee.toJson()));
      if (response.statusCode == 200) {
        log("${jsonDecode(response.body)['status'] as bool?}",
            name: 'ÚPDATE_EMPLOYEE');
        return jsonDecode(response.body)['status'] as bool?;
      }
      return null;
    } catch (ex) {
      log(ex.toString(), name: 'UPDATE_EMPLOYEE_ISSUE');
      return null;
    }
  }

  static Future<bool?> updateSite(Site site) async {
    try {
      final response = await http.put(Uri.parse('$BASE_URL/site/${site.id}'),
          headers: {
            'platform': 'web',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(site.toJson()));
      log("${response.statusCode}", name: 'ÚPDATE_SITE');
      if (response.statusCode == 200) {
        log("${jsonDecode(response.body)['status'] as bool?}",
            name: 'ÚPDATE_SITE');
        return jsonDecode(response.body)['status'] as bool?;
      }
      return null;
    } catch (ex) {
      log(ex.toString(), name: 'UPDATE_SITE_ISSUE');
      return null;
    }
  }

  static Future<bool?> deleteEmployee(int? id) async {
    try {
      final response = await http.delete(
          Uri.parse('$BASE_URL/employee/$id/delete'),
          headers: {'platform': 'web'});
      if (response.statusCode == 200) {
        return true;
      }
      return null;
    } catch (ex) {
      log(ex.toString(), name: 'DELETE_EMPLOYEE_ISSUE');
      return null;
    }
  }

  static Future<bool?> deleteSite(String siteId) async {
    try {
      final response = await http.delete(Uri.parse('$BASE_URL/site/$siteId'),
          headers: {'platform': 'web'});
      if (response.statusCode == 200) {
        return true;
      }
      return null;
    } catch (ex) {
      log(ex.toString(), name: 'DELETE_SITE_ISSUE');
      return null;
    }
  }

  static Future<bool> addDepartment(String name) async {
    try {
      final response = await http.post(Uri.parse('$BASE_URL/departments/add'),
          body: jsonEncode({'name': name}),
          headers: {
            'platform': 'web',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          });
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['department'] != null;
      }
      return false;
    } catch (ex) {
      log(ex.toString(), name: 'ADD_DEPARTMENT_ISSUE');
      return false;
    }
  }

  static Future<List<Department>> departments() async {
    try {
      final response = await http.get(Uri.parse('$BASE_URL/departments'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['departments']
            .map<Department>((e) => Department.fromJson(e))
            .toList();
      }
      return [];
    } catch (ex) {
      log(ex.toString(), name: 'DEPARTMENTS_ISSUE');
      return [];
    }
  }

  static Future<bool> deleteDepartment(int id) async {
    try {
      final response =
          await http.delete(Uri.parse('$BASE_URL/departments/$id'));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (ex) {
      log(ex.toString(), name: 'DELETE_DEPARTMENT_ISSUE');
      return false;
    }
  }

  static Future<bool> updateDepartment(Department department) async {
    try {
      final response =
          await http.put(Uri.parse('$BASE_URL/departments/${department.id}'),
              headers: {
                'platform': 'web',
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
              body: jsonEncode(department.toJson()));
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (ex) {
      log(ex.toString(), name: 'UPDATE_DEPARTMENT_ISSUE');
      return false;
    }
  }
}
