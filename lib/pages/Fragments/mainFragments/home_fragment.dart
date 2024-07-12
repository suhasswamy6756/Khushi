import 'package:flutter/material.dart';
import 'package:kushi_3/pages/Fragments/mainFragments/redeemScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kushi_3/pages/venAndVarn.dart';
import 'package:kushi_3/service/fitness/fetch_details.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  late var _steps = 0;

  final FitnessDetails _fit = FitnessDetails();

  @override
  void initState() {
    super.initState();
    _initializeSteps();
  }

  Future<void> _initializeSteps() async {
    try {
      int steps = await _fit.fetchTotalSteps();
      setState(() {
        _steps = steps;
      });
    } catch (e) {
      print('Error initializing steps: $e');
      setState(() {
        _steps = 0;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _steps = 0;
    });
    await Future.delayed(const Duration(seconds: 1));
    int newSteps = await _fit.fetchTotalSteps();
    setState(() {
      _steps = newSteps;
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double percentage = _steps / 100;

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(

                margin: const EdgeInsets.all(25),
                height: screenHeight * 0.25,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromRGBO(232, 232, 232, 1),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Daily",
                            style: TextStyle(

                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "challenge",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/Ellipse.png',
                            fit: BoxFit.cover,
                            width: screenWidth * 0.35,
                          ),
                          Image.asset(
                            'assets/first_page.png',
                            fit: BoxFit.cover,
                            width: screenWidth * 0.35,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Text(
                          '$_steps Steps',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color:Colors.black
                          ),
                        )),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      height: 10,
                      color: Colors.transparent,
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            minHeight: 10,
                            backgroundColor: Colors.green[100],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.green),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '${(percentage ).toStringAsFixed(1)}%',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                          color:Colors.black
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Redeem',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(59, 59, 59, 1),
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => VenVarn()),
                          );
                        },
                        child: Container(
                          height: screenHeight * 0.25,
                          width: screenWidth * 0.9,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage("assets/img_2.png"),
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(232, 232, 232, 0.5647058823529412),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: const Text(

                              'Ven&Varn  ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      Container(
                        height: screenHeight * 0.25,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/home/cafe.png"),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(232, 232, 232, 0.5647058823529412),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: const Text(
                              'Restaurants                           Coming Soon!!!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      Container(
                        height: screenHeight * 0.25,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(

                          image: const DecorationImage(
                            image: AssetImage("assets/home/store.png"),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(232, 232, 232, 0.5647058823529412),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                          child: Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: const Text(
                              'Apparels                                Coming Soon!!!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    children:[
                      Container(
                        height: screenHeight * 0.09,
                        width: screenWidth * 0.9,
                        child: Text(
                      'Many More!!',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left,
                    ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

