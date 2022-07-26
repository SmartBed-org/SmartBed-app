
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';
import 'package:smart_bed/device_uid.dart';

class QRScannerDeviceScreen extends StatefulWidget {
  const QRScannerDeviceScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerDeviceScreen> createState() => _QRScannerDeviceScreenState();
}

class _QRScannerDeviceScreenState extends State<QRScannerDeviceScreen> {
  QRViewController? _controller;
  final qrKey = GlobalKey(debugLabel: 'QR'); // TODO:

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    }
    _controller!.resumeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('QR code')),
        body: Stack(alignment: Alignment.center, children: [
          buildQrView(context),
          const Align(
            child: Text(
              'Scan device QR code',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
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
            borderWidth: 15, borderRadius: 5, borderColor: Colors.black));
  }

  void onQrViewCreated(QRViewController controller) {
    _controller = controller;
    controller.resumeCamera();

    controller.scannedDataStream.listen((barcode) async {
      controller.pauseCamera();
      String barcodeInfo = barcode.code.toString();
      Map deviceUidMap = json.decode(barcodeInfo);

      DeviceUID? deviceUID;

      try {
        deviceUID = DeviceUID.fromJson(deviceUidMap);
      } catch (e) {
        deviceUID = null;
      }

      Navigator.of(context)
          .maybePop(deviceUID);
    });
  }
}
