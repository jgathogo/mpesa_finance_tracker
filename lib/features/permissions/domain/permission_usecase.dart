import 'package:permission_handler/permission_handler.dart';
import '../data/permission_service.dart';

class PermissionUseCase {
  final PermissionService _permissionService;

  PermissionUseCase(this._permissionService);

  /// Request SMS permission
  Future<PermissionStatus> requestSmsPermission() async {
    return await _permissionService.requestSmsPermission();
  }

  /// Check if SMS permission is granted
  Future<bool> hasSmsPermission() async {
    return await _permissionService.hasSmsPermission();
  }

  /// Check if permission is permanently denied
  Future<bool> isPermanentlyDenied() async {
    return await _permissionService.isPermanentlyDenied();
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    return await _permissionService.openAppSettings();
  }
} 