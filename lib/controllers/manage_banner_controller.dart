// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:cinepass_admin/models/movie_banner_model.dart';
import 'package:cinepass_admin/views/widgets/cine_pass_snack_bars.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ManageBannerController extends ChangeNotifier {
  List<MovieBannerModel> bannerList = [];
  String? bannerImage;
  Uint8List? imageToUpload;
  List<QueryDocumentSnapshot<Object?>>? snapShotList;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> uploadBannerImage(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) {
      errorSnackBar(context, 'Something went wrong!');
      return;
    }

    String imagePath = image.path;
    bannerImage = imagePath;
    imageToUpload = await image.readAsBytes();
    notifyListeners();
  }

  Future<bool> addBanner(
      BuildContext context, String movieName, String movieDescription) async {
    String resp = await saveData(
        movieName: movieName,
        movieDescription: movieDescription,
        bannerImage: imageToUpload!);
    if (resp == 'success') {
      return true;
    } else {
      return false;
    }
  }

  Future<String> uploadImageToStorage(
      String movieName, Uint8List fileName) async {
    movieName = movieName.replaceAll(' ', '_');
    Reference ref = _firebaseStorage.ref().child(movieName);
    UploadTask uploadTask = ref.putData(fileName);
    TaskSnapshot snapshot = await uploadTask;
    String dowloadUrl = await snapshot.ref.getDownloadURL();
    return dowloadUrl;
  }

  Future<String> saveData(
      {required String movieName,
      required movieDescription,
      required Uint8List bannerImage}) async {
    String resp = 'Something went wrong';
    try {
      String imageUrl = await uploadImageToStorage(movieName, bannerImage);
      await _firebaseFirestore.collection('movieBannerDetails').add({
        'movieName': movieName,
        'movieDescription': movieDescription,
        'bannerImageUrl': imageUrl
      });
      resp = 'success';
    } catch (e) {
      resp = e.toString();
    }
    return resp;
  }

  Future<void> deleteData(BuildContext context, int index) async {
    try {
      final id = snapShotList![index].id;

      await FirebaseFirestore.instance
          .collection('movieBannerDetails')
          .doc(id)
          .delete();
      Navigator.of(context).pop();
      successSnackBar(context, 'Successfully deleted Movie Banner');
    } catch (e) {
      errorSnackBar(context, e.toString());
    }
  }

  // Future<void> getAllBanners() async {
  //   final snapshot =
  //       await _firebaseFirestore.collection('movieBannerDetails').get();
  //   final allBanners =
  //       snapshot.docs.map((e) => MovieBannerModel.fromSnapshot(e)).toList();
  //   bannerList = allBanners;
  // }

  void addValueToList(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    List<QueryDocumentSnapshot<Object?>>? list = snapshot.data?.docs.toList();
    snapShotList = list;
    bannerList.clear();
    for (dynamic banner in list!) {
      final bannerE = MovieBannerModel(
          bannerImageUrl: banner['bannerImageUrl'],
          movieDescription: banner['movieDescription'],
          movieName: banner['movieName']);
      bannerList.add(bannerE);
    }
  }

  void makeNullandNotify() {
    bannerImage = null;
    notifyListeners();
  }
}
