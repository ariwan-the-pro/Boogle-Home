
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class SamsungRemote {
  static const String tvIp = '192.168.1.225';

  WebSocket? _socket;
  HttpClient? _httpClient;
  String? token;

  Function(String)? onStatus;

  Future<void> connect() async {
    onStatus?.call('Connecting to Samsung TV...');

    _httpClient = HttpClient()
      ..badCertificateCallback = (cert, host, port) {
        return host == tvIp && port == 8002;
      };

    final name = base64Encode(utf8.encode('Boogle Home'));

    final uri = Uri(
      scheme: 'wss',
      host: tvIp,
      port: 8002,
      path: '/api/v2/channels/samsung.remote.control',
      queryParameters: {'name': name},
    );

    try {
      _socket = await WebSocket.connect(
        uri.toString(),
        customClient: _httpClient,
      );

      onStatus?.call('Connected! Check your TV for permission.');

      _socket!.listen(
        (message) {
          try {
            final data = jsonDecode(message);

            if (data['event'] == 'ms.channel.connect') {
              token = data['data']?['token']?.toString();
              onStatus?.call('Samsung TV paired and connected!');
            }
          } catch (_) {}
        },
        onDone: () => onStatus?.call('Disconnected'),
        onError: (error) => onStatus?.call('Connection error: $error'),
      );
    } catch (e) {
      onStatus?.call('Could not connect: $e');
    }
  }

  void press(String key) {
    if (_socket == null ||
        _socket!.readyState != WebSocket.open) {
      onStatus?.call('Not connected to TV');
      return;
    }

    _socket!.add(jsonEncode({
      'method': 'ms.remote.control',
      'params': {
        'Cmd': 'Click',
        'DataOfCmd': key,
        'Option': 'false',
        'TypeOfRemote': 'SendRemoteKey',
      },
    }));
  }

  void disconnect() {
    _socket?.close();
    _httpClient?.close(force: true);
    _socket = null;
    onStatus?.call('Disconnected');
  }
}
