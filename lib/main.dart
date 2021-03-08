import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/bottom_navigator_bar.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'landing_page.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>  FocusScope.of(context).requestFocus(new FocusNode()),
      child: Provider<AuthBase>(
        create: (context) => Auth(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: LandingPage(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
