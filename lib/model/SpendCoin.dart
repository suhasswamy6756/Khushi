library SpendCoin;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kushi_3/service/firestore_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as dev;
import 'globals.dart' as globals;

class SpendCoin {
  spendToken(int Price) async {
    dynamic uid=FirebaseAuth.instance.currentUser!.uid.toString();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference coins = firestore.collection("40RupeeTokens");
    CollectionReference twentyCoins = firestore.collection("20RupeeTokens");
    CollectionReference halfCoins = firestore.collection("Half20");
    QuerySnapshot querySnapshot = await coins.where(
        'UID', isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString()).where('redeemed', isEqualTo: false)
        .get();
    QuerySnapshot twentyQuery = await twentyCoins.where(
        'UID', isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString()).where('redeemed', isEqualTo: false)
        .get();
    QuerySnapshot halfQuery = await halfCoins.where(
        'UID', isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString()).where('redeemed', isEqualTo: false)
        .get();
    if (Price >= 40) {
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot firstDocument = querySnapshot.docs.first;
        await coins.doc(firstDocument.id).update({'redeemed': true});
        dev.log("Updated 40 Rupee Token redeem value as true");
        Price -= 40;
        if (Price != 0) {
          spendToken(Price);
        }

      }
      else if (twentyQuery.size >= 2) {
        for (int i = 0; i < 2; i++) {
          await twentyCoins.doc(twentyQuery.docs[i].id).update({'redeemed': true});
          Price -= 20;
          dev.log("Updated 20 Rupee Token redeem value as true");
        }
        if (Price != 0) {
          spendToken(Price);
        }
      }
      else {
        dev.log("No coin found to delete");
      }
    }
    else if (Price >= 20) {
      if (twentyQuery.docs.isNotEmpty) {
        DocumentSnapshot firstDocument = twentyQuery.docs.first;
        await twentyCoins.doc(firstDocument.id).update({'redeemed': true});
        dev.log("Updated 20 Rupee Token redeem value as true");
        Price -= 20;
        if (Price != 0) {
          spendToken(Price);
        }
      }
      else if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot firstDocument = querySnapshot.docs.first;
        await coins.doc(firstDocument.id).update({'redeemed': true});
        dev.log("Updated 40 Rupee Token redeem value as true");
        globals.generate20RupeeToken(uid);
        dev.log("Generated 20 Rupee Token");
        Price -= 20;
        if (Price != 0) {
          spendToken(Price);
        }

      }
    }
    else if (Price >= 10) {
      if (halfQuery.docs.isNotEmpty) {
        DocumentSnapshot firstDocument = halfQuery.docs.first;
        await halfCoins.doc(firstDocument.id).update({'redeemed': true});
        dev.log("Updated Half coin Token redeem value as true");
        Price -= 10;
        if (Price != 0) {
          spendToken(Price);
        }
      }
      else if (twentyQuery.docs.isNotEmpty) {
        DocumentSnapshot firstDocument = twentyQuery.docs.first;
        await twentyCoins.doc(firstDocument.id).update({'redeemed': true});
        dev.log("Updated 20 Rupee Token redeem value as true");
        globals.generateHalfCoin(uid);
        dev.log("Generated Half of a 20 Rupee Token");
        Price -= 10;
        if (Price != 0) {
          spendToken(Price);
        }
      }
      else if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot firstDocument = querySnapshot.docs.first;
        await coins.doc(firstDocument.id).update({'redeemed': true});
        dev.log("Updated 40 Rupee Token redeem value as true");
        globals.generate20RupeeToken(uid);
        dev.log("Generated 20 Rupee Token");
        globals.generateHalfCoin(uid);
        dev.log("Generated Half of a 20 Rupee Token");
        Price -= 10;
        if (Price != 0) {
          spendToken(Price);
        }

      }
    }
  }
}