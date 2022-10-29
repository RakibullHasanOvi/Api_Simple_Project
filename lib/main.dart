import 'dart:convert';
import 'dart:core';
import 'package:api_learn/api_detailes.dart';
// import 'package:api_learn/models/api_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // const MyHomePage({super.key});
  // final _photos = Photos;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Calling Api.....
  //Using array list api that's reason we create one list..PhotoList[];
  List<Photos> photoList = [];

  Future<List<Photos>> _getPhotos() async {
//When you call api this methods then you should know only one return you used...

    final responce = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/photos'),
    );
    var data = jsonDecode(
      responce.body.toString(),
    );

    if (responce.statusCode == 200) {
      //Using for loops on Map...
      for (Map i in data) {
        Photos photos = Photos(
          title: i['title'],
          url: i['url'],
          id: i['id'],
        );
        photoList.add(photos);
      }
    }
//Here you used one return ....in the end of conditions
    return photoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Api Learn'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _getPhotos(),
              builder: (context, snapshot) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const ApiDetailes(),
                            transitionDuration: const Duration(seconds: 0),
                            transitionsBuilder: (_, a, __, c) =>
                                FadeTransition(opacity: a, child: c),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          image: DecorationImage(
                            image: NetworkImage(
                              snapshot.data![index].url.toString(),
                            ),
                          ),
                        ),
                        child: Text(
                          snapshot.data![index].title.toString(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            // flex: 2,
            child: FutureBuilder(
              future: _getPhotos(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: photoList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          snapshot.data![index].url.toString(),
                        ),
                      ),
                      title: Text(
                        snapshot.data![index].title.toString(),
                      ),
                      subtitle: Text(
                        snapshot.data![index].id.toString(),
                      ),

                      // title: Text('Rakibull Hasan Ovi'),
                      // subtitle: Text('Rakibul'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

//Model create....
class Photos {
  String title, url;
  int id;

  Photos({
    required this.title,
    required this.url,
    required this.id,
  });
}
