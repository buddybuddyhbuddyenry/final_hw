import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'bike.dart';
import 'search.dart';
import 'taipeiveiw.dart';

void main() async {
  runApp(const LoginPage());
}

String token=' Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJER2lKNFE5bFg4WldFajlNNEE2amFVNm9JOGJVQ3RYWGV6OFdZVzh3ZkhrIn0.eyJleHAiOjE3MTYzNjI0MzksImlhdCI6MTcxNjI3NjAzOSwianRpIjoiZTUyNjQzNDYtOWI5ZC00YTM1LWJiNTMtYWExMTkzMjBkMGQzIiwiaXNzIjoiaHR0cHM6Ly90ZHgudHJhbnNwb3J0ZGF0YS50dy9hdXRoL3JlYWxtcy9URFhDb25uZWN0Iiwic3ViIjoiZWIyYTU0YjAtYzIwNC00YTRjLThhOGItZDA2NGE2OTNjZjQ4IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaEVOUlk0MDIxMC04MTNiMTg0Yy02YTY2LTRlY2EiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbInN0YXRpc3RpYyIsInByZW1pdW0iLCJwYXJraW5nRmVlIiwibWFhcyIsImFkdmFuY2VkIiwiZ2VvaW5mbyIsInZhbGlkYXRvciIsInRvdXJpc20iLCJoaXN0b3JpY2FsIiwiYmFzaWMiXX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInVzZXIiOiIwODM4NWQ4NSJ9.MIzBNBohjfikMAdg5QLti7rCwAZVAOTMkhnLX7OFR00iY1a5qNlw3jXLR1AaTTibCCA7uiRvQMXC5JgJu1fPuSqm8eZfhGtS4dr6o_povUY0lfO96SY4sLbBVSCE1XXuCTxA8771v-i9APDiyEDpLNGQsAy390kHNFtai75xvOLagJQBPGPZtAOYtq-kh-6bFXJToB8Q5pHwQ8WLo1waQg-KbN82gMuEZ3L3_4X9I-JTRi66H99kQee3lauwcoc70lwwQsuSVx6jcR9zmB_Wksb9fCtOFIy3TBckBRZZUn2GADaI1Wvm0gI6ekdi62T0mQeNR6jbP14NCizShtn9PQ';

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
    const Search(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('台北景點app'),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
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
        ),
      ),
    );
  }
}
