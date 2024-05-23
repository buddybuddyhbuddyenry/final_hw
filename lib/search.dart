// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
import 'package:final_hw/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

List whenerror4 = List.empty();

class Search0 extends StatefulWidget {
  const Search0({super.key});

  @override
  State<Search0> createState() => _SearchState0();
}

class _SearchState0 extends State<Search0> {
  late Future<List> futuresearch;
  String searchTerm = '1579';

  void initState() {
    super.initState();
    futuresearch = fetchnumber();
  }

  Future<List> fetchnumber() async {
    var response3 = await http.get(
      Uri.parse(
          "https://tdx.transportdata.tw/api/basic/v2/Bus/StopOfRoute/InterCity?%24format=JSON&\$filter=contains(RouteID, '$searchTerm')"),
      headers: {'accept': ' application/json', 'Authorization': token},
    );

    if (response3.statusCode == 200) {
      List bike = jsonDecode(response3.body);
      whenerror4 = bike;
      //print('success2');
      return bike;
    } else if (response3.statusCode == 429) {
      //print('1:${response3.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('請求過快，請稍後再試'),
        ),
      );
      return whenerror4;
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(198, 195, 173, 10)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: const Color.fromARGB(255, 249, 249, 206),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchAnchor(
                  builder: (context, controller) {
                    return SearchBar(
                      leading: const Icon(Icons.search),
                      controller: controller,
                      hintText: 'Search Bus Number',
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
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Search(data: nam)));
                                },
                                child: Card(
                                  color: Color.fromARGB(255, 226, 226, 188),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          nam['SubRouteName']['Zh_tw'],
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          '從 ${nam['Stops'][0]['StopName']['Zh_tw']} 出發',
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          }));
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else {
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

List whenerror3 = List.empty();

class Search extends StatefulWidget {
  final Map data;
  const Search({super.key, required this.data});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late Future<List> futuresearch;
  String searchTerm = '1';
  int _secondsSinceUpdate = 0;
  Timer? _timer;

  void initState() {
    super.initState();
    futuresearch = fetchnumber();
    _startTimer();
  }

  Future<List> fetchnumber() async {
    var response3 = await http.get(
      Uri.parse(
          "https://tdx.transportdata.tw/api/basic/v2/Bus/EstimatedTimeOfArrival/InterCity?%24format=JSON&\$filter=SubRouteName/Zh_tw eq '${widget.data['SubRouteName']['Zh_tw']}' and Direction eq ${widget.data['Direction']}"),
      headers: {'accept': ' application/json', 'Authorization': token},
    );

    if (response3.statusCode == 200) {
      List bike = jsonDecode(response3.body);
      whenerror3 = bike;
      //print('success2');
      return bike;
    } else if (response3.statusCode == 429) {
      //print('1:${response3.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('請求過快，請稍後再試'),
        ),
      );
      return whenerror3;
    } else {
      //print('1:${response3.statusCode}');
      throw Exception(
        'API has error',
      );
    }
  }

   Future<void> _refreshData() async {
    // 執行刷新數據的操作
    setState(() {
      futuresearch = fetchnumber();
      _secondsSinceUpdate=0;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsSinceUpdate++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(198, 195, 173, 10)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: const Color.fromARGB(255, 249, 249, 206),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 249, 249, 206),
            title: Text(widget.data['SubRouteName']['Zh_tw']),
            leading: BackButton(onPressed: () {
              // 返回上一個頁面
              Navigator.pop(context);
            }),
          ),
          body: RefreshIndicator(
            onRefresh: _refreshData,
            child: Column(
              children: [
                Expanded(
                    child: Center(
                  child: FutureBuilder(
                    future: futuresearch,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var names = snapshot.data!;
                        String lastnumber = '';
                        bool isshow = false;
                        List stops = widget.data['Stops'];
                        if (names.isEmpty) {
                          return const Text('No Result');
                        }
                        return ListView.separated(
                            separatorBuilder: (context, index) {
                              return const Divider(
                                // 创建一条分隔线
                                color: Colors.grey, // 设置分隔线颜色
                                height: 1, // 设置分隔线高度
                              ); // 设置间隔高度为 10 像素
                            },
                            padding: const EdgeInsets.all(10),
                            itemCount: stops.length,
                            itemBuilder: ((context, index) {
                              //Map nam = names[index];
                              Map stop = stops[index];
                              //var estmateTime = nam['EstimateTime'];
                              //int time;
                              String newtime = '未發車';
                              String carnumber = '';
                              int tt = 99;
                              for (int i = 0; i < names.length; i++) {
                                Map nama = names[i];
                                if (nama['StopID'] == stop['StopID']) {
                                  if (nama['EstimateTime'] != null) {
                                    tt = nama['EstimateTime'] ~/ 60;
                                    String newtim = tt.toString();
                                    newtime = newtim + '分';
                                    if (tt == 0) {
                                      newtime = '進站中';
                                    }
                                    carnumber = nama['PlateNumb'].length == 2
                                        ? ''
                                        : nama['PlateNumb'];
                                    isshow = false;
                                    if (lastnumber != carnumber) {
                                      isshow = true;
                                    }
                                    lastnumber = carnumber;
                                  } else {
                                    newtime = '未發車';
                                    carnumber = nama['PlateNumb'].length == 2
                                        ? ''
                                        : nama['PlateNumb'];
                                    isshow = false;
                                    if (lastnumber != carnumber) {
                                      isshow = true;
                                    }
                                    lastnumber = carnumber;
                                  }
            
                                  break;
                                }
                              }
                              //if (estmateTime != null) {
                              // time = estmateTime ~/ 60;
                              //} else {
                              // time = 0;
                              //}
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: Card(
                                        color: tt < 4
                                            ? Colors.red
                                            : Colors.blueGrey, // 设置 Card 的背景颜色
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(newtime,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        width: 150,
                                        child: Text(stop['StopName']['Zh_tw'])),
                                    if (carnumber.isNotEmpty)
                                      if (isshow)
                                        Card(
                                          color: Colors
                                              .pink[100], // 设置 Card 的背景颜色为粉红色
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10), // 设置圆角
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                              carnumber,
                                              style: const TextStyle(
                                                  fontSize: 20), // 设置字体大小
                                            ),
                                          ),
                                        ),
                                  ],
                                ),
                              );
            
                              /* return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(nam['StopName']['Zh_tw']),
                                      Text(nam['SubRouteName']['Zh_tw']),
                                      Text('車牌號碼:${nam['PlateNumb']}'),
                                      Text('還剩$time分鐘'),
                                    ],
                                  ),
                                ),
                              ); */
                            }));
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                )), Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text('距離更新已經$_secondsSinceUpdate秒'),
            ),
              ],
            ),
          )),
    );
  }
}
