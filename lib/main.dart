import 'package:flutter/material.dart';
import 'package:flutter_money_manager/my_app.dart';
import 'package:flutter_money_manager/widgets/navigation_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppBase());

class AppBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ThemeData.dark().primaryColor,
      ),
      home: ChangeNotifierProvider<NavigationProvider>(
        create: (_) => NavigationProvider(),
        child: MyApp(),
      ),
    );
  }
}
