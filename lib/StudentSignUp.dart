import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:mahikav/components/text_form_field.dart';

import 'components/buttons/filled_buttons.dart';
import 'components/custom_icon_icons.dart';
import 'constants.dart';
import 'home_page.dart';

class StudentSignUp extends StatefulWidget {
  const StudentSignUp({Key? key}) : super(key: key);

  @override
  State<StudentSignUp> createState() => _StudentSignUp();
}

class _StudentSignUp extends State<StudentSignUp> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final idProofCtrl = TextEditingController();
  final cellID = TextEditingController();
  final collegeAddrCtrl = TextEditingController();
  final confPassCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
       Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.red.shade900,
            child: Icon(
              CustomIcon.mic,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            backgroundColor: Colors.green,
            child: Icon(
              Icons.call,
              color: Colors.white,
            ),
            onPressed: () async {
              await FlutterPhoneDirectCaller.callNumber(
                  '+917021051913');
            },
          ),
        ],
      ),
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
                        return errorText;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      label: 'Name',
                      controller: nameCtrl,
                      hint: 'Write your full name',
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Field is Required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      label: 'Student ID',
                      controller: cellID,
                      hint: 'Provided by the Institute',
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Field is Required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      label: 'College Address',
                      controller: collegeAddrCtrl,
                      hint: 'Provided by the Institute',
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Field is Required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      label: 'Aadhar Card No.',
                      controller: idProofCtrl,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Field is Required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      label: 'Password',
                      controller: passCtrl,
                      isPassword: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Field is Required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CustomTextFormField(
                      label: 'Confirm Password',
                      controller: confPassCtrl,
                      isPassword: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Field is Required';
                        } else if (passCtrl.text != val) {
                          return 'Password doesn\'t match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomFilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: emailCtrl.text,
                              password: passCtrl.text,
                            );
                          } on FirebaseAuthException catch (e) {
                            switch (e.code) {
                              case 'email-already-in-use':
                                {
                                  errorText = 'Email already in use';
                                  setState(() {});
                                  break;
                                }
                              case 'invalid-email':
                                {
                                  errorText = 'Invalid Email';
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
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(auth.currentUser!.uid)
                              .set({
                            'name': nameCtrl.text,
                            'email': emailCtrl.text,
                            'category': 'Member',
                            'IDProof': idProofCtrl.text,
                            'city': 'Gwalior',
                            'state': 'Madhya Pradesh',
                            'studentID': cellID.text,
                            'collegeAddress': collegeAddrCtrl.text,
                            'isVerifiedUser': null,
                          });
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => HomePage()),
                            (route) => false,
                          );
                          // TODO: Add Navigator to HomePage
                        }
                      },
                      label: 'Sign Up',
                    ),
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
