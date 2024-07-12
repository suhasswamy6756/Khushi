import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kushi_3/model/globals.dart' as globals;
// import 'package:kushi_3/model/enums/state.dart';
import 'package:kushi_3/pages/selectGender.dart';


class RefProvider extends ChangeNotifier {


  String message = "";

  CollectionReference profileRef =
  FirebaseFirestore.instance.collection("RefernEarn");

  FirebaseAuth auth = FirebaseAuth.instance;

  setReferral(String refCode) async {

    notifyListeners();

    try {
      final value = await profileRef.where("refCode", isEqualTo: refCode).get();

      if (value.docs.isEmpty) {
        ///ref code is not available
        message = 'Refcode is not available';

        notifyListeners();
      } else {
        /// It exists
        final data = value.docs[0];

        ///Get referrals
        List referrals = data.get("referrals");

        referrals.add(auth.currentUser!.phoneNumber);
        globals.generate40RupeeToken(auth.currentUser!.uid);
        ///Update the ref earning
        final body = {
          "referrals": referrals,
          "refEarnings": data.get("refEarnings") + 10
        };

        await profileRef.doc(data.id).update(body);

        message = "Ref success";

        notifyListeners();
      }
    } on FirebaseException catch (e) {
      message = e.message.toString();
      
      notifyListeners();
    }
  }
}