import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kushi_3/pages/Fragments/mainFragments/redeemScreen.dart';
import 'package:kushi_3/pages/yourAccount.dart';
import 'package:kushi_3/pages/introslider.dart';
import 'package:kushi_3/model/globals.dart' as globals;
import 'package:kushi_3/components/settingButtons.dart';
import 'package:kushi_3/service/auth/auth_service.dart';
import 'package:kushi_3/service/firestore_service.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';

class ProfileFragment extends StatefulWidget {
  ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _profilePageState();
}

class _profilePageState extends State<ProfileFragment> {
  String username = "";
  String usageDuration = "";
  String? profileImageUrl;
  FirestoreService _firestoreService = FirestoreService();

  TextStyle buttonText = GoogleFonts.outfit(
      fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black);
  TextStyle headText = GoogleFonts.outfit(
      fontWeight: FontWeight.w500, fontSize: 19, color: Colors.black);

  @override
  void initState() {
    super.initState();
    setUserName();
    fetchUsageDuration();
    getProfileImageUrl();
  }

  void _showSignOutDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Sign Out',
      desc: 'Are you sure you want to sign out?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        final authService = AuthService();
        authService.signOut();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const IntroSlider(),
          ),
        );
        print('User signed out');
      },
      btnCancelText: 'Cancel',
      btnOkText: 'OK',
    ).show();
  }

  Future<void> fetchUsageDuration() async {
    String duration = await _firestoreService.calculateUsageDuration();
    setState(() {
      usageDuration = duration;
    });
    print(usageDuration);
  }

  Future<void> setUserName() async {
    String? fullName = await _firestoreService.getUserField(
        _firestoreService.getCurrentUserId()!, "full_name");
    if (fullName != null) {
      setState(() {
        username = fullName;
      });
    } else {
      // Handle case where field value is null
    }
  }

  Future<void> getProfileImageUrl() async {
    try {

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(const GetOptions(source: Source.serverAndCache));

      // Check if document exists
      if (userSnapshot.exists) {
        // Retrieve profile image URL from the user document
        setState(() {
          profileImageUrl = userSnapshot.data()?['profileUrl'];
        });
      } else {
        print('User document does not exist.');
      }
    } catch (e) {
      print('Error fetching profile image URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double horizontalPadding = screenWidth * 0.01;
    double verticalPadding = screenHeight * 0.02;
    double profileImageSize = screenWidth * 0.3;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: verticalPadding * 2),
              IntrinsicHeight(
                child: Container(
                  margin: EdgeInsets.only(left: horizontalPadding * 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: <Widget>[
                          Container(
                            width: profileImageSize + 20,
                            height: profileImageSize + 20,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.redAccent,
                                  Colors.lightBlueAccent
                                ],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                stops: [0.2, 0.8],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            top: 10,
                            child: Container(
                              width: profileImageSize,
                              height: profileImageSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white, width: 15.0),
                              ),
                              child: ClipOval(
                                child: profileImageUrl != null
                                    ? CachedNetworkImage(
                                        imageUrl: profileImageUrl!,
                                        fit: BoxFit.fill,
                                      )
                                    : const LineIcon(
                                        LineIcons.peace,
                                        color: Colors.black,
                                        size: 80,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: horizontalPadding * 15),
                      const VerticalDivider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      SizedBox(width: horizontalPadding),
                      Padding(
                        padding: EdgeInsets.only(left: horizontalPadding * 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Joined",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              usageDuration,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: horizontalPadding * 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: verticalPadding),
                    Text(
                      username,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                          color: Colors.black),
                    ),
                    SizedBox(height: verticalPadding),
                    settingButton(
                      text: "Rewards",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const redeemScreen()),
                        );
                      },
                      textStyle: buttonText,
                    ),
                    SizedBox(height: verticalPadding * 2),
                    Text(
                      'Settings',
                      style: headText,
                    ),
                    SizedBox(height: verticalPadding),
                    settingButton(
                      text: "Your Account",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const YourAccount()),
                        );
                      },
                      textStyle: buttonText,
                    ),
                    SizedBox(height: verticalPadding),
                    settingButton(
                      text: "Notifications",
                      onTap: () {},
                      textStyle: buttonText,
                    ),

                    SizedBox(height: verticalPadding * 2),
                    Text(
                      'Help and Support',
                      style: headText,
                    ),
                    SizedBox(height: verticalPadding),
                    settingButton(
                      text: "How it works",
                      onTap: () {
                        Navigator.pushNamed(context, '/howitsworks');
                      },
                      textStyle: buttonText,
                    ),
                    SizedBox(height: verticalPadding),
                    settingButton(
                      text: "FAQ",
                      onTap: () {
                        Navigator.pushNamed(context, '/faqs');
                      },
                      textStyle: buttonText,
                    ),
                    SizedBox(height: verticalPadding),
                    settingButton(
                      text: "Contact Us",
                      onTap: () {
                        Navigator.pushNamed(context, '/contactus');
                      },
                      textStyle: buttonText,
                    ),
                    // SizedBox(height: verticalPadding * 2),
                    SizedBox(height: verticalPadding * 2),
                    Text(
                      'Legals',
                      style: headText,
                    ),
                    SizedBox(height: verticalPadding),
                    settingButton(
                      text: "Terms and conditions",
                      onTap: () {
                        Navigator.pushNamed(context, '/howitsworks');
                      },
                      textStyle: buttonText,
                    ),
                    SizedBox(height: verticalPadding),
                    settingButton(
                      text: "Privacy policy",
                      onTap: () {
                        Navigator.pushNamed(context, '/privacypolicy');
                      },
                      textStyle: buttonText,
                    ),

                    SizedBox(height: verticalPadding * 2),

                    SizedBox(height: verticalPadding),
                    settingButton(
                      text: "Sign out",
                      onTap: () {
                        _showSignOutDialog(context);
                      },
                      textStyle: buttonText,
                    ),
                    SizedBox(height: verticalPadding),
                  ],
                ),
              ),
            ])),
      ),
    );
  }
}
