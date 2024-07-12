import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kushi_3/pages/signin.dart';
import 'package:kushi_3/pages/signup.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroSlider extends StatefulWidget {
  const IntroSlider({super.key});

  @override
  State<IntroSlider> createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index) {
                setState(() {
                  isLastPage = index == 1;
                });
              },
              children: const [
                BuildIntroPage(
                  title: "Workout Categories",
                  description: 'Workout categories will help you gain '
                      'strength, get in better shape and embrace '
                      'a healthy lifestyle',
                  imagePath: 'assets/introPage/first.png', // Add your image path here
                ),
                BuildIntroPage(
                  title: "Healthy Lifestyle",
                  description: 'Workout categories will help you gain '
                      'strength, get in better shape and embrace '
                      'a healthy lifestyle',
                  imagePath: 'assets/introPage/secondNew.png', // Add your image path here
                ),
              ],
            ),
          ),
          Center(
            child: SmoothPageIndicator(
              controller: _controller,
              count: 2,
              onDotClicked: (index) {
                _controller.animateToPage(index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
              effect: const ExpandingDotsEffect(
                activeDotColor: Colors.black,
                dotWidth: 10,
                dotHeight: 10,
                dotColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 66,
            width: 188,
            // margin: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                elevation: 10,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
              onPressed: isLastPage
                  ? () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return const SignIn();
                    }));
              }
                  : () {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );
              },
              child: Text(
                isLastPage ? 'Get Started' : "Next",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          SizedBox(height: 27,),
        ],
      ),
    );
  }
}

class BuildIntroPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath; // Add image path parameter

  const BuildIntroPage({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath, // Initialize image path
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          title,
          style: GoogleFonts.poppins(

            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 50),
          child: Text(
            description,
            style: GoogleFonts.poppins(
              fontWeight:FontWeight.w400,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 3,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
