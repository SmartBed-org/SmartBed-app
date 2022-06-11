// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCreateBarcodePage extends StatefulWidget {
  final String title;
  final String qrcodeData;

  QRCreateBarcodePage({Key? key, required this.title, required this.qrcodeData})
      : super(key: key);

  @override
  _QRCreateBarcodePageState createState() => _QRCreateBarcodePageState();
}

class _QRCreateBarcodePageState extends State<QRCreateBarcodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Device QR code'),
        ),
        body: Center(
            child: Column(
          children: [
            Spacer(
              flex: 2,
            ),
            Expanded(
                flex: 2,
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 50),
                )),
            Spacer(),
            Expanded(
                flex: 10,
                child: QrImage(
                  data: widget.qrcodeData,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                )),
            Spacer(),
            Expanded(
              flex: 3,
              child: Text(
                'Please scan the barcode to\nconfigure the device',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Spacer(flex: 4),
          ],
        )));
  }
}
