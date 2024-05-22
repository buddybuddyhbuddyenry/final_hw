// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:final_hw/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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
  bool restart = false;
  String searchTerm = 'Y';

  void initstate() {
    super.initState();
    //futurebike = fetchBikeState();
    futurestaion = fetchBikeStation();
  }

  Future<List> fetchBikeState() async {
    var response1 = await http.get(
      Uri.parse(
          "https://tdx.transportdata.tw/api/basic/v2/Bike/Availability/City/Taipei?%24format=JSON"),
      headers: {'accept': ' application/json', 'Authorization': token},
    );

    //await Future.delayed(Duration(seconds: 3));
    if (response1.statusCode == 200) {
      List bike = jsonDecode(response1.body);
      whenerror1 = bike;
      //print('success2');
      return bike;
    } else if (response1.statusCode == 429) {
      print('1:${response1.statusCode}');
      if (restart == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('請求過快，請稍後再試'),
          ),
        );
        restart = false;
      }
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
          "https://tdx.transportdata.tw/api/basic/v2/Bike/Station/City/Taipei?%24format=JSON&\$filter=contains(StationName/Zh_tw, '$searchTerm')"),
      headers: {'accept': ' application/json', 'Authorization': token},
    );

    //await Future.delayed(const Duration(seconds: 3));
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
    Future.delayed(const Duration(microseconds: 500000), () {
      setState(() {
        _showProgressIndicator = false;
      });
    });
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
        backgroundColor: const Color.fromARGB(31, 223, 213, 20),
        body: _showProgressIndicator
            ? const Center(child: CircularProgressIndicator())
            : FutureBuilder(
                future: Future.wait([fetchBikeState(), fetchBikeStation()]),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //var items = snapshot.data![0];
                    var items2 = snapshot.data![1];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SearchAnchor(
                            builder: (context, controller) {
                              return SearchBar(
                                leading: const Icon(Icons.search),
                                controller: controller,
                                hintText: 'Search Station ',
                                textInputAction: TextInputAction.search,
                                onSubmitted: (value) {
                                  setState(() {
                                    restart = true;
                                    searchTerm = value;
                                    //futurebike = fetchBikeState();
                                    futurestaion = fetchBikeStation();
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
                          child: ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: items2.length,
                            itemBuilder: ((context, index) {
                              //Map youbike = items[index];
                              Map youbikeStation = items2[index];
                              //Map youbikeStationName = youbikeStation['StationName'];
                              return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SecondRoute(
                                            //databike: youbike,
                                            dataStation: youbikeStation),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: const Color.fromARGB(
                                        255, 253, 208, 102),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(youbikeStation['StationName']
                                              ['Zh_tw']),
                                          //Row(
                                          //children: [
                                          //Text(
                                          //  '可借車數:${youbike['AvailableRentBikes']}'),
                                          //const SizedBox(
                                          //  width: 20,
                                          //),
                                          //Text(
                                          //  '可還車數:${youbike['AvailableReturnBikes']}')
                                          //],
                                          //),
                                          Text(
                                              'StationID:${youbikeStation['StationID']}'),
                                        ],
                                      ),
                                    ),
                                  ));
                            }),
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
        floatingActionButton: FloatingActionButton(
          //backgroundColor: const Color.fromARGB(31, 211, 182, 95),
          onPressed: () {
            setState(() {
              _showProgressIndicator = true;
              restart = true;
              _startTimer();
            });
          },
          child: const Icon(
            Icons.autorenew,
          ),
        ),
      ),
    );
  }
}

class SecondRoute extends StatefulWidget {
  final Map dataStation;

  const SecondRoute({super.key, required this.dataStation});

  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
  late Future<List> _futureBike;

  Future<List> fetchBikeState() async {
    var response5 = await http.get(
      Uri.parse(
          "https://tdx.transportdata.tw/api/basic/v2/Bike/Availability/City/Taipei?\$filter=contains(StationID, '${widget.dataStation['StationID']}')&%24format=JSON"),
      headers: {'accept': ' application/json', 'Authorization': token},
    );

    if (response5.statusCode == 200) {
      List bike = jsonDecode(response5.body);
      print('success287');
      return bike;
    } else if (response5.statusCode == 429) {
      print('5:${response5.statusCode}');
      //if (restart == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('請求過快，請稍後再試'),
        ),
      );
      //restart = false;
      //}
      return whenerror1;
    } else {
      print('5:${response5.statusCode}');
      throw Exception('API has error');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureBike = fetchBikeState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 249, 206),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 249, 249, 206),
        toolbarHeight: 50,
        title: Text(
          widget.dataStation['StationName']['Zh_tw'],
          style: const TextStyle(fontSize: 15),
        ),
      ),
      body: FutureBuilder<List>(
        future: _futureBike,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var bikenum = snapshot.data!;
            Map num = bikenum[0];
            var dateTime = DateTime.parse(num['SrcUpdateTime']);
            var localDateTime = dateTime.toLocal().add(const Duration(hours: 8)); // 将时间转换为本地时间
            var formattedDate =
                DateFormat('yyyy/MM/dd HH:mm:ss').format(localDateTime);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('可借車數:${num['AvailableRentBikes']}'),
                Text('可還車數:${num['AvailableReturnBikes']}'),
                Text('資料更新時間:$formattedDate')
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
