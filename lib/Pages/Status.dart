import 'package:docker/Pages/BarHandler.dart';
import 'package:flutter/material.dart';

class StatusPage extends StatefulWidget {
  @override
  _StatusPageState createState() => _StatusPageState();
}

_connected() {
  return Card(
    elevation: 20,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.circle,
          color: Colors.green,
        ),
        Text('Server is Connected'),
      ],
    ),
  );
}

_disconnect() {
  return Card(
    elevation: 20,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.circle,
          color: Colors.red,
        ),
        Text('Server is Disconnected'),
      ],
    ),
  );
}

class _StatusPageState extends State<StatusPage> {
  var getConnect = Connect();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getConnect.isConnected ? _connected() : _disconnect(),
          ],
        ),
      ),
    );
  }
}
