import 'package:flutter/material.dart';

// class AdvancedRootDetectionScreen extends StatefulWidget {
//   const AdvancedRootDetectionScreen({super.key});

//   @override
//   State<AdvancedRootDetectionScreen> createState() =>
//       _AdvancedRootDetectionScreenState();
// }

// class _AdvancedRootDetectionScreenState
//     extends State<AdvancedRootDetectionScreen> {
//   static const platform = MethodChannel('com.exceletacademy.lms/root_check');
//   bool? _isRooted;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Advanced Root/Jailbreak Detection'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _buildDetectionResult(),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _checkRootStatus,
//               child: const Text('Recheck Root Status'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     _checkRootStatus();
//   }

//   Widget _buildDetectionResult() {
//     if (_isRooted == null) {
//       return const Text("Checking root status...");
//     } else if (_isRooted!) {
//       return const Text("Device is likely ROOTED/JAILBROKEN!",
//           style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold));
//     } else {
//       return const Text("Device does not appear to be rooted/jailbroken.",
//           style: TextStyle(color: Colors.green));
//     }
//   }

//   Future<void> _checkRootStatus() async {
//     try {
//       final bool result = await platform.invokeMethod('isDeviceRooted');
//       setState(() {
//         _isRooted = result;
//       });
//     } on PlatformException catch (e) {
//       debugPrint("Error checking root status: '${e.message}'");
//       setState(() {
//         _isRooted = null;
//       });
//     }
//   }
// }

class AdvancedRootDetectionScreen extends StatefulWidget {
  const AdvancedRootDetectionScreen({super.key});

  @override
  State<AdvancedRootDetectionScreen> createState() =>
      _AdvancedRootDetectionScreenState();
}

class _AdvancedRootDetectionScreenState
    extends State<AdvancedRootDetectionScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Rooted Phone Detected!."),
      ),
    );
  }
}
