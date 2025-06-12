import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Request SMS permission
  Future<PermissionStatus> requestSmsPermission() async {
    return await Permission.sms.request();
  }

  /// Check if SMS permission is granted
  Future<bool> hasSmsPermission() async {
    final status = await Permission.sms.status;
    return status.isGranted;
  }

  /// Check if permission is permanently denied
  Future<bool> isPermanentlyDenied() async {
    final status = await Permission.sms.status;
    return status.isPermanentlyDenied;
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    return await openAppSettings();
  }
} 