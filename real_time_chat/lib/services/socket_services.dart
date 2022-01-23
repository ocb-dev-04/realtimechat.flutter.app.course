import 'package:flutter/material.dart';
import 'package:real_time_chat/global/enviroment.dart';
import 'package:real_time_chat/services/auth_services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketServices with ChangeNotifier {
  late IO.Socket _socket;
  ServerStatus _serverStatus = ServerStatus.connecting;

  // getters
  ServerStatus get serverStatus => _serverStatus;

  // socket actions
  IO.Socket get socket => _socket;

  Future<void> connect() async {
    final token = await AuthServices.getToken();

    _socket = IO.io(Enviroment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    // client actions
    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    _socket.on('nuevo-mensaje', (data) {
      print('nuevo mensage');
      print(data ?? {});
    });
  }

  void disconnect() => _socket.disconnect();
}
