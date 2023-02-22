import 'dart:io';

import 'package:actors/screens/full_screen_image.dart';
import 'package:flutter/material.dart';
import '../models/actor_model.dart';
import '../services/sqflite_service.dart';
import '../shared/widgets/show_snackbar.dart';

class ActorListPage extends StatefulWidget {
  @override
  _ActorListPageState createState() => _ActorListPageState();
}

class _ActorListPageState extends State<ActorListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite Actors'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<List<Actor>>(
          future: DatabaseHelper().getActors(),
          builder: (BuildContext context, AsyncSnapshot<List<Actor>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.data!.isEmpty) {
                return noFavouritesYet();
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                    crossAxisCount: 2),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullScreenImage(
                                  name: snapshot.data![index].name,
                                  image_path: snapshot.data![index].image,
                                )),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.file(
                              File(snapshot.data![index].image),
                              width: 150,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(snapshot.data![index].name),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      DatabaseHelper().deleteActors(
                                          snapshot.data![index].name);
                                    });
                                    showSnackBar(context, "Actor Deleted", 0);
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  noFavouritesYet() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Opacity(
              child: Image.asset(
                "assets/images/so_empty.png",
              ),
              opacity: 0.5,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'So Empty',
              style: TextStyle(color: Colors.grey[300], fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
