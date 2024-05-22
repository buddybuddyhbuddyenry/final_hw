import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'bike.dart';
import 'taipeiveiw.dart';

void main() async {
  runApp(const LoginPage());
}

String token =
    ' Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJER2lKNFE5bFg4WldFajlNNEE2amFVNm9JOGJVQ3RYWGV6OFdZVzh3ZkhrIn0.eyJleHAiOjE3MTY0NTc0ODEsImlhdCI6MTcxNjM3MTA4MSwianRpIjoiN2ZhZWY4MmItMDdlOC00NDgyLTg5ZTgtNjY2OWM0YjA0NWRhIiwiaXNzIjoiaHR0cHM6Ly90ZHgudHJhbnNwb3J0ZGF0YS50dy9hdXRoL3JlYWxtcy9URFhDb25uZWN0Iiwic3ViIjoiZWIyYTU0YjAtYzIwNC00YTRjLThhOGItZDA2NGE2OTNjZjQ4IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaEVOUlk0MDIxMC04MTNiMTg0Yy02YTY2LTRlY2EiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbInN0YXRpc3RpYyIsInByZW1pdW0iLCJwYXJraW5nRmVlIiwibWFhcyIsImFkdmFuY2VkIiwiZ2VvaW5mbyIsInZhbGlkYXRvciIsInRvdXJpc20iLCJoaXN0b3JpY2FsIiwiYmFzaWMiXX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInVzZXIiOiIwODM4NWQ4NSJ9.Wk7dB8dMLP4yoZ-Zo3AAsumTW5WVOIAieEOz3jnY2pebNxJ5i3wb437U025LMlDq4vXZYHiXGUlKr4fcpM84_Tb_UtCqnTRIkvHjRORqNJdTMFVBmApPqww-gSg4J6CVehmoNxmQkKGVRFR8wCDLcre8IkBAz1AIo07oFpmHp9Pf5FyeOKVPqC87pzWO45h-wGO7IdE2062kaMi0ZCic1_u0-4FoUluLVsqi-7WWvjiIukl1BghhIvC9MqDJHYTOK1Gf6aDPX-iGELm90u6AERxXry2kxYiY0XQ939qhZS2Q60JLS_0rkZrnfXGHgTbgVYQzUnM-OHLte8MDC3mKrQ';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  late Future<Map> futureToken;
  String? userName, password;
  late int isright;
  late int passworderrortime;
  late String passworderror;

  @override
  void initState() {
    super.initState();
    futureToken = loginFunction();
    isright = 0;
    passworderrortime = 0;
    passworderror = '';
  }

  Future<Map> loginFunction() async {
    var response1 = await http.post(
      Uri.parse('https://favqs.com/api/session'),
      headers: {
        'Authorization': 'Token token="02967adfbb3937b60abef1feb6ba64d8"',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "user": {"login": userName, "password": password}
      }),
    );

    if (response1.statusCode == 200) {
      var responseData = jsonDecode(response1.body);
      Map<String, dynamic> userToken = responseData;
      return userToken;
    } else {
      throw Exception('Failed to load item');
    }
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(168, 214, 199, 101)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('User Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<Map>(
            future: futureToken,
            builder: (context, snapshot) {
              if (passworderrortime > 0) {
                passworderror = '帳號或密碼錯誤';
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text(
                  'loading...',
                  style: TextStyle(
                      fontSize: 35, color: Color.fromARGB(255, 86, 46, 93)),
                );
              }
              Map item = snapshot.data!;
              if (item['User-Token'] != null && item['User-Token'] != '') {
                isright = 1;
                Future.delayed(const Duration(milliseconds: 1), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp0()),
                  );
                });
              }
              if (isright == 1) {
                return const Text(
                  'loading...',
                  style: TextStyle(
                      fontSize: 35, color: Color.fromARGB(255, 86, 46, 93)),
                );
              } else {
                return Column(
                  children: [
                    TextField(
                      controller: myController,
                      decoration: const InputDecoration(
                        hintText: 'UserName or Email',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: myController2,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            userName = myController.text;
                            password = myController2.text;
                            passworderrortime++;
                            //isright++;
                            // 更新 futureToken
                            setState(() {
                              futureToken = loginFunction();
                            });

                            if (item['User-Token'] != null &&
                                item['User-Token'] != '') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp0()),
                              );
                            }
                            myController.clear();
                            myController2.clear();
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Text(passworderror)
                      ],
                    ),
                    if (item['User-Token'] != null && item['User-Token'] != '')
                      Text(item['User-Token']),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class MyApp0 extends StatefulWidget {
  const MyApp0({super.key});

  @override
  _MyApp0State createState() => _MyApp0State();
}

class _MyApp0State extends State<MyApp0> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const Taipeiveiw(),
    const Bike(),
    const Center(child:  Icon(Icons.search)),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(197, 196, 151, 46)),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor:Color.fromARGB(31, 223, 213, 20),
          title: const Text('台北景點app'),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 255, 239, 134),
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.place),
              label: 'Taipei View',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.directions_bike),
              label: 'Bike',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
          ],
          selectedItemColor: Colors.pink, // 设置选中项目的颜色
          unselectedItemColor: Colors.grey, // 设置未选中项目的颜色
        ),
      ),
    );
  }
}
