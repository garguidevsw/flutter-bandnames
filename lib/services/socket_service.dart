import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  SocketService() {
    initConfig();
  }

  ServerStatus get serverStatus => this._serverStatus;

  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  void initConfig() {
    // Dart client
    this._socket = IO.io('http://192.168.0.2:3000', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // this._socket.on('nuevo-mensaje', (payload) {
    //   print('nuevo mensaje: $payload');
    // });
  }
}
