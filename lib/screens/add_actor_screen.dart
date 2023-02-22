import 'dart:io';

import 'package:actors/screens/actors_list.dart';
import 'package:actors/services/sqflite_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../models/actor_model.dart';
import '../shared/widgets/show_snackbar.dart';

class AddActorPage extends StatefulWidget {
  @override
  _AddActorPageState createState() => _AddActorPageState();
}

class _AddActorPageState extends State<AddActorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  File? _image;

  void _onImageSelected(File image) {
    setState(() {
      _image = image;
    });
  }

  void _saveActor(BuildContext context) async {
    if (_formKey.currentState!.validate() && _image != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = basename(_image!.path);
      final savedImage = await _image!.copy('${appDir.path}/$fileName');

      final actor = Actor(name: _nameController.text, image: savedImage.path);

      DatabaseHelper().createActors(actor);
      showSnackBar(context, "The Actor has been saved", 1);
      _nameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('My Favourite Actors'),
        )),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 22.0, right: 22.0, left: 22.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                    child: Text(
                  "Select your favourite actor's image",
                  style: TextStyle(fontSize: 18, color: Colors.black45),
                )),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    final image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      _onImageSelected(File(image.path));
                    }
                  },
                  child: Container(
                    height: 300.0,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: _image != null
                        ? Container(
                            height: 300,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: Image.file(_image!, fit: BoxFit.contain))
                        : const Center(
                            child: Icon(
                            Icons.image,
                            color: Colors.greenAccent,
                            size: 80,
                          )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: const TextStyle(),
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.greenAccent,
                      width: 3,
                    )),
                    // fillColor: GlobalVariables.backgroundColor,
                    // filled: true,
                    hintText: "Enter their name",
                    hintStyle: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    _saveActor(context);
                  },
                  child: const Text(
                    'Add to Favourites',
                    style: TextStyle(fontSize: 15, color: Colors.greenAccent),
                  ),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ActorListPage()),
                      );
                    },
                    child: const Text('View Favourites'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
