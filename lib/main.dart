// Flutter imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowtowv1/bloc/auth/auth_bloc.dart';
import 'package:nowtowv1/bloc/auth/auth_events.dart';
import 'package:nowtowv1/bloc/auth/auth_state.dart';
import 'package:nowtowv1/pages/home/home.dart';
import 'package:nowtowv1/pages/login/login.dart';
import 'package:nowtowv1/utils/apple_signin_available.dart';
import 'package:nowtowv1/utils/authentication.dart';
import 'package:nowtowv1/utils/firebase.dart';
import 'package:nowtowv1/utils/notow_colors.dart';
import 'package:nowtowv1/utils/route_generator.dart';
import 'package:provider/provider.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appleSignInAvailable = await AppleSignInAvailable.check();
  runApp(Provider<AppleSignInAvailable>.value(
    value: appleSignInAvailable,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationService authService = AuthenticationService();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authService: authService),
        )
      ],
      child: const AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stateBloc = BlocProvider.of<AuthBloc>(context);
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: stateBloc,
      builder: (context, state) {
        stateBloc.authService.user.listen((User? streamUser) {
          if (streamUser != null && state.user == null) {
            stateBloc.add(AlreadyLoggedInEvent(user: streamUser));
          }
        });
        final User? user = state.user;
        return user == null
            ? MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'No Tow',
                theme: ThemeData(
                  primaryColor: createMaterialColor(Colors.indigo),
                  primarySwatch: createMaterialColor(Colors.indigo),
                ),
                initialRoute: '/',
                onGenerateRoute: RouteGenerator.generateRoute,
                home: const Scaffold(
                  body: Center(
                    child: LoginPage(title: 'No Tow'),
                  ),
                ),
              )
            : MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'No Tow',
                theme: ThemeData(
                  primaryColor: createMaterialColor(Colors.indigo),
                  primarySwatch: createMaterialColor(Colors.indigo),
                ),
                initialRoute: '/',
                onGenerateRoute: RouteGenerator.generateRoute,
                home: Scaffold(
                  body: HomePage(),
                ),
              );
      },
    );
  }
}
