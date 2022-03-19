import 'package:flutter/material.dart';
import 'package:todoapp/layout/todo_app/todo.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(myApp());
}
class myApp extends StatelessWidget{
  myApp();
  @override
  Widget build(BuildContext context)
  {
    return  MaterialApp(
      home:HomeLayout(),
      debugShowCheckedModeBanner: false,
    );

  }
}


