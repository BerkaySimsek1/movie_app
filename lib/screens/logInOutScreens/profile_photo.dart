import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/firebase_methods/firestore_methods.dart';
import 'package:movie_app/screens/bottom_nav_bar.dart';
import 'package:movie_app/screens/logInOutScreens/widgets/customPhoto.dart';
import 'package:path/path.dart';

class AddingProfilephoto extends StatefulWidget {
  const AddingProfilephoto({super.key});

  @override
  State<AddingProfilephoto> createState() => _AddingProfilephotoState();
}

class _AddingProfilephotoState extends State<AddingProfilephoto> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  late String photoPath = defaultPhoto;
  String defaultPhoto =
      'https://soccerpointeclaire.com/wp-content/uploads/2021/06/default-profile-pic-e1513291410505.jpg';
  int count = 0;
  Future uploadFile() async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('/file');
      await ref.putFile(_photo!);
      photoPath = await ref.getDownloadURL();
      FirestoreMethods().updateProfilePhoto(photoPath);

      setState(() {});
    } catch (e) {
      print('Error occured');
    }
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
      Future.delayed(Duration(microseconds: 1));

      setState(() {});
    } else {
      print('No image selected');
    }
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
      Future.delayed(Duration(microseconds: 1));
      setState(() {});
    } else {
      print('No image selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Center(
            child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext bc) {
                        return SafeArea(
                          child: Wrap(
                            children: <Widget>[
                              ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text('Gallery'),
                                  onTap: () {
                                    imgFromGallery();
                                    setState(() {});
                                    Navigator.of(context).pop();
                                  }),
                              ListTile(
                                leading: const Icon(Icons.photo_camera),
                                title: const Text('Camera'),
                                onTap: () {
                                  imgFromCamera();
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      });
                  setState(() {});
                },
                child: _photo != null
                    ? customPP(photoPath: photoPath)
                    : customPP(photoPath: defaultPhoto)),
          ),
          ElevatedButton(
              onPressed: () {
                uploadFile();
                setState(() {});
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavBar(),
                    ));
              },
              child: const Text('Select profile picture')),
          const Text('It may take a while. Please wait')
        ],
      ),
    );
  }
}
