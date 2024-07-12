import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kushi_3/model/SpendCoin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kushi_3/model/globals.dart' as globals;
import 'package:kushi_3/service/firestore_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class redeemScreen extends StatefulWidget {
  const redeemScreen({Key? key}) : super(key: key);

  @override
  _RedeemScreenState createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<redeemScreen> {
  int availableCoins = 0;
  int availableAmount = 0;
  Color _scaffoldColor = Colors.white;
  final TextEditingController _controller = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final SpendCoin _spendCoin = SpendCoin();
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  String date = "";
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchAvailableCoins();
  }

  Future<void> _fetchAvailableCoins() async {
    try {
      int fortyTokens = await globals.get40CoinNumber(
          _firestoreService.getCurrentUserId());
      int twentyTokens = await globals.get20CoinNumber(
          _firestoreService.getCurrentUserId());
      int tenTokens = await globals.get10CoinNumber(
          _firestoreService.getCurrentUserId());
      int totalCoins = fortyTokens  + twentyTokens  + tenTokens;
      int totalAmount = fortyTokens * 40 + twentyTokens * 20 + tenTokens * 10;
      setState(() {
        availableCoins = totalCoins;
        availableAmount=totalAmount;
      });
    } catch (e) {
      _showPopup(context, 'Failed to fetch available coins: $e');
    }
  }
    Future<void> _redeemCoins() async {
      int redeemAmount = int.tryParse(_controller.text) ?? 0;
      if (redeemAmount <= 0 || redeemAmount > availableAmount ||
          redeemAmount % 10 != 0) {
        _showPopup(context,
            "Insufficient balance.\n Please check your available coins and try again.");
        return;
      }
      // Show a loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      try {
        await _spendCoin.spendToken(redeemAmount);
        Navigator.of(context).pop(); // Close the loading indicator
        _certificate(context, 'Successful',redeemAmount);
        _fetchAvailableCoins(); // Update available coins
      } catch (e) {
        Navigator.of(context).pop(); // Close the loading indicator
        _showPopup(context, 'Failed to redeem coins: $e');
      }

    }

  void _certificate(BuildContext context, String message, int redeemAmount) {
    var screenSize = MediaQuery.of(context).size;
    var dialogWidth = screenSize.width * 0.9;
    AwesomeDialog(
      context: context,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      dialogType: DialogType.success,
      showCloseIcon:false,
      title: 'Success',
      dialogBackgroundColor: Colors.white,  // Set the dialog background color
      titleTextStyle: const TextStyle(
        color: Colors.black,  // Customize title text color
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      descTextStyle: const TextStyle(
        color: Colors.black54,  // Customize description text color
        fontSize: 16,
      ),
      onDismissCallback: (type) {
        debugPrint('Dialog Dismissed from callback $type');
      },
      // Customize the dialog padding to make it responsive
      padding: EdgeInsets.symmetric(
        horizontal: dialogWidth * 0.1,  // Adjust horizontal padding according to screen size
        vertical: 20,
      ),
      // Custom OK button with text color and other styling options
      btnOk: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF064A52), // Button text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
          debugPrint('OnClick');
        },
        child: const Text('Return to Home'),
      ),
      customHeader: Stack(
        alignment: Alignment.center,
        children: [
          // Outer circle with lighter color
          Container(
            width: 90,  // Adjust the size as needed
            height: 90,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF17A8B2),
            ),
          ),
          // Main circle with darker color
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF064A52),  // Background color of the circle
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,  // Color of the check icon
              size: 50,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
        Text(
          'Total Amount Redeemed',
          style: TextStyle(
            color: Colors.black38,
            fontSize: dialogWidth * 0.06,
          ),
        ),
          const SizedBox(height: 10),
        Text(
          '₹$redeemAmount',
          style: TextStyle(
            color: Colors.black,
            fontSize: dialogWidth * 0.1,
            fontWeight: FontWeight.bold,
          ),
        ),
          const SizedBox(height: 20),
        Text(
          'Activated',
          style: TextStyle(
            color: Colors.black,
            fontSize: dialogWidth * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date',
                    style: TextStyle(
                      color: Colors.black38,
                        fontSize: dialogWidth * 0.06,
                    ),
                  ),
                  Text(
                    DateFormat('dd MMM yyyy').format(DateTime.now()),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: dialogWidth * 0.06,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Time',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: dialogWidth * 0.06,
                    ),
                  ),
                  Text(
                    DateFormat('hh:mm:ss a').format(DateTime.now()),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: dialogWidth * 0.06,
                    ),
                  ),
          ]
        ),
          ]
    ),
        )
    ],
    ),
    ).show();

    // Automatically close the dialog after 15 seconds
    Future.delayed(const Duration(seconds: 15), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }
    void _showPopup(BuildContext context, String message)
    {
      final mediaQuery = MediaQuery.of(context);
      final screenWidth = mediaQuery.size.width;
      final screenHeight = mediaQuery.size.height;
      showDialog(
          context: context,
          builder: (BuildContext context)
      {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.8,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Text(message, textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black,fontSize: screenWidth * 0.05),
                ),
                SizedBox(height: screenHeight * 0.02),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                  ),
                  child: const Text('Okay',style: TextStyle(
                      color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
      );

      Future.delayed(const Duration(seconds: 5), () {
        Navigator.of(context).pop();
        setState(() {
          _scaffoldColor = Colors.white;
        });
      });
    }

    @override
    Widget build(BuildContext context) {
      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height;
      final screenWidth = mediaQuery.size.width;
      return Scaffold(
        backgroundColor: _scaffoldColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
          'Rewards',
          style: TextStyle(color: Colors.black, fontSize: screenWidth * 0.05),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            children: [
              // Rewards Section
              Card(
                elevation: 8.0,
                color: Colors.white,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/img_1.png',
                            width:screenWidth*0.12,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            '$availableAmount',
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Amount',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            'assets/img.png',
                            width:screenWidth*0.1,
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            '$availableCoins',
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total Coins',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
                  // Enter Amount Section
                  Text(
                    'Enter Amount',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
              SizedBox(
                width: screenWidth * 0.6,
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: screenWidth * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefix: Text(
                      '₹',
                      style: TextStyle(
                        fontSize: screenWidth * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
                  SizedBox(height: screenHeight * 0.04),
                  // Redeem Button
                  ElevatedButton(
                    onPressed: _redeemCoins,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical: screenHeight * 0.015,
                      ),
                      child: Text(
                        'Redeem',
                        style: TextStyle(fontSize: screenWidth * 0.05,color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
      );
    }
}