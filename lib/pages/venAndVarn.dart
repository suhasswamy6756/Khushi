import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kushi_3/pages/mainactivity.dart';

class VenVarn extends StatelessWidget {
  final String venVarn1= "https://www.google.com/search?client=ms-android-xiaomi-rvo2b&sca_esv=db699bbe45cbe8a4&sxsrf=ADLYWILACBnBfNYWDP64vbGj4QR7-YGcLg%3A1718950197455&q=VEN%20%26%20VARN%20CAFERY&ludocid=12616063620908756631&ibp=gwp%3B0%2C7&lsig=AB86z5WgX7Ml_G23AwbTZJKqIlSx&kgs=d7c1a5b77c6e4fe4&shndl=-1&shem=lsde%2Clsp%2Cssim&source=sh%2Fx%2Floc%2Fact%2Fm4%2F2";
  final String venVarn2= "https://www.google.com/search?client=ms-android-xiaomi-rvo2b&sca_esv=db699bbe45cbe8a4&sxsrf=ADLYWIJ8jpsRq2lKLOj9ABcxxhrtuO_Shg%3A1718950377418&q=VEN%20%26%20VARN&ludocid=17048171673465007331&ibp=gwp%3B0%2C7&lsig=AB86z5WxBwKgkxFvywQlnKXxuCm1&kgs=ec8e7c0df4436a6f&shndl=-1&shem=lsde%2Clsp%2Cssim&source=sh%2Fx%2Floc%2Fact%2Fm1%2F2";
  final String venVarn3= "https://g.co/kgs/RX8sdfT";
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('d MMM').format(now);
    return Scaffold(
      appBar: AppBar(

        toolbarHeight: screenHeight*0.09,
        title: Center(
          child: Column(
            children: [
              Text(
                'Ven and Varn Cafery',
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
        //leading: _buildUserProfileAvatar(),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, '/notification');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The places where you can redeem your rewards!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(59, 59, 59, 1),
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                GestureDetector(
                  onTap: ()  => _launchURL(venVarn1),
                  child: Container(
                    height: screenHeight * 0.25,
                    width: screenWidth * 0.9,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/venVarn1.png"),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ven & Varn Cafery',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Aecs layout-D Block',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                GestureDetector(
                  onTap: ()  => _launchURL(venVarn2),
                  child: Container(
                    height: screenHeight * 0.25,
                    width: screenWidth * 0.9,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/venVarn2.png"),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ven & Varn Cafery',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Regatapalli, Andhra Pradesh',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              children: [
                GestureDetector(
                  onTap: ()  => _launchURL(venVarn3),
                  child: Container(
                    height: screenHeight * 0.25,
                    width: screenWidth * 0.9,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/venVarn3.png"),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ven & Varn Cafery',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Pullover driver-in',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      ),
    );
  }
  void _launchURL(String url) async {
    launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }
}