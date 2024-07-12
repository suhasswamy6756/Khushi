library globals;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:kushi_3/model/SpendCoin.dart';

//dynamic userName = "Name";

import '../service/firestore_service.dart';
import 'SpendCoin.dart';

FirestoreService _firestoreService = FirestoreService();
dynamic userName = _firestoreService.getUserField(_firestoreService.getCurrentUserId()!, "full_name");

var stepsToday = 0;
bool dailyToken = false;
String date = "";
var countedSteps = 0;

bool initial5000StepsToken = false; // Add this variable to track the initial 5000 steps token
/*
redeemDiscount(int billValue) {
  if (billValue >= 1500) {
    spendToken(120);
  } else if (billValue >= 1001) {
    spendToken(120);
  } else if (billValue >= 800) {
    spendToken(100);
  } else if (billValue >= 600) {
    spendToken(80);
  } else if (billValue > 450) {
    spendToken(70);
  } else if (billValue > 400) {
    spendToken(60);
  } else if (billValue > 350) {
    spendToken(50);
  } else if (billValue > 300) {
    spendToken(40);
  } else if (billValue > 250) {
    spendToken(30);
  } else if (billValue > 200) {
    spendToken(20);
  }
}
*/



generate40RupeeToken(dynamic uid) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference coins = firestore.collection("40RupeeTokens");
  Random random = Random();
  int randNum = random.nextInt(999999);
  List<int> bytes = utf8.encode(randNum.toString());
  var hash = sha256.convert(bytes);
  coins.add({
    'Hash': hash.toString(),
    'UID': uid,
    'multiplier': 1.0,
    'redeemed':false,
    'source': 'Generated at $date',
  });
}

generate20RupeeToken(dynamic uid) {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference coins = firestore.collection("20RupeeTokens");
  DateTime date_2 = DateTime.now();
  Random random = Random();
  int randNum = random.nextInt(999999);
  List<int> bytes = utf8.encode(randNum.toString());
  var hash = sha256.convert(bytes);
  coins.add({
    'Hash': hash.toString(),
    'UID': uid,
    'multiplier': 1.0,
    'redeemed':false,
    'source': 'Generated at $date_2',
  });
}


generateHalfCoin(dynamic uid) {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference coins = firestore.collection("Half20");
  Random random = Random();
  int randNum = random.nextInt(999999);
  List<int> bytes = utf8.encode(randNum.toString());
  var hash = sha256.convert(bytes);
  coins.add({
    'Hash': hash.toString(),
    'UID': uid.toString(),
    'multiplier': 1.0,
    'redeemed':false,
    'source': 'Generated at $date',
  });
}



Future<int> get20CoinNumber(dynamic uid1) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference coins = firestore.collection("20RupeeTokens");
 QuerySnapshot querySnapshot = await coins.where('UID', isEqualTo: uid1).where('redeemed',isEqualTo: false).get();

  return querySnapshot.size;
}

Future<int> get40CoinNumber(dynamic uid1) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference coins = firestore.collection("40RupeeTokens");
  QuerySnapshot querySnapshot = await coins.where('UID', isEqualTo: uid1).where('redeemed',isEqualTo: false).get();
  return querySnapshot.size;
}

Future<int> get10CoinNumber(dynamic uid1) async{
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference coins = firestore.collection("Half20");
  QuerySnapshot querySnapshot = await coins.where('UID', isEqualTo: uid1).where('redeemed',isEqualTo: false).get();

  return querySnapshot.size;
}
