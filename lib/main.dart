// Flutter imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowtowv1/bloc/auth/auth_bloc.dart';
import 'package:nowtowv1/bloc/auth/auth_events.dart';
import 'package:nowtowv1/bloc/auth/auth_state.dart';
import 'package:nowtowv1/bloc/mapbloc/map_bloc.dart';
import 'package:nowtowv1/bloc/markers/markers_bloc.dart';
import 'package:nowtowv1/bloc/overview/overview_bloc.dart';
import 'package:nowtowv1/pages/home/home.dart';
import 'package:nowtowv1/pages/login/login.dart';
import 'package:nowtowv1/pages/validate_email/validate_email.dart';
import 'package:nowtowv1/pages/validate_email/validate_email_wrapper.dart';
import 'package:nowtowv1/utils/apple_signin_available.dart';
import 'package:nowtowv1/utils/authentication.dart';
import 'package:nowtowv1/utils/firebase.dart';
import 'package:nowtowv1/utils/firebase_storage.dart';
import 'package:nowtowv1/utils/geofence_region.dart';
import 'package:nowtowv1/utils/geofence_trigger.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    GeofencingManager.initialize();
    GeofenceTrigger.createHomeGeofence();
  }

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
            : MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => MarkersBloc(
                        service: FirebaseService(user.uid), storage: Storage()),
                  ),
                  BlocProvider(
                    create: (_) => OverviewBloc(),
                  ),
                  BlocProvider(create: (_) => MapBloc())
                ],
                child: MultiProvider(
                  providers: [
                    Provider(create: (_) => Storage()),
                  ],
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'No Tow',
                    theme: ThemeData(
                      primaryColor: createMaterialColor(Colors.indigo),
                      primarySwatch: createMaterialColor(Colors.indigo),
                    ),
                    initialRoute: '/',
                    onGenerateRoute: RouteGenerator.generateRoute,
                    home: VerifyWrapper(key: key),
                  ),
                ),
              );
      },
    );
  }
}
