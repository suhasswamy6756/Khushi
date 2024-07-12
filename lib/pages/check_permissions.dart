import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:url_launcher/url_launcher.dart';

import '../service/auth/auth_gate.dart';

class StepperDemo extends StatefulWidget {
  @override
  _StepperDemoState createState() => _StepperDemoState();
}

class _StepperDemoState extends State<StepperDemo> with WidgetsBindingObserver {
  int _currentStep = 0;
  bool _isHealthConnectInstalled = false;
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfAppIsInstalled();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkIfAppIsInstalled();
    }
  }

  Future<void> _checkIfAppIsInstalled() async {
    try {
      bool result = await HealthConnectFactory.isAvailable();
      if (mounted) {
        setState(() {
          _isHealthConnectInstalled = result;
        });
        if (_isHealthConnectInstalled) {
          _checkPermissions();
        }
      }
    } catch (e) {
      print("Error checking HealthConnect availability: $e");
      if (mounted) {
        setState(() {
          _isHealthConnectInstalled = false;
        });
      }
    }
  }

  Future<void> _requestHealthConnectPermission() async {
    try {
      await HealthConnectFactory.requestPermissions([HealthConnectDataType.Steps]);
      _checkPermissions();
    } catch (e) {
      print("Error requesting Health Connect permission: $e");
    }
  }

  Future<void> _checkPermissions() async {
    try {
      bool result = await HealthConnectFactory.hasPermissions([HealthConnectDataType.Steps]);
      if (mounted) {
        setState(() {
          _isPermissionGranted = result;
          if (_isPermissionGranted) {
            _currentStep = 1;
          } else {
            _requestHealthConnectPermission();
          }
        });
      }
    } catch (e) {
      print("Error checking HealthConnect permissions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Connect Stepper'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Theme(
              data: ThemeData(
                primarySwatch: Colors.blue,
                colorScheme: ColorScheme.light(primary: Colors.black),
              ),
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: () {
                  setState(() {
                    if (_currentStep < 1) {
                      _currentStep += 1;
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AuthGate()),
                      );
                    }
                  });
                },
                onStepCancel: () {
                  setState(() {
                    if (_currentStep > 0) {
                      _currentStep -= 1;
                    }
                  });
                },
                steps: <Step>[
                  Step(
                    title: const Text('Install Health Connect'),
                    content: Column(
                      children: [
                        Text(_isHealthConnectInstalled
                            ? 'Health Connect installed successfully'
                            : 'Please install Health Connect to proceed.'),
                        if (!_isHealthConnectInstalled)
                          ElevatedButton(
                            onPressed: () async {
                              await installHealthConnect();
                            },
                            child: const Text('Install Health Connect'),
                          ),
                      ],
                    ),
                    isActive: _currentStep >= 0,
                    state: _isHealthConnectInstalled
                        ? StepState.complete
                        : StepState.indexed,
                  ),
                  Step(
                    title: const Text('Grant Permission'),
                    isActive: _currentStep >= 1,
                    state: _isPermissionGranted
                        ? StepState.complete
                        : StepState.indexed,
                    content: GestureDetector(
                      onTap: () {
                        if (_currentStep >= 1 && !_isPermissionGranted) {
                          _requestHealthConnectPermission();
                        }
                      },
                      child: const Text('Grant access to proceed'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blueAccent.withOpacity(0.1),
            child: const Text(
              'Follow these steps to connect your health data:\n\n'
                  '1. Install Health Connect: Install the Health Connect app to enable data synchronization.\n'
                  '2. Grant Permission: Allow the app to access your health data and also allow health connect to access data from your step tracking app.',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> installHealthConnect() async {
    try {
      launchUrl(
        Uri.parse("market://details?id=com.google.android.apps.healthdata"),
        mode: LaunchMode.externalApplication,
      );
      await Future.delayed(Duration(seconds: 30));
      _checkIfAppIsInstalled();
    } catch (e) {
      print("Error installing Health Connect: $e");
    }
  }
}
