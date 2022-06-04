// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';

import 'package:smart_bed/device.dart';

class QRScannerDeviceScreen extends StatefulWidget {
  const QRScannerDeviceScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerDeviceScreen> createState() => _QRScannerDeviceScreenState();
}

class _QRScannerDeviceScreenState extends State<QRScannerDeviceScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR'); // TODO:

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('QR code')),
        body: Stack(alignment: Alignment.center, children: [
          buildQrView(context),
          const Align(
            child: Text('Scan device'),
            alignment: Alignment(0.0, 0.5),
          ),
        ]));
  }

  // defines the scanning area
  Widget buildQrView(BuildContext context) {
    return QRView(
        key: (qrKey),
        onQRViewCreated: onQrViewCreated,
        overlay: QrScannerOverlayShape(
            borderWidth: 15,
            borderRadius: 5,
            borderColor: Colors.black));
  }

  void onQrViewCreated(QRViewController controller) {
    controller.scannedDataStream.listen((barcode) async {
      controller.pauseCamera();
      String barcodeInfo = barcode.code.toString();
      Map prescriptionMap = json.decode(barcodeInfo);

      Device? device;

      try {
        device = Device.fromJson(prescriptionMap);
      } catch (e) {
        device = null;
      }

      Navigator.of(context).maybePop(device).then((value) => controller.resumeCamera());
    });
  }
}
