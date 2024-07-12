import 'package:flutter/material.dart';
import 'package:kushi_3/components/message.dart';
import 'package:kushi_3/components/mybutton.dart';
import 'package:kushi_3/pages/refer_page.dart';
import 'package:kushi_3/pages/selectGender.dart';
import 'package:kushi_3/service/auth/ref_provider.dart';
import 'package:kushi_3/service/firestore_service.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  _ReferralScreenState createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {

  TextEditingController _referralController = TextEditingController();
  FirestoreService _firestoreService = FirestoreService();
  RefProvider ref = RefProvider();


  @override
  void dispose() {
    _referralController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _referralController,
              decoration: const InputDecoration(
                labelText: 'Enter Referral Code',
              ),
            ),
            const SizedBox(height: 20),
            MyButton(text: 'Continue', onTap: (){
              if(_referralController.text.isEmpty){
                showMessage(context, "All field are required");
              }else{
                ref.setReferral(_referralController.text);
                showMessage(context, _referralController.text);
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectGender(),
                ),
              );
            }),
            const SizedBox(height: 50,),
            TextButton(
              onPressed: () async{


              },
              child: const Text('No referral? Continue instead'),
            ),
          ],
        ),
      ),
    );
  }
}
