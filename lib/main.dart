import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'taipeiveiw.dart';

void main() async {
  runApp(const LoginPage());
}

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

class MyApp0 extends StatelessWidget {
  const MyApp0({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.place)),
                Tab(icon: Icon(Icons.directions_bike)),
                Tab(icon: Icon(Icons.directions_transit)),
              ],
            ),
            title: const Text('台北景點app'),
          ),
          body: const TabBarView(
            children: [
              Taipeiveiw(),
              Bike(),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}

List whenerror1 = List.empty();
List whenerror2 = List.empty();

class Bike extends StatefulWidget {
  const Bike({super.key});

  @override
  State<Bike> createState() => _BikeState();
}

class _BikeState extends State<Bike> {
  late Future<List> futurebike;
  late Future<List> futurestaion;
  bool _showProgressIndicator = false;

  void initstate() {
    super.initState();
    futurebike = fetchBikeState();
    futurestaion = fetchBikeStation();
  }

  Future<List> fetchBikeState() async {
    var response1 = await http.get(
      Uri.parse(
          'https://tdx.transportdata.tw/api/advanced/v2/Bike/Availability/NearBy?%24top=30&%24spatialFilter=nearby%2825.063298%2C%20121.543164%2C%201000%29&%24format=JSON'),
      headers: {
        'accept': ' application/json',
        'Authorization':
            ' Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJER2lKNFE5bFg4WldFajlNNEE2amFVNm9JOGJVQ3RYWGV6OFdZVzh3ZkhrIn0.eyJleHAiOjE3MTU5MjI3NjAsImlhdCI6MTcxNTgzNjM2MCwianRpIjoiOGE1YWVmOWItMTc1Zi00ZmZmLWE2MzMtMDZkZTk2MGNhN2Q4IiwiaXNzIjoiaHR0cHM6Ly90ZHgudHJhbnNwb3J0ZGF0YS50dy9hdXRoL3JlYWxtcy9URFhDb25uZWN0Iiwic3ViIjoiYmZkOTVjZDMtMGU3Ni00MDNjLWJmNjAtMTc5YTA0Y2U3Yzk5IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaEVOUlk0MDIxMC04MTNiMTg0Yy02YTY2LTRlY2EiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbInN0YXRpc3RpYyIsInByZW1pdW0iLCJwYXJraW5nRmVlIiwibWFhcyIsImFkdmFuY2VkIiwiZ2VvaW5mbyIsInZhbGlkYXRvciIsInRvdXJpc20iLCJoaXN0b3JpY2FsIiwiYmFzaWMiXX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInVzZXIiOiIwODM4NWQ4NSJ9.EHhDsLdXj0YQtnL8kfl9UxSrdhfy_Am1UsVJibEjw_HzHATrYVqJD5MZIwz6910es4uIAArsgNP8RW0_ebpAoT7RLTJ_bIiRwzD9WO1bsJqRRaEYiKIkJUkxWVAboqSSTewBNpahE5N7qfYnjUt2BDOmKvUY1pNI3fNg6oBEQp3B2PTh7NP0ly3W0rBbVJvRxfLID4WN-42VvzfLCTRC9onKkFP-gxBz-_FtTfI1Xq28fyr7kp-6TG_dE-lwRkRl5F1lgq9iJ8_At9Ee_P20Tgkq_4JPgffCmy1apFcMlzabUI6AB7KwIz3mghyr1V7fIokJjh8597rX7Q3HYlVxPA'
      },
    );

    await Future.delayed(Duration(seconds: 3));
    if (response1.statusCode == 200) {
      List bike = jsonDecode(response1.body);
      whenerror1 = bike;
      //print('success2');
      return bike;
    } else if (response1.statusCode == 429) {
      print('1:${response1.statusCode}');
      return whenerror1;
    } else {
      print('1:${response1.statusCode}');
      throw Exception(
        'API has error',
      );
    }
  }

  Future<List> fetchBikeStation() async {
    var response2 = await http.get(
      Uri.parse(
          'https://tdx.transportdata.tw/api/advanced/v2/Bike/Station/NearBy?%24top=30&%24spatialFilter=nearby%2825.063298%2C%20121.543164%2C%201000%29&%24format=JSON'),
      headers: {
        'accept': ' application/json',
        'Authorization':
            ' Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJER2lKNFE5bFg4WldFajlNNEE2amFVNm9JOGJVQ3RYWGV6OFdZVzh3ZkhrIn0.eyJleHAiOjE3MTU5MjI3NjAsImlhdCI6MTcxNTgzNjM2MCwianRpIjoiOGE1YWVmOWItMTc1Zi00ZmZmLWE2MzMtMDZkZTk2MGNhN2Q4IiwiaXNzIjoiaHR0cHM6Ly90ZHgudHJhbnNwb3J0ZGF0YS50dy9hdXRoL3JlYWxtcy9URFhDb25uZWN0Iiwic3ViIjoiYmZkOTVjZDMtMGU3Ni00MDNjLWJmNjAtMTc5YTA0Y2U3Yzk5IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaEVOUlk0MDIxMC04MTNiMTg0Yy02YTY2LTRlY2EiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbInN0YXRpc3RpYyIsInByZW1pdW0iLCJwYXJraW5nRmVlIiwibWFhcyIsImFkdmFuY2VkIiwiZ2VvaW5mbyIsInZhbGlkYXRvciIsInRvdXJpc20iLCJoaXN0b3JpY2FsIiwiYmFzaWMiXX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInVzZXIiOiIwODM4NWQ4NSJ9.EHhDsLdXj0YQtnL8kfl9UxSrdhfy_Am1UsVJibEjw_HzHATrYVqJD5MZIwz6910es4uIAArsgNP8RW0_ebpAoT7RLTJ_bIiRwzD9WO1bsJqRRaEYiKIkJUkxWVAboqSSTewBNpahE5N7qfYnjUt2BDOmKvUY1pNI3fNg6oBEQp3B2PTh7NP0ly3W0rBbVJvRxfLID4WN-42VvzfLCTRC9onKkFP-gxBz-_FtTfI1Xq28fyr7kp-6TG_dE-lwRkRl5F1lgq9iJ8_At9Ee_P20Tgkq_4JPgffCmy1apFcMlzabUI6AB7KwIz3mghyr1V7fIokJjh8597rX7Q3HYlVxPA'
      },
    );

    await Future.delayed(const Duration(seconds: 3));
    if (response2.statusCode == 200) {
      List bikestation = jsonDecode(response2.body);
      whenerror2 = bikestation;
      //print('success');
      return bikestation;
    } else if (response2.statusCode == 429) {
      print('2:${response2.statusCode}');
      return whenerror2;
    } else {
      print('2:${response2.statusCode}');
      throw Exception('API has error');
    }
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showProgressIndicator = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _showProgressIndicator
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder(
                future: Future.wait([fetchBikeState(), fetchBikeStation()]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var items = snapshot.data![0];
                    var items2 = snapshot.data![1];
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: items.length,
                      itemBuilder: ((context, index) {
                        Map youbike = items[index];
                        Map youbikeStation = items2[index];
                        //Map youbikeStationName = youbikeStation['StationName'];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(youbikeStation['StationName']['Zh_tw']),
                                Row(
                                  children: [
                                    Text(
                                        '可借車數:${youbike['AvailableRentBikes']}'),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                        '可還車數:${youbike['AvailableReturnBikes']}')
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _showProgressIndicator = true;
              _startTimer();
            });
          },
          child: const Icon(
            Icons.autorenew,
          ), // 按钮图标
        ),
      ),
    );
  }
}
