import 'package:flutter/material.dart';
import 'package:nowtowv1/bloc/auth/auth_bloc.dart';
import 'package:nowtowv1/bloc/auth/auth_events.dart';
import 'package:provider/provider.dart';

class SignOutButton extends StatelessWidget {
  const SignOutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 40,
          width: 372,
          decoration: BoxDecoration(
              color: Colors.redAccent, borderRadius: BorderRadius.circular(7)),
          child: TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
