// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowtowv1/bloc/auth/auth_bloc.dart';
import 'package:nowtowv1/bloc/auth/auth_events.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

// Project imports:

class CreateAccount extends StatelessWidget {
  CreateAccount({
    Key? key,
    required this.data,
  }) : super(key: key);

  final String data;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final emailController = TextEditingController();
    final confirmController = TextEditingController();
    final firstController = TextEditingController();
    final lastController = TextEditingController();

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 40),
              child: RichText(
                text: TextSpan(
                  text: data,
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 25.0, bottom: 0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          labelText: 'Email',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 211, 220, 230)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 25.0, bottom: 0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          labelText: 'Password',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 211, 220, 230)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 5.0, bottom: 0),
                    child: RichText(
                      text: const TextSpan(
                        text:
                            'Password must be more than 8 characters, include at least one number, and symbol',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 25.0, bottom: 25.0),
                    child: TextFormField(
                      controller: confirmController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          labelText: 'Confirm Password',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 211, 220, 230)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please re-enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 25.0, bottom: 25.0),
                    child: TextFormField(
                      controller: firstController,
                      decoration: InputDecoration(
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          labelText: 'First Name',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 211, 220, 230)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 25.0, bottom: 25.0),
                    child: TextFormField(
                      controller: lastController,
                      decoration: InputDecoration(
                          labelStyle:
                              TextStyle(color: Theme.of(context).primaryColor),
                          labelText: 'Last Name',
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 211, 220, 230)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a last name';
                        }
                        return null;
                      },
                    ),
                  ),
                  //privacyPolicyLinkAndTermsOfService(),
                  Container(
                    height: 40,
                    width: 372,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(7)),
                    child: TextButton(
                      onPressed: () {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                            .hasMatch(emailController.text);
                        var numbers = [
                          '0',
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9'
                        ];
                        bool hasNumber = false;
                        for (var i = 0; i < numbers.length; i++) {
                          if (passwordController.text.contains(numbers[i])) {
                            hasNumber = true;
                          }
                        }
                        bool hasSymbol = false;
                        final symbols = [
                          '!',
                          '@',
                          '#',
                          '%',
                          '^',
                          '&',
                          '*',
                          '+'
                        ];
                        for (var i = 0; i < symbols.length; i++) {
                          if (passwordController.text.contains(symbols[i])) {
                            hasSymbol = true;
                          }
                        }
                        bool requiredLength = false;
                        if (passwordController.text.length > 7) {
                          requiredLength = true;
                        }
                        bool passwordsMatch = false;
                        if (passwordController.text == confirmController.text) {
                          passwordsMatch = true;
                        }
                        if (requiredLength &&
                            hasNumber &&
                            hasSymbol &&
                            passwordsMatch &&
                            emailValid) {
                          context.read<AuthBloc>().add(CreateAccountEvent(
                              email: emailController.text,
                              password: passwordController.text,
                              firstname: firstController.text,
                              lastname: lastController.text,
                              context: context));
                          //Navigator.pop(context);
                        } else {
                          String errorMessage = "";
                          if (!requiredLength) {
                            errorMessage =
                                "Password must be eight characters or more";
                          }
                          if (!hasNumber) {
                            errorMessage = "Password must contain a number";
                          }
                          if (!hasSymbol) {
                            errorMessage =
                                "Password must contain a symbol (!,@,#,%,^,&,*,+)";
                          }
                          if (!passwordsMatch) {
                            errorMessage = "Passwords don't match";
                          }
                          if (!emailValid) {
                            errorMessage = "Please provide a valid email";
                          }
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.error,
                            title: 'Ugh Oh!',
                            text: errorMessage,
                            confirmBtnColor: Theme.of(context).primaryColor,
                            confirmBtnText: 'Ok',
                          );
                        }
                      },
                      child: const Text(
                        'Sign Up!',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
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
}
