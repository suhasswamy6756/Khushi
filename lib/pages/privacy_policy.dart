import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy policy",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back arrow icon
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back when pressed
          },
        ),
      ),
      body: PrivacyPolicyList(),
    );
  }
}

class PrivacyPolicyList extends StatelessWidget{
  final CollectionReference privacyPolicyCollection = FirebaseFirestore.instance.collection('privacyPolicy');

    @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: privacyPolicyCollection.orderBy('order').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Privacy Policies found'));
        }

        var privacy_policy = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: privacy_policy.length,
          itemBuilder: (context, index) {
            var privacyPolicy = privacy_policy[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: (privacyPolicy['order']?.toString() ?? ''),
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        const TextSpan(
                          text: '. ',
                        ),
                        TextSpan(
                          text: privacyPolicy['description'] ?? '',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

}
