import 'dart:convert';
import 'package:final_hw/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
            token
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
                      hintText: 'Search Station Number',
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
