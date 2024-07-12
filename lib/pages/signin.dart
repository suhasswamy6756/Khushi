import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kushi_3/components/message.dart';
import 'package:kushi_3/components/mybutton.dart';
import 'package:kushi_3/model/user_data.dart';
import 'package:kushi_3/service/firestore_service.dart';
import 'dart:developer' as developer;



class SignIn extends StatefulWidget {

  const SignIn({super.key});

  static String verify = "";
  static String phone = "";
  static bool isSignInUsingPhoneAuth = true;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  FirebaseAuth auth = FirebaseAuth.instance;
 final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController countryCode = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: ""
  );

  Future<void> storeUserData(String uid, String phoneNumber) async {
    try {
      await FirebaseFirestore.instance.collection('user').doc(uid).set({
        'phoneNumber': phoneNumber,

        // Add other user data as needed
      });
      developer.log('User data stored successfully');
    } catch (e) {
      developer.log('Error storing user data: $e');
    }
  }



  @override
  void initState() {
    countryCode.text = "+91";
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const SizedBox(height: 230,),

              const Text(
                "Phone Verification",
                style: TextStyle(
                  fontWeight: FontWeight.w700,

                  color: Colors.black,
                  fontSize: 29,
                ),
              ),

              const SizedBox(height: 25,),
              Container(
                height: 55,
                margin: const EdgeInsets.only(left: 30, right: 30),
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),

                    Expanded(

                      child: TextField(
                        controller: phoneNumber,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                          // Limit to 10 characters
                          _PhoneNumberFormatter(),
                          // Custom input formatter for phone number
                        ],
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Phone",

                            prefixIcon: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  showCountryPicker(context: context, onSelect:(value){
                                    setState(() {
                                      selectedCountry= value;
                                    });
                                  });
                                },
                                child: Text(
                                  "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )


                        ),

                      ),
                    )
                  ],
                ),
              ),


              const SizedBox(height: 50,),
              MyButton(text: "Send the code", onTap: () async {

                userDataMap["phoneNumber"] = '${countryCode.text} ${phoneNumber.text}';

                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: '${countryCode.text} ${phoneNumber.text}',
                  verificationCompleted: (PhoneAuthCredential credential)  {

                  },
                  verificationFailed: (FirebaseAuthException e) {
                    if (e.code == 'invalid-phone-number') {
                      showMessage(context, 'The provided phone number is not valid.');
                    } else {
                      showMessage(context, 'Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
                    }
                  },
                  codeSent: (String verificationId, int? resendToken) {
                    SignIn.phone = '${countryCode.text} ${phoneNumber.text}';
                    SignIn.verify = verificationId;
                    // SignIn.phone = "$countryCode $phoneNumber";
                    Navigator.pushNamed(
                        context,
                        '/OTPPage',
                        arguments: "${countryCode.text} ${phoneNumber.text}"
                    );
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {
                    SignIn.verify = verificationId;
                  },

                );
              }
              ),
              const SizedBox(height: 15,),

              const SizedBox(height: 50,),





            ],
          ),
        ),
      ),
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    if (newValue.text.length == 1) {
      return newValue.copyWith(
        text: newValue.text, // Automatically add '+' at the beginning
        selection: TextSelection.collapsed(offset: newValue.text.length),
      );
    } else {
      return newValue;
    }
  }
}
