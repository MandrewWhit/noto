// Dart imports:

// Flutter imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Project imports:

// Package imports:

/// Refactor Notes:
///
/// - Include more detailed logs

@immutable
abstract class AuthEvent {
  const AuthEvent();

  List<Object> get props => [];
}

class CreateAccountEvent extends AuthEvent {
  CreateAccountEvent(
      {required this.email,
      required this.password,
      required this.firstname,
      required this.lastname,
      required this.context});

  final String email;
  final String password;
  final String firstname;
  final String lastname;
  BuildContext context;

  @override
  List<Object> get props => [email, password, firstname, lastname, context];

  @override
  String toString() => 'Create Account Event';
}

class ResetPasswordEvent extends AuthEvent {
  const ResetPasswordEvent({required this.email});

  final String email;

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'Reset Password Event';
}

class LoginEvent extends AuthEvent {
  LoginEvent(
      {required this.email,
      required this.password,
      required this.context,
      required this.apple});

  String email;
  String password;
  BuildContext context;
  bool apple;

  @override
  List<Object> get props => [email, password, context, apple];

  @override
  String toString() => 'Login Event';
}

class LogoutEvent extends AuthEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Logout Event';
}

class AlreadyLoggedInEvent extends AuthEvent {
  const AlreadyLoggedInEvent({required this.user});

  final User user;

  @override
  List<Object> get props => [user];

  @override
  String toString() => 'Already Logged In Event';
}

class GetNameEvent extends AuthEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'Get Name Event';
}

class UpdateProfilePicEvent extends AuthEvent {
  const UpdateProfilePicEvent({required this.profilePic});

  final String profilePic;

  @override
  List<Object> get props => [profilePic];

  @override
  String toString() => 'Update Profile Pic Event';
}

class VerifyEmailEvent extends AuthEvent {
  const VerifyEmailEvent({required this.isVerified});

  final bool isVerified;

  @override
  List<Object> get props => [isVerified];

  @override
  String toString() => 'Verify Email Event';
}

class UpVoteMarkerEvent extends AuthEvent {
  const UpVoteMarkerEvent({required this.id});

  final String id;

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'Up Vote Marker Event';
}

class DownVoteMarkerEvent extends AuthEvent {
  const DownVoteMarkerEvent({required this.id});

  final String id;

  @override
  List<Object> get props => [id];

  @override
  String toString() => 'Down Vote Marker Event';
}
