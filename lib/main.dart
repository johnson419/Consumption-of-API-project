// ignore_for_file: avoid_print
// import 'Models/user.dart';
import 'dart:convert';
import 'package:consumption_of_api/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main(List<String> args) {
  runApp(const Api());
}

class Api extends StatefulWidget {
  const Api({Key? key}) : super(key: key);

  @override
  State<Api> createState() => _ApiState();
}

class _ApiState extends State<Api> {
  Future<List<Userinfo>> fetchUser() async {
    var url = Uri.https('reqres.in', '/api/users', {'page': '2'});

    var response = await get(url);
    if (response.statusCode == 200) {
      var data1 = jsonDecode(response.body);
      Iterable data = data1['data'];
      return List<Userinfo>.from(
        data.map(
          (user) {
            print(user);
            return Userinfo.fromJson(user);
          },
        ),
      );
    } else {
      throw Exception("NOT FOUND");
    }
  }

  late Future<List<Userinfo>> users;
  @override
  void initState() {
    users = fetchUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Instagram Clone'),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Userinfo>>(
            future: users,
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                List<Userinfo> data = snapshot.data!;
                return GridView.builder(
                  itemCount: snapshot.data?.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
                  itemBuilder: ((context, index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              data.elementAt(index).firstName,
                              style: const TextStyle(
                                fontFamily: 'cursive',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data.elementAt(index).lastName,
                              style: const TextStyle(
                                fontFamily: 'cursive',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 300,
                          height: 300,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image:
                                    NetworkImage(data.elementAt(index).avatar)),
                          ),
                        ),
                      ],
                    );
                  }),
                );
              } else {
                return Container(
                    // ignore: prefer_const_constructors
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      backgroundColor: Colors.white38,
                      color: Colors.redAccent,
                    ));
              }
            }),
      ),
    );
  }
}
