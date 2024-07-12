import 'dart:typed_data';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../service/firestore_service.dart';

FirestoreService _firestoreService = FirestoreService();

class YourAccount extends StatefulWidget {
  const YourAccount({super.key});

  @override
  _YourAccountState createState() => _YourAccountState();
}

class _YourAccountState extends State<YourAccount> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _profileImage;
  String? _profileImageUrl;
  Uint8List? imageGallery;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    setState(() {
      _nameController.text = userDoc['full_name'];
      _emailController.text = userDoc['email_id'];
      _profileImageUrl = userDoc.data()?['profileUrl'];
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String? imageUrl;

      if (_profileImage != null) {
        try {
          TaskSnapshot uploadTask = await firebaseStorage
              .ref('images/$userId')
              .putFile(_profileImage!);
          imageUrl = await uploadTask.ref.getDownloadURL();
        } catch (e) {
          print('Failed to upload image: $e');
        }
      }

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'full_name': _nameController.text,
        'email_id': _emailController.text,
        'profileUrl': imageUrl ?? _profileImageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Account', style: GoogleFonts.roboto()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    ClipOval(
                      child: _profileImage != null
                          ? Image.file(
                        _profileImage!,
                        width: screenWidth * 0.25,
                        height: screenWidth * 0.25,
                        fit: BoxFit.cover,
                      )
                          : CachedNetworkImage(
                        imageUrl: _profileImageUrl ?? 'https://example.com/placeholder.jpg',
                        width: screenWidth * 0.25,
                        height: screenWidth * 0.25,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _pickImage,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: InputBorder.none,
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: InputBorder.none,
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.1,
                    vertical: screenHeight * 0.015,
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(fontSize: screenWidth * 0.05, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
