import 'package:socket_io_client/socket_io_client.dart' as io;

void main() {
  var socket = io.io('https://api-takumi.mihoyo.com', <String, dynamic>{
    // 'transports': ['websocket'],
    // 'path': '/chat/',
    'extraHeaders': {
      'cookie':
          'stuid=81092022;stoken=7U9qaN1hVajHM6g5sM9VwO5gQkwleWr16WTJ64pZ;',
      'Referer': 'https://app.mihoyo.com/',
      'Host': 'api-takumi.mihoyo.com',
      'Connection': 'Keep-Alive',
      'Accept-Encoding': 'gzip',
      'GlobalModel-Agent': 'okhttp/3.14.7'
    },
  });

  socket.on('error', (err) {
    print(err);
  });

  socket.on('connect', (_) {
    print('connect');
    socket.emit('my_event', 'init');
    // var count = 0;
    // Timer.periodic(const Duration(seconds: 1), (Timer countDownTimer) {
    //   socket.emit('my_event', count++);
    // });
  });
  socket.on('event', (data) => print(data));
  socket.on('disconnect', (_) => print('disconnect'));
  socket.on('fromServer', (_) => print(_));
}
