import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kushi_3/model/user_data.dart';
import 'package:kushi_3/service/firestore_service.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:kushi_3/components/mybutton.dart';

class SelectHeight extends StatefulWidget {
  const SelectHeight({super.key});

  @override
  State<StatefulWidget> createState() => selectHeightState();
}

var labelStart = 1;
var btnStyle1 = GoogleFonts.openSans(
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontSize: 13,
);
var btnStyle2 = GoogleFonts.openSans(
  color: Colors.black,
  fontWeight: FontWeight.w400,
  fontSize: 13,
);

class selectHeightState extends State<SelectHeight> {
  var labels = ['ft', 'cm'];
  var heightUnit = "cm";
  TextEditingController height = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(
            "Step 2 of 3",
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 60,
              ),
              const SizedBox(
                height: 90,
              ),
              Text(
                "Enter height",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 25,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ToggleSwitch(
                  minWidth: 150.0,
                  initialLabelIndex: labelStart,
                  cornerRadius: 30.0,
                  radiusStyle: true,
                  activeBgColor: const [Colors.white],
                  customTextStyles: [btnStyle2, btnStyle1],
                  borderColor: const [Colors.grey],
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  labels: const ["Feet", "Centimetre"],
                  onToggle: (index) {
                    if (index != null) {
                      setState(() {
                        var temp = btnStyle1;
                        btnStyle1 = btnStyle2;
                        btnStyle2 = temp;
                        labelStart = index;
                        heightUnit = labels[index];
                        print(heightUnit);
                      });
                    }
                  }),
              const SizedBox(
                height: 90,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        // Adjust the radius as per your requirement
                        border: Border.all(color: Colors.grey),
                      ),
                      width: 100,
                      child: TextField(
                          controller: height,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20),
                          keyboardType: TextInputType.number,
                          decoration:  InputDecoration(
                              filled: true,
                              fillColor: Theme.of(context).colorScheme.primary,
                              border: InputBorder.none))),
                  const SizedBox(width: 10),
                  Text(
                    heightUnit,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              MyButton(
                text: "Continue",
                onTap: () {
                  userDataMap['height'] = "${height.text} $heightUnit";
                  // _firestoreService.updateUserDocument(_firestoreService.getCurrentUserId()!, userDataMap, context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/selectWeight', (route) => false,
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
