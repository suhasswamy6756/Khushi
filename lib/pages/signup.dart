import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kushi_3/components/alert_dialog.dart';

import 'package:kushi_3/components/mybutton.dart';
import 'package:kushi_3/components/textfield.dart';
import 'package:kushi_3/model/user_data.dart';

import 'package:kushi_3/service/firestore_service.dart';

FirestoreService _firestoreService = FirestoreService();

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isChecked = false;
  File? imageCamera;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  String profileUrl = '';
  bool isLoading = false;

  Uint8List? imageGallery;
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phonenNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _phoneNumber;
  bool _emailIsValid = false;
  bool _nameIsValid = false;

  String? userEmail;
  File? _imageFile;

  bool isEmailValid(String email) {
    // Regular expression for email validation
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isNameValid(String name) {
    return name.length > 4;
  }

  final picker = ImagePicker();

  // Function to open gallery and set selected image
  Future<void> _openGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // Function to upload image to Firebase Storage
  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      print('No image selected.');
      return;
    }
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    // Uploading image to Firebase Storage
    final storageRef = FirebaseStorage.instance.ref().child('images/$userId');
    await storageRef.putFile(_imageFile!);
    final downloadUrl = await storageRef.getDownloadURL();
    setState(() {
      profileUrl = downloadUrl.toString();
    });

    print('Image uploaded successfully.');
  }

  void fetchUserPhone() async {
    String? phone = _firestoreService.phoneNumberReturn();
    setState(() {
      _phoneNumber = phone;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUserEmail();
  }

  Future<void> fetchUserEmail() async {
    String? email = await _firestoreService.getCurrentUserEmail();
    setState(() {
      userEmail = email;
    });
  }

  void _openImagePickerModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => _getImage(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => _getImage(ImageSource.camera),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });

    Navigator.of(context).pop(); // Close modal sheet after image selection
  }

  @override
  Scaffold build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 25,
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Circular icon button to open gallery
                IconButton(
                  icon: _imageFile != null
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(_imageFile!),
                        )
                      : const Icon(Icons.add_photo_alternate),
                  iconSize: 100,
                  onPressed: _openGallery,
                ),
                const SizedBox(height: 20),
                // Button to upload image to Firebase Storage
              ],
            ),

            const SizedBox(height: 20),

            MyTextField(
              hintText: "Full Name",
              obscureText: false,
              controller: _fullnameController,
              readOnly: false,
              hintColor: Colors.grey,
              onChanged: (value) {
                setState(() {
                  _nameIsValid = isNameValid(_fullnameController.text);
                });
              },
              validator: (value) {
                if (!_nameIsValid) {
                  return "Name length should be greater than 4";
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _nameIsValid ? Colors.black : Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _nameIsValid ? Colors.black : Colors.red),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _nameIsValid ? Colors.black : Colors.red),
                ),
                fillColor: Theme.of(context).colorScheme.primary,
                filled: true,
                hintStyle: TextStyle(color: Colors.grey),
                errorText: _nameIsValid ? null : 'Enter a valid name',
                errorStyle: TextStyle(color: Colors.red),
              ),
            ),

            const SizedBox(
              height: 25,
            ),
            MyTextField(
              hintText: userEmail != null ? "$userEmail" : " Email",
              obscureText: false,
              controller: _emailController,
              readOnly: userEmail == null ? false : true,
              hintColor: userEmail == null ? Colors.grey : Colors.black,
              onChanged: (value) {
                setState(() {
                  _emailIsValid = isEmailValid(value);
                });
              },
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (!_emailIsValid) {
                  return 'Enter a valid email';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _emailIsValid ? Colors.black : Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _emailIsValid ? Colors.black : Colors.red),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: _emailIsValid ? Colors.black : Colors.red),
                ),
                fillColor: Theme.of(context).colorScheme.primary,
                filled: true,
                hintStyle: TextStyle(color: Colors.grey),
                errorText: _emailIsValid ? null : 'Enter a valid email',
                errorStyle: TextStyle(color: Colors.red),
              ),
            ),
            const SizedBox(
              height: 25,
            ),

            MyTextField(
              hintText: _firestoreService.phoneNumberReturn() ?? "Phone number",
              obscureText: false,
              controller: _phonenNumberController,
              readOnly:
                  _firestoreService.phoneNumberReturn() == null ? false : true,
              hintColor: _firestoreService.phoneNumberReturn() == null
                  ? Colors.grey
                  : Colors.black,
            ),

            // Text(_firestoreService.fetchFieldValue(_firestoreService.getUserId().toString(), "phoneNumber").toString()),
            const SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  activeColor: Colors.black,
                    checkColor: Colors.white,
                    value: _isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    }),
                Text(
                  "By continuing you accept our",
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/privacypolicy");
                    },
                    child: Text(
                      "Privacy policy",
                      style: GoogleFonts.openSans(
                        color: Colors.blue,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ))
              ],
            ),

            const SizedBox(
              height: 10,
            ),
            MyButton(
              text: "Sign Up",
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                await _uploadImage();
                // userDataMap['fcmToken'] = _api.getFcmToken();
                userDataMap['email_id'] = _emailController.text;

                userDataMap['profileUrl'] = profileUrl;
                userDataMap['full_name'] = _fullnameController.text;
                if (_nameIsValid && _emailIsValid) {
                  await _firestoreService.addContactNumberToUserDocument(
                      userDataMap['phoneNumber'], userDataMap['email_id']);

                  await _firestoreService
                      .setUserDocument(_firestoreService.getCurrentUserId()!,
                          userDataMap, context)
                      .then(
                          (value) => Navigator.pushNamed(context, '/stepper'));
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  setState(() {
                    isLoading = false;
                  });
                  showCustomDialog(context, "Error", "Enter required fields");
                }
              },
            ),
            const SizedBox(
              height: 15,
            ),

            const SizedBox(
              height: 50,
            ),
            // Text(_phoneNumber)
          ],
        ),
      ),
      floatingActionButton: isLoading ? const LoadingWidget() : null,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userDataMap.clear();
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background: Transparent container to capture touch events
        Container(
          color: Colors.black.withOpacity(0.3),
          constraints: const BoxConstraints.expand(),
        ),
        // Loading indicator
        const Center(
          child: CircularProgressIndicator(),
        ),
      ],
    );
  }
}
