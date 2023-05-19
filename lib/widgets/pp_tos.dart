import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(Uri _url) async {
  try {
    await launchUrl(_url);
  } catch (e) {
    log("link failed to launch");
  }
}

Widget privacyPolicyLinkAndTermsOfService() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.all(20),
    child: Center(
        child: Text.rich(TextSpan(
            text: 'By continuing, you agree to our ',
            style: TextStyle(fontSize: 16, color: Colors.black),
            children: <TextSpan>[
          TextSpan(
              text: 'Terms of Service',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  final Uri _url = Uri.parse(
                      'https://doc-hosting.flycricket.io/noto-terms-of-use/b4f33a67-6c27-494d-bc69-77984c334bd6/terms');
                  launchUrl(_url);
                }),
          TextSpan(
              text: ' and ',
              style: TextStyle(fontSize: 18, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                        decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        final Uri _url = Uri.parse(
                            'https://doc-hosting.flycricket.io/noto-privacy-policy/6ce5d01c-a1f2-4cff-af9c-bc2a07e20416/privacy');
                        launchUrl(_url);
                      })
              ])
        ]))),
  );
}
