import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_bed/device.dart';
import 'package:smart_bed/device_uid.dart';
import 'package:smart_bed/firestore/firestore_devices.dart';

import 'QR_generator.dart';

class DeviceConfigurationScreen extends StatefulWidget {
  final String title;
  final bool isNewDevice;
  final Device? device;

  const DeviceConfigurationScreen({Key? key, required this.title, required this.isNewDevice, this.device})
      : super(key: key);

  @override
  State<DeviceConfigurationScreen> createState() => _DeviceConfigurationScreenState();
}

class _DeviceConfigurationScreenState extends State<DeviceConfigurationScreen> {
  final _uidTextEditingController = TextEditingController();
  final _roomNumberTextEditingController = TextEditingController();
  final _bedNumberTextEditingController = TextEditingController();

  bool _inEditMode = false;

  late FocusNode myFocusNode;
  final _formKey = GlobalKey<FormState>();

  late bool _isButtonEnabled;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (widget.device != null) {
      _uidTextEditingController.text = widget.device!.uid.uid;
      _roomNumberTextEditingController.text = widget.device!.roomNumber;
      _bedNumberTextEditingController.text = widget.device!.bedNumber;
    }

    _isButtonEnabled = !isEnyFieldEmpty();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Form(
          key: _formKey,
          onChanged: () {
            if (_isButtonEnabled == isEnyFieldEmpty()) {
              setState(() => _isButtonEnabled = !_isButtonEnabled);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Expanded(
                    flex: 4,
                    child: TextFormField(
                      enabled: widget.isNewDevice,
                      autofocus: widget.isNewDevice,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: _uidTextEditingController,
                      decoration: const InputDecoration(
                        labelText: "Device UID",
                      ),
                    )),
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    enabled: widget.isNewDevice || _inEditMode,
                    focusNode: myFocusNode,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: _roomNumberTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "Room number",
                    ),
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: TextFormField(
                      enabled: widget.isNewDevice || _inEditMode,
                      controller: _bedNumberTextEditingController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Bed number',
                      ),
                    )),
                const Spacer(),
                Expanded(
                  flex: 3,
                  child: getButton(context),
                ),
                const Spacer(flex: 12),
              ],
            ),
          ),
        ));
  }

  ElevatedButton getButton(BuildContext context) {
    ElevatedButton button;

    if (widget.isNewDevice) {
      button = getCreateButton(context);
    } else if (!_inEditMode) {
      button = getEditButton();
    } else {
      button = getSaveButton();
    }

    return button;
  }

  ElevatedButton getSaveButton() {
    return ElevatedButton(
        onPressed: !_isButtonEnabled
            ? null
            : () {
                final device = createDevice();

                FirestoreDevices.instance().setDevices(device);
                Navigator.of(context).pop();
              },
        child: const Text('Save', style: TextStyle(fontSize: 30.0)));
  }

  ElevatedButton getEditButton() {
    return ElevatedButton(
        onPressed: () {
          myFocusNode.requestFocus();
          setState(() => _inEditMode = !_inEditMode);
        },
        child: const Text('Edit', style: TextStyle(fontSize: 30.0)));
  }

  ElevatedButton getCreateButton(BuildContext context) {
    return ElevatedButton(
        onPressed: isEnyFieldEmpty()
            ? null
            : () {
                final device = createDevice();

                FirestoreDevices.instance().setDevices(device);

                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => QRCreateBarcodePage(
                        title: 'Device ${device.uid.uid}',
                        qrcodeData: json.encode(device.uid))));
              },
        child: const Text('Create', style: TextStyle(fontSize: 30.0)));
  }

  Device createDevice() {
    return Device(
        uid: DeviceUID(uid: _uidTextEditingController.text),
        roomNumber: _roomNumberTextEditingController.text,
        bedNumber: _bedNumberTextEditingController.text);
  }

  bool isEnyFieldEmpty() {
    return _uidTextEditingController.text.isEmpty ||
        _roomNumberTextEditingController.text.isEmpty ||
        _bedNumberTextEditingController.text.isEmpty;
  }
}
