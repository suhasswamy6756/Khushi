import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HowItsWork extends StatelessWidget {
  const HowItsWork({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(
        "How it works ?",
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 19,
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
        body: HowItWorksList(),
    );
  }
}

class HowItWorksList extends StatelessWidget {
  final CollectionReference howItWorksCollection = FirebaseFirestore.instance.collection('howItWorks');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: howItWorksCollection.orderBy('order').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No details found'));
        }

        var hwItWrks = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: hwItWrks.length,
          itemBuilder: (context, index) {
            var how_it_works = hwItWrks[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: (how_it_works['order']?.toString() ?? ''),
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                        const TextSpan(
                          text: '. ',
                        ),
                        TextSpan(
                          text: how_it_works['description'] ?? '',
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