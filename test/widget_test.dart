import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() async {
  var response = await http.get(Uri.parse('https://cold-brook-9024.fly.dev/randname'));
  print(response.body);
  //runApp(MyApp()); // 这里加上分号
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('HTTP 请求示例'),
        ),
        body: Center(
          child: Text('随机名字: 在这里显示随机名字'),
        ),
      ),
    );
  }
}
