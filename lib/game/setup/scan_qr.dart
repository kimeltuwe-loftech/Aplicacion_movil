// import 'package:flutter/material.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'select_team.dart';

// class QrScanScreen extends StatefulWidget {
//   const QrScanScreen({super.key});

//   @override
//   State<QrScanScreen> createState() => _QrScanScreenState();
// }

// class _QrScanScreenState extends State<QrScanScreen> {
//   final MobileScannerController _controller = MobileScannerController();
//   bool _handled = false;

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _onDetect(BarcodeCapture capture) {
//     if (_handled) return;

//     final barcodes = capture.barcodes;
//     if (barcodes.isEmpty) return;

//     final raw = barcodes.first.rawValue;
//     if (raw == null || raw.isEmpty) return;

//     _handled = true;
    
//     List<String> stringValues = raw.split(',');
//     int amountOfTeams = int.parse(stringValues[0]);
//     String sentence = stringValues[1];
//     // todo: read QR code

//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => SelectTeam(amountOfTeams: amountOfTeams, sentence: sentence)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan QR'),
//         actions: [
//           IconButton(
//             tooltip: 'Torch',
//             onPressed: () => _controller.toggleTorch(),
//             icon: const Icon(Icons.flash_on),
//           ),
//           IconButton(
//             tooltip: 'Switch camera',
//             onPressed: () => _controller.switchCamera(),
//             icon: const Icon(Icons.cameraswitch),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           MobileScanner(controller: _controller, onDetect: _onDetect),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               color: Colors.black54,
//               child: const Text(
//                 'Point the camera at a QR code to read its text.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           Center(
//             child: Container(
//               width: 260,
//               height: 260,
//               decoration: BoxDecoration(
//                 border: Border.all(width: 3),
//                 borderRadius: BorderRadius.circular(16),
//                 color: Colors.transparent,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
