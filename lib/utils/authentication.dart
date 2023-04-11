import 'package:nowtowv1/utils/firebase.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

// Project imports:

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }

    return user;
  }

  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  User? get myUser {
    return _firebaseAuth.currentUser;
  }

  bool? isEmailVerified() {
    return _firebaseAuth.currentUser?.emailVerified;
  }

  Future<User?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    final cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(cred.user);
  }

  Future<User?> createUserWithEmailPassword(
      String email, String password, String firstName, String lastName) async {
    final cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (cred.user?.uid != null) {
      String userUid = cred.user?.uid ?? "";
      String userEmail = cred.user?.email ?? "";
      await FirebaseService(userUid)
          .updateUserData(userEmail, firstName, lastName);
      return _userFromFirebase(cred.user);
    }

    return null;
  }

  Future resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<User?> signInWithApple({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken!),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode!),
        );
        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = userCredential.user!;
        if (scopes.contains(Scope.fullName)) {
          final fullName = appleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
            if (userCredential.user?.uid != null) {
              String userUid = userCredential.user?.uid ?? "";
              String userEmail = userCredential.user?.email ?? "";
              await FirebaseService(userUid).updateUserData(userEmail,
                  fullName.givenName ?? "", fullName.familyName ?? "");
              return _userFromFirebase(userCredential.user);
            }
          }
        }
        return _userFromFirebase(firebaseUser);
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }
}
