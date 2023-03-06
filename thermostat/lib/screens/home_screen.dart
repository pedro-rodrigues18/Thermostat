import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:web_socket_channel/io.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final DatabaseReference _tempReference;
  late final DatabaseReference _currentReference;
  late StreamSubscription<DatabaseEvent> _tempSubscription;
  late StreamSubscription<DatabaseEvent> _currentSubscription;

  late bool connected;
  late String temperatureC;
  late double corrente;
  late IOWebSocketChannel channel;
  final FlutterTts flutterTts = FlutterTts();
  double temperature = 30;

  speak(String text) async {
    await flutterTts.setLanguage("pt-BR");
    await flutterTts.setPitch(1.5);
    await flutterTts.speak(text);
  }

  @override
  void initState() {
    connected = false;
    temperatureC = '0';
    corrente = 0;

    Future.delayed(Duration.zero, () async {
      channelConnect();
    });

    init();

    super.initState();
  }

  Future<void> sendcmd(String cmd) async {
    if (connected == true) {
      channel.sink.add(cmd); //sending Command to NodeMCU
      //send command to NodeMCU
    } else {
      channelConnect();
      //print("Websocket is not connected.");
    }
  }

  void init() async {
    _tempReference = FirebaseDatabase.instance.ref().child("temperatura");
    _currentReference = FirebaseDatabase.instance.ref().child("corrente");
    try {
      final tempSnapshot = await _tempReference.get();
      final currentSnapshot = await _currentReference.get();
      temperatureC = tempSnapshot.value as String;
      corrente = currentSnapshot.value as double;
    } catch (err) {
      debugPrint(err.toString());
    }

    _tempSubscription = _tempReference.onValue.listen((DatabaseEvent event) {
      setState(() {
        temperatureC = (event.snapshot.value ?? '0') as String;
      });
    });

    _currentSubscription =
        _currentReference.onValue.listen((DatabaseEvent event) async {
      setState(() {
        corrente = (event.snapshot.value ?? '0') as double;
      });
      await sendcmd(corrente.toString());
    });
  }

  atualizarTemperatura(String temp) async {
    await _tempReference.set(temp);
  }

  void channelConnect() {
    try {
      channel = IOWebSocketChannel.connect(
          "ws://192.168.253.156:81"); //channel IP : Port
      //print(channel);
      channel.stream.listen(
        (message) {
          //print(message);
          setState(() {
            if (message == "connected") {
              connected = true; //message is "connected" from NodeMCU
            } else if (message.substring(0, 6) == "{'temp") {
              //check if the resonse has {'temp on it
              message = message.replaceAll(RegExp("'"), '"');
              Map<String, dynamic> jsondata =
                  json.decode(message); //decode json to array
              setState(() {
                temperatureC = jsondata["temp"]; //temperature value
                atualizarTemperatura(temperatureC);
              });
            }
            //you can apply "if elese - else if for more message type from NodeMCU"
          });
        },
        onDone: () {
          //if WebSocket is disconnected
          //print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          //print(error.toString());
        },
      );
    } catch (_) {
      //print("error on connecting to websocket.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text("Thermostat"),
      ),
      backgroundColor: Colors.blue[50],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 240,
            child: Center(
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 150,
                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0, endValue: 50, color: Colors.green),
                      GaugeRange(
                          startValue: 50, endValue: 100, color: Colors.orange),
                      GaugeRange(
                          startValue: 100, endValue: 150, color: Colors.red)
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: double.parse(
                            temperatureC), // Valor recebido do arduino
                      )
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Text(
                            '$temperatureCºC',
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          angle: 90,
                          positionFactor: 0.5),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
            width: 150,
            child: Text('$corrente'),
          ),
          SizedBox(
            height: 40,
            width: 150,
            child: ElevatedButton(
              onPressed: () => {
                speak("A temperatura atual é de: $temperatureC graus Celsius")
              },
              child: const Icon(
                Icons.volume_up,
                size: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}
