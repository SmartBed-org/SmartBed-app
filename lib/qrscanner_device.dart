
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
          .maybePop(deviceUID)
          .then((value) => controller.resumeCamera());
    });
  }
}
