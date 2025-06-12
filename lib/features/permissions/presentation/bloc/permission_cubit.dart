import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/permission_usecase.dart';

/// States for PermissionCubit
abstract class PermissionState {}

class PermissionInitial extends PermissionState {}
class PermissionGranted extends PermissionState {}
class PermissionDenied extends PermissionState {}
class PermissionPermanentlyDenied extends PermissionState {}
class PermissionError extends PermissionState {
  final String message;
  PermissionError(this.message);
}

/// Cubit for managing SMS permission state.
class PermissionCubit extends Cubit<PermissionState> {
  final PermissionUseCase _useCase;

  PermissionCubit(this._useCase) : super(PermissionInitial());

  /// Checks current SMS permission status.
  Future<void> checkPermission() async {
    try {
      final granted = await _useCase.hasSmsPermission();
      if (granted) {
        emit(PermissionGranted());
      } else {
        final isPermanentlyDenied = await _useCase.isPermanentlyDenied();
        if (isPermanentlyDenied) {
          emit(PermissionPermanentlyDenied());
        } else {
          emit(PermissionDenied());
        }
      }
    } catch (e) {
      emit(PermissionError(e.toString()));
    }
  }

  /// Requests SMS permission from the user.
  Future<void> requestPermission() async {
    try {
      final status = await _useCase.requestSmsPermission();
      if (status.isGranted) {
        emit(PermissionGranted());
      } else if (status.isPermanentlyDenied) {
        emit(PermissionPermanentlyDenied());
      } else {
        emit(PermissionDenied());
      }
    } catch (e) {
      emit(PermissionError(e.toString()));
    }
  }

  /// Opens app settings.
  Future<void> openAppSettings() async {
    try {
      await _useCase.openAppSettings();
    } catch (e) {
      emit(PermissionError(e.toString()));
    }
  }
} 