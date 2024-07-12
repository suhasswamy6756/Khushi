import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kushi_3/components/mybutton.dart';
import 'package:kushi_3/components/optionButton.dart';

import 'package:kushi_3/model/user_data.dart';
import 'package:kushi_3/service/firestore_service.dart';

class SelectGender extends StatefulWidget {
  const SelectGender({super.key});

  @override
  State<StatefulWidget> createState() => selectGenderState();
}

// ignore: camel_case_types
class selectGenderState extends State<SelectGender> {
  int selectedOptionIndex = -1;
  String gender = "";
  final FirestoreService _firestoreService = FirestoreService();

  // -1 shows that no option is initially selected

  void selectOption(int index) {
    setState(() {
      selectedOptionIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Step 1 of 3",
            style:
                GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back), // Back arrow icon
            onPressed: () {
              Navigator.of(context).pop(); // Navigate back when pressed
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Handle Skip button press
              },
              child: Text(
                'Skip',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                  color: Colors.black, // Change the text color as needed
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              // const Text("Step 1 of 8", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              const SizedBox(
                height: 90,
              ),
              Text(
                "Choose gender",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 26,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              OptionButton(
                  emojiText: "👩",
                  text: "Female",
                  isSelected: selectedOptionIndex == 0,
                  onTap: () {
                    selectOption(0);
                    userDataMap["gender"] = "female";
                  }),
              const SizedBox(
                height: 30,
              ),
              OptionButton(
                  emojiText: "👨",
                  text: "Male",
                  isSelected: selectedOptionIndex == 1,
                  onTap: () {
                    selectOption(1);
                    userDataMap["gender"] = "male";
                  }),
              const SizedBox(
                height: 30,
              ),
              OptionButton(
                  emojiText: "🧓",
                  text: "Other",
                  isSelected: selectedOptionIndex == 2,
                  onTap: () {
                    selectOption(2);
                    userDataMap["gender"] = "other";
                  }),

              const SizedBox(
                height: 120,
              ),
              MyButton(
                text: "Continue",
                onTap: () {
                  userDataMap['userId'] = _firestoreService.getCurrentUserId()!;
                  Navigator.pushNamed(context, '/selectHeight',
                      arguments: userDataMap);


                },
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // userDataMap.clear();
    super.dispose();
  }
}
