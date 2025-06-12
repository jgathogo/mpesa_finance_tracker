import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/permission_cubit.dart';
import '../../domain/permission_usecase.dart';
import '../../data/permission_service.dart';
import '../../../home/presentation/pages/home_page.dart';

/// Page to request and display SMS permission status.
class PermissionPage extends StatelessWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PermissionCubit(PermissionUseCase(PermissionService())),
      child: BlocListener<PermissionCubit, PermissionState>(
        listener: (context, state) {
          if (state is PermissionGranted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('SMS Permission Required'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'This app needs access to your SMS messages to automatically track your M-Pesa transactions. Your data stays on your device and is never shared.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                BlocBuilder<PermissionCubit, PermissionState>(
                  builder: (context, state) {
                    if (state is PermissionGranted) {
                      return const Text(
                        'Permission granted! Redirecting...',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      );
                    } else if (state is PermissionDenied) {
                      return const Text(
                        'Permission denied. Please allow SMS access to continue.',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      );
                    } else if (state is PermissionPermanentlyDenied) {
                      return Column(
                        children: [
                          const Text(
                            'Permission permanently denied. Please enable it in app settings.',
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<PermissionCubit>().openAppSettings();
                            },
                            child: const Text('Open Settings'),
                          ),
                        ],
                      );
                    } else if (state is PermissionError) {
                      return Text(
                        'Error: ${state.message}',
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      );
                    } else {
                      return const Text(
                        'Permission status unknown. Please check or request permission.',
                        textAlign: TextAlign.center,
                      );
                    }
                  },
                ),
                const SizedBox(height: 32),
                BlocBuilder<PermissionCubit, PermissionState>(
                  builder: (context, state) {
                    if (state is! PermissionPermanentlyDenied) {
                      return ElevatedButton(
                        onPressed: () {
                          context.read<PermissionCubit>().requestPermission();
                        },
                        child: const Text('Request SMS Permission'),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 