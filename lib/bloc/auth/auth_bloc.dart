import 'package:firebase_auth/firebase_auth.dart';
import 'package:nowtowv1/bloc/auth/auth_events.dart';
import 'package:nowtowv1/bloc/auth/auth_state.dart';
import 'package:nowtowv1/utils/authentication.dart';
import 'package:nowtowv1/utils/firebase.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

// Project imports:

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.authService,
  }) : super(AuthState(emailVerified: false)) {
    on<CreateAccountEvent>(_mapCreateEventToState);
    on<LoginEvent>(_mapLoginEventToState);
    on<LogoutEvent>(_mapLogoutEventToState);
    on<ResetPasswordEvent>(_mapResetPasswordEventToState);
    on<AlreadyLoggedInEvent>(_mapAlreadyLoggedInEventToState);
    on<GetNameEvent>(_mapGetNameEventToState);
    on<UpdateProfilePicEvent>(_mapUpdateProfilePicEventToState);
    on<VerifyEmailEvent>(_mapVerifyEmailEventToState);
    on<UpVoteMarkerEvent>(_mapAddUpVoteEventToState);
    on<DownVoteMarkerEvent>(_mapRemoveUpVoteEventToState);
  }
  final AuthenticationService authService;
  var numEvents = 0;

  void _mapCreateEventToState(
      CreateAccountEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final newUser = await authService.createUserWithEmailPassword(
          event.props[0] as String,
          event.props[1] as String,
          event.props[2] as String,
          event.props[3] as String);
      emit(
        state.copyWith(status: AuthStatus.success, emailVerified: false),
      );
    } on FirebaseException catch (error, stacktrace) {
      log(stacktrace.toString());
      if (error.code == 'email-already-in-use') {
        QuickAlert.show(
          context: event.context,
          type: QuickAlertType.error,
          title: 'Ugh Oh!',
          text: 'That Email is already in use.',
          confirmBtnColor: Theme.of(event.context).primaryColor,
          confirmBtnText: 'Ok',
        );
      }
      emit(state.copyWith(status: AuthStatus.error));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  void _mapLoginEventToState(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    bool appleError = false;
    bool profilePicError = false;
    User? newUser;
    String firstname = "";
    String lastname = "";
    String url = "";
    List<String> upVotes = [];
    try {
      if (event.props[3] as bool) {
        try {
          newUser = await authService
              .signInWithApple(scopes: [Scope.email, Scope.fullName]);
        } catch (e) {
          appleError = true;
          print(e);
          emit(state.copyWith(status: AuthStatus.error));
        }
      } else {
        try {
          newUser = await authService.signInWithEmailPassword(
              event.props[0] as String, event.props[1] as String);
        } catch (e) {
          print(e);
          emit(state.copyWith(status: AuthStatus.error));
        }
      }
      Map<String, dynamic> userData = await getUserData(state.user!.uid);
      firstname = userData['first_name'];
      lastname = userData['last_name'];
      upVotes = (List<String>.from(userData['up_votes'] as List));

      String profilePicId = "profilepic" + newUser!.uid;
      var ref = FirebaseStorage.instance.ref().child(profilePicId);
      url = await ref.getDownloadURL();
      emit(state.copyWith(
          status: AuthStatus.success,
          user: newUser,
          firstname: firstname,
          lastname: lastname,
          profilePicUrl: url,
          upVotes: upVotes,
          emailVerified: true));
    } catch (error, stacktrace) {
      if (error is FirebaseException) {
        if (error.code == "object-not-found") {
          profilePicError = true;
        }
      }
      if (profilePicError) {
        emit(state.copyWith(
            status: AuthStatus.success,
            user: newUser,
            firstname: firstname,
            lastname: lastname,
            profilePicUrl: null,
            upVotes: upVotes,
            emailVerified: true));
      } else {
        QuickAlert.show(
          context: event.context,
          type: QuickAlertType.error,
          title: 'Sign-In Failed!',
          text: 'Check your email and password. Please try again.',
          confirmBtnColor: Theme.of(event.context).primaryColor,
          confirmBtnText: 'Ok',
        );
        log(stacktrace.toString());
        emit(state.copyWith(status: AuthStatus.error));
      }
    }
  }

  void _mapLogoutEventToState(
      LogoutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await authService.signOut();
      emit(
        AuthState(
            status: AuthStatus.success,
            user: null,
            firstname: null,
            lastname: null,
            profilePicUrl: null,
            emailVerified: false),
      );
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  Future<void> _showMyDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Not Found!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _mapResetPasswordEventToState(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await authService.resetPassword(event.props[0] as String);
      emit(state.copyWith(
          status: AuthStatus.success,
          user: null,
          firstname: null,
          lastname: null,
          profilePicUrl: null));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  void _mapAlreadyLoggedInEventToState(
      AlreadyLoggedInEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      emit(state.copyWith(
          status: AuthStatus.success,
          user: event.user,
          firstname: null,
          lastname: null,
          profilePicUrl: null,
          emailVerified: authService.isEmailVerified()));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  void _mapGetNameEventToState(
      GetNameEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    bool profilePicError = false;
    String firstname = "";
    String lastname = "";
    List<String> upVotes = [];
    try {
      Map<String, dynamic> userData = await getUserData(state.user!.uid);
      firstname = userData['first_name'];
      lastname = userData['last_name'];
      upVotes = (List<String>.from(userData['up_votes'] as List));
      String profilePicId = "profilepic" + state.user!.uid;
      final ref = FirebaseStorage.instance.ref().child(profilePicId);
      String url = await ref.getDownloadURL();
      emit(state.copyWith(
          status: AuthStatus.success,
          user: state.user,
          firstname: firstname,
          lastname: lastname,
          upVotes: upVotes,
          profilePicUrl: url));
    } catch (error, stacktrace) {
      if (error is FirebaseException) {
        if (error.code == "object-not-found") {
          profilePicError = true;
        }
      }
      if (profilePicError) {
        emit(state.copyWith(
            status: AuthStatus.success,
            user: state.user,
            firstname: firstname,
            lastname: lastname,
            upVotes: upVotes,
            profilePicUrl: null));
      }
      log(stacktrace.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  void _mapUpdateProfilePicEventToState(
      UpdateProfilePicEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      emit(state.copyWith(
          status: AuthStatus.success, profilePicUrl: event.profilePic));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  void _mapVerifyEmailEventToState(
      VerifyEmailEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      emit(state.copyWith(
          status: AuthStatus.success, emailVerified: event.isVerified));
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  void _mapAddUpVoteEventToState(
      UpVoteMarkerEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      List<String> upVotes = [];
      if (event.id.isNotEmpty) {
        final CollectionReference userCollection =
            FirebaseFirestore.instance.collection('Users');
        DocumentSnapshot<Map<String, dynamic>> snapshot = await userCollection
            .doc(state.user!.uid)
            .get() as DocumentSnapshot<Map<String, dynamic>>;
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('up_votes')) {
          upVotes = (List<String>.from(data['up_votes'] as List));
          upVotes.add(event.id);
          await userCollection.doc(state.user!.uid).update({
            'up_votes': upVotes,
          });
        } else {
          upVotes = [event.id];
          await userCollection.doc(state.user!.uid).update({
            'up_votes': upVotes,
          });
        }

        emit(state.copyWith(status: AuthStatus.success, upVotes: upVotes));
      } else {
        emit(state.copyWith(status: AuthStatus.error));
      }
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  void _mapRemoveUpVoteEventToState(
      DownVoteMarkerEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      List<String> upVotes = [];
      if (event.id.isNotEmpty) {
        final CollectionReference userCollection =
            FirebaseFirestore.instance.collection('Users');
        DocumentSnapshot<Map<String, dynamic>> snapshot = await userCollection
            .doc(state.user!.uid)
            .get() as DocumentSnapshot<Map<String, dynamic>>;
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('up_votes')) {
          upVotes = (List<String>.from(data['up_votes'] as List));
          upVotes.remove(event.id);
          await userCollection.doc(state.user!.uid).update({
            'up_votes': upVotes,
          });
        }
        emit(state.copyWith(status: AuthStatus.success, upVotes: upVotes));
      } else {
        emit(state.copyWith(status: AuthStatus.error));
      }
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: AuthStatus.error));
    }
  }

  // get user data
  Future<Map<String, dynamic>> getUserData(String uid) async {
    numEvents += 1;
    log('$numEvents');
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('Users');
    DocumentSnapshot<Map<String, dynamic>> snapshot = await userCollection
        .doc(uid)
        .get() as DocumentSnapshot<Map<String, dynamic>>;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if (!data.containsKey('up_votes')) {
      //create new up vote field for user in database
      await userCollection.doc(uid).update({
        'up_votes': [],
      });
      data['up_votes'] = [];
    }
    return data;
  }
}
