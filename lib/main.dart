import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/LayOut/taps_layout.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Modules/Main Page/main_page.dart';
import 'Network/Local/Cache_Helper.dart';
import 'Shared/Styles/themes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://fezoxszyslcflfedguyz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZlem94c3p5c2xjZmxmZWRndXl6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgyMzAyMjEsImV4cCI6MjA1MzgwNjIyMX0.vUhS2lKrlJSkPSxaFMQsjE_dpcwHV72oQwQe6Rw9v7g',
  );
  await CachHelper.init();
  var uId = CachHelper.getData(key: 'uId');
  Widget widget ;
  if(uId != null){
    widget = const TabsLayout();
  }else{
    widget = const MainPage();
  }
  runApp(MyApp(startWidget: widget,));
}

class MyApp extends StatelessWidget {
  final Widget startWidget ;
  const MyApp({super.key, required this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: startWidget ,
    );
  }
}
