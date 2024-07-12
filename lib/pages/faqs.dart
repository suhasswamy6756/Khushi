import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class Faqs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FAQ",
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
      body: FAQList(),
    );
  }
}

class FAQList extends StatelessWidget {
  final CollectionReference faqsCollection = FirebaseFirestore.instance.collection('faqs');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: faqsCollection.orderBy('order').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No FAQs found'));
        }

        var faqs = snapshot.data!.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        return ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            var faq = faqs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    faq["question"] ?? '',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    faq["answer"] ?? '',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 16),
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
