import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:silicon_scraper/injectors/prediction_service_injector.dart';
import 'package:silicon_scraper/injectors/sentiment_service_injector.dart';
import 'package:silicon_scraper/injectors/recommendation_service_injector.dart';
import 'package:silicon_scraper/view_models/notification_view_model.dart';
import 'package:silicon_scraper/view_models/watch_list_view_model.dart';
import 'package:silicon_scraper/injectors/explore_service_injector.dart';
import 'package:silicon_scraper/injectors/search_sort_filter_service_injector.dart';
import 'package:silicon_scraper/theme/colors.dart';
import 'injectors/dependency_types.dart';
import 'injectors/line_chart_service_injector.dart';
import 'injectors/login_service_injector.dart';
import 'injectors/watch_list_service_injector.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:silicon_scraper/view_models/login_wrapper.dart';
import 'injectors/sign_up_service_injector.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  // 'This channel is used for important notifications.', // description
  importance: Importance.max,
);

void main() async{
  WatchListInjector.configure(DependencyType.MOCK);
  ExplorePageInjector.configure(DependencyType.MOCK);
  RecommendationPageInjector.configure(DependencyType.MOCK);
  SearchSortFilterInjector.configure(DependencyType.MOCK);
  PredictionInjector.configure(DependencyType.MOCK,fail: false);
  LoginInjector.configure(DependencyType.MOCK,success: true);
  SignUpInjector.configure(DependencyType.MOCK,success: true);
  NotificationViewModel notification=new NotificationViewModel();
  SentimentInjector.configure(DependencyType.MOCK);
  LineChartInjector.configure(DependencyType.MOCK);


  /// this sets the initial products for the watch list do not remove
  WidgetsFlutterBinding.ensureInitialized();
  WatchListViewModelSingleton.getState().setInitialProducts();


  /// below this line is firebase implementations
/*  await Firebase.initializeApp(); todo fix firebase
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//  String t=await FirebaseMessaging.instance.getToken();
//  print("your token is:"+t);
  notification.register();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

//  var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon.png');

  var initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');

  var initSetttings = InitializationSettings(android:initializationSettingsAndroid);
  flutterLocalNotificationsPlugin.initialize(initSetttings);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification notification = message.notification;
    AndroidNotification android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // channel.description,
              icon: android?.smallIcon,
              // other properties...
            ),
          ));
    }
  });*/

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      )
  );
  SystemChrome.setPreferredOrientations([

    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) {
  runApp(
      MultiProvider(
          providers: [
            // TODO: register other dependencies
            ChangeNotifierProvider<WatchListViewModel>(
              create: (_) => WatchListViewModelSingleton.getState(),
            ),
          ],
          child: MyApp()
      )
  );});
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // Future<void> setupInteractedMessage() async { todo fix
  //   // Get any messages which caused the application to open from
  //   // a terminated state.
  //   RemoteMessage initialMessage =
  //   await FirebaseMessaging.instance.getInitialMessage();
  //
  //   // If the message also contains a data property with a "type" of "chat",
  //   // navigate to a chat screen
  //   if (initialMessage != null) {
  //     _handleMessage(initialMessage);
  //   }
  //
  //   // Also handle any interaction when the app is in the background via a
  //   // Stream listener
  //   FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  // }
  //
  // void _handleMessage(RemoteMessage message) {
  //   if (message.data['type'] == 'chat') {
  //     Navigator.pushNamed(context, '/chat',
  //       arguments: message
  //     );
  //   }
  // }



  @override
  void initState() {
    super.initState();

    // Run code required to handle interacted messages in an async function
    // as initState() must not be async
    // setupInteractedMessage(); todo fix
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
//        primarySwatch: Colors.green,
        backgroundColor: Colors.grey[600],
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
              color: Color(0xffffb359),
        )
      ),
      home: /*MainNavigator()*/ LoginWrapper(),
    );
  }
}

