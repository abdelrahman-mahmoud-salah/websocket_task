import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('web socket demo'),
        ),
        body: WebSocketDemo(),
      ),
    );
  }
}

class WebSocketDemo extends StatefulWidget {
  WebSocketDemo({super.key});
  final WebSocketChannel channel =
      IOWebSocketChannel.connect('wss://echo.websocket.org/.ws');
  @override
  State<WebSocketDemo> createState() => _WebSocketDemoState(channel: channel);
}

class _WebSocketDemoState extends State<WebSocketDemo> {
  _WebSocketDemoState({required this.channel}) {
    channel.stream.listen(
      (event) {
        setState(() {
          list.add(event);
        });
      },
    );
  }
  final WebSocketChannel channel;
  final TextEditingController? controller = TextEditingController();
  List<String> list = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                controller: controller,
                decoration: InputDecoration(label: Text("send message")),
                style: TextStyle(fontSize: 22),
              )),
              Padding(
                padding: const EdgeInsets.all(5),
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.grey)),
                    onPressed: () {
                      if (controller!.text.isNotEmpty) {
                        print(controller!.text);
                        channel.sink.add(controller!.text);
                        controller!.text = '';
                      }
                    },
                    child: Text(
                      'send',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
        Expanded(child: Getlist()),
      ],
    );
  }

  ListView Getlist() {
    List<Widget> listWidget = [];
    for (String mesage in list) {
      listWidget.add(ListTile(
          title: Container(
        width: double.infinity,
        color: Colors.blue,
        child: Center(
          child: Text(mesage,
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 255, 255),
                fontSize: 30,
              )),
        ),
      )));
    }
    return ListView(
      children: listWidget,
    );
  }
}
