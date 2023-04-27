import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowtowv1/bloc/auth/auth_bloc.dart';
import 'package:nowtowv1/bloc/auth/auth_events.dart';
import 'package:nowtowv1/bloc/auth/auth_state.dart';
import 'package:nowtowv1/pages/home/home.dart';
import 'package:nowtowv1/pages/splash_screen/splash_screen.dart';
import 'package:nowtowv1/pages/validate_email/validate_email.dart';

class VerifyWrapper extends StatefulWidget {
  VerifyWrapper({Key? key}) : super(key: key);

  @override
  State<VerifyWrapper> createState() => _VerifyWrapperState();
}

class _VerifyWrapperState extends State<VerifyWrapper> {
  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(VerifyEmailEvent(
        isVerified: authBloc.authService.isEmailVerified() ?? false));
    if (authBloc.authService.isEmailVerified() != null) {
      return authBloc.state.emailVerified ||
              authBloc.state.status == AuthStatus.initial
          ? SplashScreen()
          : MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Noto',
              theme: ThemeData(
                primaryColor: Colors.indigo,
                primarySwatch: Colors.indigo,
              ),
              initialRoute: '/',
              home: const Scaffold(
                body: Center(
                  child: EmailVerificationScreen(),
                ),
              ),
            );
    } else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Noto',
        theme: ThemeData(
          primaryColor: Colors.indigo,
          primarySwatch: Colors.indigo,
        ),
        initialRoute: '/',
        home: const Scaffold(
          body: Center(
            child: EmailVerificationScreen(),
          ),
        ),
      );
    }
  }
}
