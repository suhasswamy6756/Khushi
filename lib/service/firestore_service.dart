import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/cupertino.dart';

import '../components/message.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kushi_3/chat_application/helper/show_alert_dialog.dart';

// import '../chat_application/repository/firabase_storage_repository.dart';

final class FirestoreService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  Map usernumber = {'phoneNumber': ''};

  Future<void> updateUserDocument(
      String uid, Map<String, dynamic> userData, BuildContext context) async {
    try {
      // Retrieve the document reference for the user
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Update or create the user document in Firestore
      await userRef.update(userData);
    } catch (e, stackTrace) {
      print('Error updating user document: $e');
      print(stackTrace); // Print stack trace for better error debugging
      // showAlertDialog(context: context, message: e.toString() );// Re-throw the error for handling at the calling site

      rethrow;
    }
  }

  Future<void> setUserDocument(
      String uid, Map<String, dynamic> userData, BuildContext context) async {
    try {
      // Retrieve the document reference for the user
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Update or create the user document in Firestore
      await userRef.set(userData);
    } catch (e, stackTrace) {
      showMessage(context,
          e.toString()); // Print stack trace for better error debugging
      // showAlertDialog(context: context, message: e.toString() );// Re-throw the error for handling at the calling site

      rethrow;
    }
  }

  Future<void> updateReferDocument(
      String uid, Map<String, dynamic> userData, BuildContext context) async {
    try {
      // Retrieve the document reference for the user
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('RefernEarn').doc(uid);

      // Update or create the user document in Firestore
      await userRef.set(userData);
    } catch (e, stackTrace) {
      print('Error updating user document: $e');
      print(stackTrace); // Print stack trace for better error debugging
      // showAlertDialog(context: context, message: e.toString() );// Re-throw the error for handling at the calling site

      throw e;
    }
  }

  Future<String?> fetchFieldValue(String uid, String field) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users') // Assuming 'users' is your collection name
          .doc(uid) // Document ID is the user's UID
          .get();

      // Check if the document exists and contains the field
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data =
            documentSnapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey(field)) {
          return data[field];
        }
      }

      // Document does not exist, field not found, or field value is null
      return null;
    } catch (e) {
      // Error occurred while fetching data
      print('Error fetching data: $e');
      return null;
    }
  }

  Future<void> updateUserField(String uid, String fieldName, dynamic fieldValue,
      BuildContext context) async {
    try {
      // Retrieve the document reference for the user
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Update the specific field of the user document in Firestore
      await userRef.set({fieldName: fieldValue});
    } catch (e, stackTrace) {
      print('Error updating user field: $e');
      print(stackTrace); // Print stack trace for better error debugging
      // showAlertDialog(context: context, message: e.toString() );// Re-throw the error for handling at the calling site

      rethrow;
    }
  }

  Future<String?> fetchPhoneNumber(String userId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _db.collection('users').doc(userId).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> userData =
            docSnapshot.data() as Map<String, dynamic>;

        return userData['phoneNumber'] as String?;
      } else {
        return null; // User document with the given userId does not exist
      }
    } catch (e) {
      print('Error fetching phone number: $e');
      return null; // Error occurred while fetching phone number
    }
  }

  Future<void> addContactNumberToUserDocument(
      String phoneNumber, String emialId) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      DocumentReference userDocument = _db.collection('contact').doc(user.uid);

      try {
        // Update the user's document with the contact number
        await userDocument.set({'phoneNumber': phoneNumber, 'emailId': emialId},
            SetOptions(merge: true));
      } catch (e) {
        print('Error adding contact number to user document: $e');
        // Handle error as needed
      }
    }
  }

  Future<List<String>> fetchDatabaseContacts() async {
    List<String> databaseContacts = [];
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('contacts').get();
      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        // Assume each document in the 'users' collection has a field named 'phoneNumber'
        String phoneNumber = docSnapshot.get('phoneNumber');
        databaseContacts.add(phoneNumber);
      }
    } catch (e) {
      print('Error fetching database contacts: $e');
    }
    return databaseContacts;
  }

  String? phoneNumberReturn() {
    return _auth.currentUser?.phoneNumber!;
  }

  // import 'package:firebase_auth/firebase_auth.dart';
  // import 'package:cloud_firestore/cloud_firestore.dart';

  Future<String?> getCurrentUserEmail() async {
    String? email;

    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Reference to the Firestore document for the current user
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('users')
            .doc(user.uid)
            .get();

        // Extract the email address from the document data
        email = userDoc.data()?['Email'];
      }
    } catch (e) {
      print('Error fetching current user email: $e');
    }

    return email;
  }

  uploadImagetoStorage(String childName, var file) async {
    UploadTask? uploadTask;
    if (file is File) {
      uploadTask = _storage.ref().child(childName).putFile(file);
    }
    if (file is Uint8List) {
      uploadTask = _storage.ref().child(childName).putData(file);
    }
    TaskSnapshot snapshot = await uploadTask!;
    String imageUrl = await snapshot.ref.getDownloadURL();
    return imageUrl;
  }

  String? getCurrentUserId() {
    return _auth.currentUser!.uid;
  }

  Future<String?> getUserField(String userId, String fieldName) async {
    try {
      // Reference to the Firestore document for the current user
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      // Check if the document exists
      if (userSnapshot.exists) {
        // Extract the specified field from the document data
        dynamic fieldValue = userSnapshot.data()?[fieldName];

        return fieldValue;
      } else {
        // Document does not exist
        print('Document does not exist for user with ID: $userId');
        return null;
      }
    } catch (e) {
      // Handle errors
      print('Error fetching user data: $e');
      return null;
    }
  }

  Future<void> registerUser(
      Map<String, dynamic> userData, UserCredential? userCredential) async {
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      User? user = userCredential?.user;

      if (user != null) {
        QuerySnapshot result = await _firestore
            .collection('users')
            .where('email', isEqualTo: userData['email_id'])
            .limit(1)
            .get();

        if (result.docs.isNotEmpty) {
          throw Exception('Email is already in use by another account.');
        }

        await user.updateEmail(userData['email_id']);
        await user.sendEmailVerification();

        await _firestore.collection('users').doc(user.uid).set(userData);

        print('User registered successfully');
      }
    } catch (e) {
      print('Failed to register user: $e');
    }
  }

  Future<String> calculateUsageDuration() async {
    try {
      // Fetch user document from Firestore
      DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _db
          .collection('RefernEarn')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Retrieve date_created field from the user document
      Timestamp dateCreatedTimestamp = userSnapshot.data()?['date_created'];
      DateTime dateCreated = dateCreatedTimestamp.toDate();

      // Calculate the difference
      DateTime currentDate = DateTime.now();
      Duration difference = currentDate.difference(dateCreated);

      // Convert difference to days and months
      int days = difference.inDays;
      int months = (days / 30).floor();

      // Return the duration as a string
      if (months > 0) {
        return "$months month${months > 1 ? 's' : ''}";
      } else {
        return "$days day${days > 1 ? 's' : ''}";
      }
    } catch (e) {
      print('Error calculating usage duration: $e');
      return "Error";
    }
  }

}
