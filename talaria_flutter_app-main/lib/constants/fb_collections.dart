import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:talaria/provider/auth_provider.dart';

class FBCollections {
  static FirebaseFirestore fb = FirebaseFirestore.instance;
  static CollectionReference users = fb.collection('Users');
  static CollectionReference brands = fb.collection('Brands');
  static CollectionReference genderType = fb.collection('GenderType');
  static CollectionReference shoes = fb.collection('shoes');
  // static CollectionReference myFavourite = users
  //     .doc(
  //         Provider.of<AuthProvider>(Get.context!, listen: false).userData.email)
  //     .collection("MyFavourites");
  // static CollectionReference myCloset = users
  //     .doc(
  //         Provider.of<AuthProvider>(Get.context!, listen: false).userData.email)
  //     .collection("MyCloset");
}
