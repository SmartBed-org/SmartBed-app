// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCreateBarcodePage extends StatefulWidget {
  final qrcodeData;

  const QRCreateBarcodePage({required this.qrcodeData});

  @override
  _QRCreateBarcodePageState createState() => _QRCreateBarcodePageState();
}

class _QRCreateBarcodePageState extends State<QRCreateBarcodePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Device QRCode'),
        ),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
	      // TODO:
                Align(child: Text('title', style: TextStyle(fontSize: 40),)),
                SizedBox(height: 50,),
                QrImage(
                  data: widget.qrcodeData,
                  size: 250,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: 20,),
                Align(child: Text('Please scan to\n...', textAlign: TextAlign.center,style: TextStyle(fontSize: 25),))
                ,SizedBox(height: 100,),

                //buildTextField(context),
              ],
            )));
  }
}
