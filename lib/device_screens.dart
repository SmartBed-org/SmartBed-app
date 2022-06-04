
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'QR_generator.dart';


class DeviceScreen extends StatefulWidget {
  final bool is_new_device;

  DeviceScreen({required this.is_new_device});

  @override
  State<DeviceScreen> createState() =>
      _DeviceScreenState();
}

class _DeviceScreenState
    extends State<DeviceScreen> {
  final _roomNumberTextEditingController = TextEditingController();
  final _bedNumberTextEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Create new barcode'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const QRCreateBarcodePage(qrcodeData: 'uid')));
            }
          },
          label: Text('Create'),
          icon: Icon(Icons.add),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: _roomNumberTextEditingController,
                  decoration: InputDecoration(
                    labelText: "Room number",
                  ),
                  validator: (value) {
                    if (value == null || value == '') {
                      return "Room number can't be empty";
                    }
                  },
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: _bedNumberTextEditingController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Bed number',
                  ),
                  validator: (value) {
                    if (value == null || value == '') {
                      return "Bed number can't be empty";
                    }
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
