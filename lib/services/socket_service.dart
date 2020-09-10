import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

// Estatus del Servidor
enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  // Propiedad para revisar si el servidor está conectado o desconectado
  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  // Opcional si quieres hacer algo mas corto para el "emit"
  Function get emit => this._socket.emit;

  SocketService() {
    this._initConfig();
  }

// Este metodo se llamara cuando se genere una instancia de la clase ServerStatus
  void _initConfig() {
    // Dart client
    // localhost se puede sustituir por la ip del equipo o servidor en caso de que no funcione
    this._socket = IO.io('https://bands-sucket-app.herokuapp.com/', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // Se aconseja siempre dejarlo como dynamic el payload
    // socket.on('nuevo-mensaje', (payload) {
    //   print('nuevo mensaje:');
    //   print('nombre:' + payload['nombre']);
    //   print('mensaje:' + payload['mensaje']);

    //   // Prueba cuando no sabemos si existe el campo mensaje2 en el payload y evita el crash
    //   print(payload.containsKey('mensaje2')
    //       ? payload['mensaje2']
    //       : 'no hay mensaje');
    // });
  }
}
