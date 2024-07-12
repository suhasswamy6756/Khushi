import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kushi_3/pages/venAndVarn.dart';

import 'package:kushi_3/service/auth/auth_service.dart';
import 'package:kushi_3/service/firestore_service.dart';
import 'package:line_icons/line_icons.dart';
import 'package:kushi_3/model/globals.dart' as globals;
import 'Fragments/mainFragments/Profile_Fragment.dart';
import 'Fragments/mainFragments/actvity_fragment.dart';

import 'Fragments/mainFragments/home_fragment.dart';

FirestoreService _firestoreService = FirestoreService();
class MainActivity extends StatefulWidget {
  //final dynamic namey;
    const MainActivity({
    super.key,
    //required this.namey,
  });


  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  String? profileImageUrl;
  String profileName = " ";
  int _selectedIndex = 0;


  static final List<Widget> _widgetOptions = <Widget>[
    const HomeFragment(),
    const ActivityFragment(),

    ProfileFragment(),
  ];

  @override
  void initState() {
    super.initState();
    setUserName();
  }
  Future<void> setUserName() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();
    String? fullName = userDoc['full_name'];
    String? proImageUrl=userDoc.data()?['profileUrl'];
    if (fullName != null) {
      setState(() {
       profileName = fullName;
       profileImageUrl=proImageUrl;
      });
    } else {
      // Handle case where field value is null
      profileName = "User";
    }
  }

  void checkHealthConnect() async {
    var result = await HealthConnectFactory.isAvailable();
    var result1 = await HealthConnectFactory.hasPermissions(
        [HealthConnectDataType.Steps]);
    if (!result) {
      await HealthConnectFactory.installHealthConnect();
    }
    if (!result1) {
      await HealthConnectFactory.requestPermissions(
          [HealthConnectDataType.Steps]);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMM').format(now);

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(

        toolbarHeight: 90,
        title: Center(
          child: Column(
            children: [
              Text(
                'Hello, $profileName',
                style: GoogleFonts.roboto(
                  fontSize: 15,

                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Today $formattedDate',
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
        leading: _buildUserProfileAvatar(),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigator.pushNamed(context, '/notification');
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.white,
          )
        ]),
        child: SafeArea(
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.black,
            tabBackgroundColor: Colors.white,
            rippleColor: Colors.white,
            hoverColor: Colors.white,
            gap: 5,
            iconSize: 24,
            tabs: const [
              GButton(icon: LineIcons.home),
              GButton(icon: Icons.auto_graph_outlined),

              GButton(icon: Icons.person),
              // GButton(icon: Icons.person_outline),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileAvatar() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: profileImageUrl != null
              ? CachedNetworkImage(
                  imageUrl: profileImageUrl!,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                )
              : Image.asset(
                  'assets/mario.jpg',
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                ),
        ),
      ),
    );
  }
}


