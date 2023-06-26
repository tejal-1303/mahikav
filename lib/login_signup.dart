import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mahikav/components/text_form_field.dart';
import 'package:mahikav/home_page.dart';

import 'PoliceSignUp.dart';
import 'StudentSignUp.dart';
import 'components/buttons/filled_buttons.dart';
import 'constants.dart';

class LoginSignUp extends StatefulWidget {
  const LoginSignUp({Key? key, required this.isPolice}) : super(key: key);
  final bool isPolice;

  @override
  State<LoginSignUp> createState() => _LoginSignUpState();
}

class _LoginSignUpState extends State<LoginSignUp> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  String? errorText;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextFormField(
                      label: 'Email ID',
                      controller: emailCtrl,
                      hint: 'abc@example.com',
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Field is Required';
                        }
                        if (errorText != 'Wrong Password') {
                          return errorText;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      label: 'Password',
                      controller: passCtrl,
                      isPassword: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Field is Required';
                        }
                        if (errorText == 'Wrong Password') {
                          return errorText;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomFilledButton(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: emailCtrl.text,
                                  password: passCtrl.text);
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case 'invalid-email':
                              {
                                errorText = 'Invalid Email';
                                setState(() {});
                                break;
                              }
                            case 'user-not-found':
                              {
                                errorText = 'User not created';
                                setState(() {});
                                break;
                              }
                            case 'wrong-password':
                              {
                                errorText = 'Wrong Password';
                                setState(() {});
                                break;
                              }
                            default:
                              {
                                errorText = 'Something Went Wrong';
                                setState(() {});
                                break;
                              }
                          }
                          _formKey.currentState!.validate();
                          errorText = null;
                          setState(() {});
                          return;
                        }
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                          (_) => false,
                        );
                      },
                      label: 'Login',
                    ),
                    SizedBox(height: 20),
                    CupertinoButton(
                      child: Text(
                        'Login with phone number',
                        style: TextStyle(
                          color: kColorDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {},
                    ),SizedBox(height: 20),
                    CupertinoButton(
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: kColorDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () {},
                    ),
                    Text(
                      'or',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 20),
                    CustomOutlineButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => (widget.isPolice)
                                ? PoliceSignUp()
                                : StudentSignUp(),
                          ),
                        );
                      },
                      label: 'Create an Account',
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
