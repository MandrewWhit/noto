// Flutter imports:
import 'package:flutter/material.dart';
import 'package:nowtowv1/pages/login/login.dart';
import 'package:nowtowv1/pages/reset_password/reset_password.dart';
import 'package:nowtowv1/pages/sign_up/create_account.dart';

// Project imports:

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => const LoginPage(
                  title: 'No Tow',
                ));
      case '/create-account':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => CreateAccount(
              data: args,
            ),
          );
        }
        return errorRoute();
      case '/reset-password':
        {
          return MaterialPageRoute(
              builder: (_) => const ResetPasswordPage(title: 'No Tow'));
        }
      case '/home':
        //if (args is StowUser) {
        return MaterialPageRoute(
          // builder: (_) => const Home(
          //     //user: args,
          //     ),
          builder: (_) => Container(
              //user: args,
              ),
        );
      default:
        return errorRoute();
    }
  }

  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
