import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Taipeiveiw extends StatefulWidget {
const Taipeiveiw({super.key});

  @override
  State<Taipeiveiw> createState() => _MyAppState();
}

class _MyAppState extends State<Taipeiveiw> {
  late Future<List> futureName;

  void initstate() {
    super.initState();
    futureName = fetchRandName();
  }

  Future<List> fetchRandName() async {
    var response = await http.get(
      Uri.parse(
          'https://www.travel.taipei/open-api/zh-tw/Attractions/All?page=1'),
      headers: {
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map bashos = jsonDecode(response.body);
      List item = bashos['data'];
      return item;
    } else {
      throw Exception('Failed to load item');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //appBar: AppBar(
        //  title: const Text('台北旅遊景點'),
        //),
        body: Center(
          child: FutureBuilder(
            future: fetchRandName(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var items = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    Map ite = items[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SecondRoute(
                                      data: ite,
                                    )));
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Text(ite['name']), Text(ite['address'])],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  final Map data;

  const SecondRoute({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List image = data['images'];
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: Text(
          data['name'],
          style: const TextStyle(fontSize: 25),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(data['introduction']),
          ),
          SizedBox(
            height: 200, // 調整圖片列表的高度
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: image.length,
              itemBuilder: (context, index) {
                Map img = image[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    img['src'],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
