

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kushi_3/pages/selectGender.dart';

class AuthService extends ChangeNotifier{
  CollectionReference profileRef =
  FirebaseFirestore.instance.collection("ReferEarn");
  // instance for auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance for firebase_firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;




  void signOut() async {
    // await GoogleSignIn().signOut(); // Sign out from Google
    await FirebaseAuth.instance.signOut(); // Sign out from Firebase Authentication
  }



}