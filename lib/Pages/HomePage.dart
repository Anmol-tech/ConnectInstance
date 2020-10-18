import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ssh/ssh.dart';
import 'package:xterm/flutter.dart';
import 'package:xterm/xterm.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SSHClient _client;
  Terminal _terminal;
  var _globalFormKey = GlobalKey<FormState>();
  String _pemKey;
  String username;
  var _ip;
  bool isConnected = false;

  Widget _getCommand() {
    _terminal = Terminal();
    _terminal.setShowCursor(false);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.4,
              child: TerminalView(terminal: _terminal),
            ),
            Row(
              children: [
                Text(
                  username + '\$',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                    cursorWidth: 6,
                    autofocus: true,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
                Material(
                  child: Icon(Icons.send),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isConnected ? _getCommand() : _getIpKey(),
          ],
        ),
      ),
    );
  }

  Widget _getIpKey() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      child: Center(
        child: Column(
          children: [
            Form(
              key: _globalFormKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) => _ipValidator(value.trim()),
                    onSaved: (newValue) => _ip = newValue.trim(),
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                    decoration: InputDecoration(
                      errorStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                      border: OutlineInputBorder(),
                      labelText: 'Server IP',
                      labelStyle: TextStyle(fontSize: 28),
                      hintText: '000.000.000.000',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      onSaved: (newValue) {
                        username = newValue;
                      },
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w900),
                        border: OutlineInputBorder(),
                        labelText: 'Username',
                        labelStyle: TextStyle(fontSize: 28),
                        hintText: 'root',
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: RaisedButton(
                onPressed: () => _pickKey(),
                color: Colors.cyan,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.vpn_key_rounded,
                      // color: Colors.tealAccent,
                    ),
                    Text(
                      'UPLOAD PEM KEY',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: RaisedButton(
                  color: Colors.green,
                  onPressed: () => _onConnect(),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.flash_on),
                        Text(
                          'Connect',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  _ipValidator(value) {
    var regex = RegExp(r'''^(25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.( 
            25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.( 
            25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)\.( 
            25[0-5]|2[0-4][0-9]|[0-1]?[0-9][0-9]?)$''');
    if (value == '') return 'Enter IP';
    if (!regex.hasMatch(value))
      return 'Invalid IP';
    else
      return null;
  }

  _pickKey() async {
    FilePickerResult result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pem']);

    if (result != null) {
      var pemFile = File(result.files.single.path);

      print("Value inside file");
      _pemKey = await pemFile.readAsString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  _startTerminal() async {
    var result = await _client.startShell(
      ptyType: "xterm",
      callback: (dynamic res) {
        print(res);
      },
    );
    _terminal.write("Session Conneted to IP : $_ip as Host : $username\n");
    // print(result.toString());
    // await _client.writeToShell("ls\n");
  }

  _onConnect() {
    if (_globalFormKey.currentState.validate()) {
      _globalFormKey.currentState.save();
      _doSSH();
    }
  }

  _doSSH() async {
    _client = new SSHClient(
      host: _ip.toString(),
      port: 22,
      username: username,
      passwordOrKey: {
        "privateKey": _pemKey,
        "passphrase": "passphrase-for-key",
      },
    );
    var res = await _client.connect();

    if (res == "session_connected") {
      setState(() {
        isConnected = true;
      });
      _startTerminal();
    }
  }

  _exitSSH() async {
    // var res = await _client.closeShell();
    // await _client.disconnect();
    // setState(() {
    //   _isConnected = false;
    // });
  }
}
