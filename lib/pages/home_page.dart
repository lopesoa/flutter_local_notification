import 'package:flutter/material.dart';
import 'package:flutter_local_notification/api/notification.dart';
import 'package:flutter_local_notification/pages/page_teste.dart';
import 'package:timezone/timezone.dart' as tz;

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
    NotificationApi.init(initScheduled: true);
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
                          MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () => NotificationApi.showNotification(
                          title: 'Notificação Teste',
                        body: 'Esta é uma notificação de teste',
                          payLoad: 'teste',
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
                          MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      NotificationApi.showScheduledNotification(
                       title: 'Notificação Teste',
                        body: 'Esta é uma notificação de teste',
                        payLoad: 'teste',
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
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () {
                      NotificationApi.showScheduledNotificationDay(
                        title: 'Notificação Teste',
                        body: 'Esta é uma notificação de teste',
                        payLoad: 'teste',
                      );
                      final snackBar =
                          SnackBar(content: Text('Está notificação será agendada'));
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    },
                    icon: const Icon(Icons.play_circle),
                    label: const Text('Notificação Programada'))),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.indigo),
                    ),
                    onPressed: () => NotificationApi.cancelAllnotifications(),
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Cancelar Notificações'))),
          ),
        ],
      ),
    );
  }
}
