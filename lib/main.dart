import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'bike.dart';
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
      debugShowCheckedModeBanner: false,
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
                Tab(icon: Icon(Icons.search)),
              ],
            ),
            title: const Text('台北景點app'),
          ),
          body: const TabBarView(
            children: [
              Taipeiveiw(),
              Bike(),
              Search(),
            ],
          ),
        ),
      ),
    );
  }
}

List whenerror3 = List.empty();

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late Future<List> futuresearch;
  String searchTerm = 'Y';

  void initState() {
    super.initState();
    futuresearch = fetchnumber();
  }

  Future<List> fetchnumber() async {
    var response3 = await http.get(
      Uri.parse(
          "https://tdx.transportdata.tw/api/basic/v2/Bike/Station/City/Taipei?%24format=JSON&\$filter=contains(StationName/Zh_tw, '$searchTerm')"),
      headers: {
        'accept': ' application/json',
        'Authorization':
            ' Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJER2lKNFE5bFg4WldFajlNNEE2amFVNm9JOGJVQ3RYWGV6OFdZVzh3ZkhrIn0.eyJleHAiOjE3MTYwMDYwMTAsImlhdCI6MTcxNTkxOTYxMCwianRpIjoiYThhODRkZDEtNzdiMy00MGMyLTliMTUtZmI0MDdhM2EyNTJmIiwiaXNzIjoiaHR0cHM6Ly90ZHgudHJhbnNwb3J0ZGF0YS50dy9hdXRoL3JlYWxtcy9URFhDb25uZWN0Iiwic3ViIjoiZWIyYTU0YjAtYzIwNC00YTRjLThhOGItZDA2NGE2OTNjZjQ4IiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiaEVOUlk0MDIxMC04MTNiMTg0Yy02YTY2LTRlY2EiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbInN0YXRpc3RpYyIsInByZW1pdW0iLCJwYXJraW5nRmVlIiwibWFhcyIsImFkdmFuY2VkIiwiZ2VvaW5mbyIsInZhbGlkYXRvciIsInRvdXJpc20iLCJoaXN0b3JpY2FsIiwiYmFzaWMiXX0sInNjb3BlIjoicHJvZmlsZSBlbWFpbCIsInVzZXIiOiIwODM4NWQ4NSJ9.c0Gc6pd4zjTZ0_OmmRp7fUVRD1YwjmQ-QDiEOv9UiTp6fkdvsdK_YIbRIxLn7cRZOstDN4MPJYZxyv5puQSwwy3scYvq4scej4cKCECHHXGYMnjIXl1jh2g66dl7DELPgBd3oSNGuDZ2lO3gYwRa8MbWw90TXoHG6JQisEo-DUK7kFGJUzxuzeAX5aejJuMkRi4LRrXKEfc2s_9bNXvW4BkxdEb1S9LHJiDORjjb0ReN-WoNcdlMZSPxfunZVHLozWbOGAu_YmijigVc9IkSJtq6gRAX5POmg-5gYZBlKAN0hkPQSbvTYB5wYr1e4mS7E8IAn291qBOo8F3klYEA1Q'
      },
    );

    if (response3.statusCode == 200) {
      List bike = jsonDecode(response3.body);
      whenerror3 = bike;
      //print('success2');
      return bike;
    } else if (response3.statusCode == 429) {
      print('1:${response3.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('請求過快，請稍後再試'),
        ),
      );
      return whenerror3;
    } else {
      print('1:${response3.statusCode}');
      throw Exception(
        'API has error',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchAnchor(
                  builder: (context, controller) {
                    return SearchBar(
                      leading: const Icon(Icons.search),
                      controller: controller,
                      hintText: 'Search Station',
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        setState(() {
                          searchTerm = value;
                          futuresearch = fetchnumber();
                        });
                      },
                    );
                  },
                  suggestionsBuilder: (context, controller) {
                    return [];
                  },
                ),
              ),
              Expanded(
                  child: Center(
                child: FutureBuilder(
                  future: futuresearch,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var names = snapshot.data!;
                      if (names.isEmpty) {
                        return const Text('No Result');
                      }
                      return ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: names.length,
                          itemBuilder: ((context, index) {
                            Map nam = names[index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(nam['StationName']['Zh_tw']),
                                    Text(nam['StationID']),
                                  ],
                                ),
                              ),
                            );
                          }));
                    }else if(snapshot.hasError){
                      return Text('${snapshot.error}');
                    }
                    else{
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ))
            ],
          )),
    );
  }
}
