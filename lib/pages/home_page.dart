import 'package:flutter/material.dart';
import 'package:novo_teste_notification/api/notification.dart';
import 'package:novo_teste_notification/pages/page_teste.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationApi.init();
    listenNotifications();
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);
  void onClickedNotification(String? payLoad) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => PageTest()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Icon(
                Icons.flutter_dash,
                size: 160,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo.shade400),
                    ),
                    onPressed: () => NotificationApi.showNotification(
                          title: 'Titulo teste',
                          body: 'Body teste',
                          payLoad: 'teste.abs',
                        ),
                    icon: const Icon(Icons.notifications),
                    label: const Text('Notificação Simples'))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo.shade300),
                    ),
                    onPressed: () {
                      NotificationApi.showScheduledNotification(
                        title: 'Teste Schedule',
                        body: 'testando o body do schedule',
                        payLoad: 'teste neh',
                        scheduleDate: DateTime.now().add(Duration(seconds: 10)),
                      );
                      final snackBar =
                          SnackBar(content: Text('Schedule em 10 segundos'));
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    },
                    icon: const Icon(Icons.notifications_active),
                    label: const Text('Notificação schedule'))),
          ),
        ],
      ),
    );
  }
}
