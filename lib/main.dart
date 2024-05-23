import 'dart:convert';

import 'package:final_hw/search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'bike.dart';
import 'taipeiveiw.dart';

void main() async {
  runApp(const LoginPage());
}

String token =
    ' Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJER2lKNFE5bFg4WldFajlNNEE2amFVNm9JOGJVQ3RYWGV6OFdZVzh3ZkhrIn0.eyJleHAiOjE3MTY1MjIzMDEsImlhdCI6MTcxNjQzNTkwMSwianRpIjoiYzY0OTA1YmUtYzZkMC00NGNlLWI4MjktM2M2ZmZhNjViZDA4IiwiaXNzIjoiaHR0cHM6Ly90ZHgudHJhbnNwb3J0ZGF0YS50dy9hdXRoL3JlYWxtcy9URFhDb25uZWN0Iiwic3ViIjoiZWIyYTU0YjAtYzIwNC00YTRjLThhOGItZDA2NGE2OTNjZjQ4IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaEVOUlk0MDIxMC04MTNiMTg0Yy02YTY2LTRlY2EiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbInN0YXRpc3RpYyIsInByZW1pdW0iLCJwYXJraW5nRmVlIiwibWFhcyIsImFkdmFuY2VkIiwiZ2VvaW5mbyIsInZhbGlkYXRvciIsInRvdXJpc20iLCJoaXN0b3JpY2FsIiwiYmFzaWMiXX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInVzZXIiOiIwODM4NWQ4NSJ9.QI_Nlm_ODBGjKzIgMevovXHCYRe_go0O8zKK-a_Vczu3gPiXLxpujn7mcufFa7TOfWTwWccFbXlGJxmW6kcpSRFf3-Qy878QgL7F0PrAI82EQVfoV7T2m1huwmG-LGCQMCpm5sJdKOMTSD8UUTZG6onSWZZ2BhQ6iNg17qWnWDm5Ag4wxMECFJx_JJQLXuGKxWiE-zlMYth9Zkb2Qe5U3sR3d-wr5YfCIPSRsUWiu4u8cRFdzeapkVOB4WEe91SyUHBmGBu_xv3E0rD0pkRrOFM3KkbjAi6ABgFNGWQoyiY9BFUBYjjHAruhstkAv7ht_ybsp5-JysiTy11tQUitww';

String token2 =
    ' Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJER2lKNFE5bFg4WldFajlNNEE2amFVNm9JOGJVQ3RYWGV6OFdZVzh3ZkhrIn0.eyJleHAiOjE3MTY1NDMzOTMsImlhdCI6MTcxNjQ1Njk5MywianRpIjoiZWVkNTkxZDYtOWRjYS00ZWZjLTkxYjUtZGMwZWU4ODZkMzI1IiwiaXNzIjoiaHR0cHM6Ly90ZHgudHJhbnNwb3J0ZGF0YS50dy9hdXRoL3JlYWxtcy9URFhDb25uZWN0Iiwic3ViIjoiMWQ3ZGFlYzYtZWRjNC00MzI1LTgyMTEtMjI1ZmRiMzM1MGZkIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaEVOUlk0MDIxMC1jZGMwZDc4NC1jZDA1LTRhNTMiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbInN0YXRpc3RpYyIsInByZW1pdW0iLCJwYXJraW5nRmVlIiwibWFhcyIsImFkdmFuY2VkIiwiZ2VvaW5mbyIsInZhbGlkYXRvciIsInRvdXJpc20iLCJoaXN0b3JpY2FsIiwiYmFzaWMiXX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInVzZXIiOiIwODM4NWQ4NSJ9.EEetMNswx7u_gNqlPZvIT0wX_qIbOkdYJ3lECAnzvYo-dDwMtKtuvgrScK8i_3bRF2CKnQfLeqgJAz3M1TcoYi4wQQFVMy9BIP6SJUeV6_BanEYE9ctlnVUMIEAyzG2UNJ1XosAS374QZ-_HD2z-h0RzPjv1ECy1C3015uuw_2zPNLJRjzHc0t-ELLa1tG7-iu73_HBIldBM0ZgBnoAab1bGnBXUvYTsvGzIFJ89ZC6srA9v3BtUg_EwXrGVr1PueEznqXtbZJ8JhkQTNMbqztT_Pby5MPicaV2ozvlR3dtmiqvFUFQX8xcmt7O3sRznCGqZ5yankAYke9NhnvhkGQ';

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
    const Search0(),
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
          backgroundColor: Color.fromARGB(31, 223, 213, 20),
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
              icon: Icon(Icons.directions_bus),
              label: 'Bus',
            ),
          ],
          selectedItemColor: Colors.pink, // 设置选中项目的颜色
          unselectedItemColor: Colors.grey, // 设置未选中项目的颜色
        ),
      ),
    );
  }
}
