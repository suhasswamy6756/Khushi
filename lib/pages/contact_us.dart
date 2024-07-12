import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  final String email = 'Khushi.utoo@gmail.com';
  final String instagramUrl = 'https://www.instagram.com/p/C1cYbgwh9em/?utm_source=ig_web_button_native_share/';
  final String telegramUrl = 'https://telegram.org/';
  final String facebookUrl = 'https://www.facebook.com/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact us'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Don’t hesitate to contact us whether you have a suggestion on our improvement, a complain to discuss or an issue to solve.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Icon(Icons.email, size: 50),
                  SizedBox(height: 10),
                  Text(
                    'Email us',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(email, style: TextStyle(fontSize: 16)),
                  SizedBox(height: 5),
                  Text('Our team is online', style: TextStyle(fontSize: 16)),
                  Text('Mon-Fri  •  9-17', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            SizedBox(height: 20),
            SocialMediaButton(
              icon: Icons.camera_alt,
              text: 'Instagram',
              url: instagramUrl,
            ),
            SocialMediaButton(
              icon: Icons.send,
              text: 'Telegram',
              url: telegramUrl,
            ),
            SocialMediaButton(
              icon: Icons.facebook,
              text: 'Facebook',
              url: facebookUrl,
            ),
          ],
        ),
      ),
    );
  }
}

class SocialMediaButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final String url;

  SocialMediaButton(
      {required this.icon, required this.text, required this.url});

  void _launchURL(String url) async {
    launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
        trailing: Icon(Icons.share),
        onTap: () {
          _launchURL(url);
        },
      ),
    );
  }
}
