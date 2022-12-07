import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/firebase_methods/auth_methods.dart';
import 'package:path/path.dart';

class StorageMethods {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final ImagePicker _picker = ImagePicker();
  File? _photo;
  Future<File?> imgFromGallery(String url) async {
    XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile(url);
      return _photo;
    } else {
      print("No image selected.");
    }
  }

  Future<File?> imgFromCamera(String url) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile(url);
      return _photo;
    } else {
      print("No image selected!");
    }
  }

  Future uploadFile(String url) async {
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref =
          firebase_storage.FirebaseStorage.instance.ref('hi').child('/files');
      await ref.putFile(_photo!);
      url = await ref.getDownloadURL();
    } catch (e) {
      print("Some error occured!");
    }
  }
}
