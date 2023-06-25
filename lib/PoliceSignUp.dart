import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mahikav/components/buttons/dropdown_text_field.dart';
import 'package:mahikav/components/text_form_field.dart';
import 'package:mahikav/home_page.dart';

import 'components/buttons/filled_buttons.dart';
import 'constants.dart';

class StudentSignUp extends StatefulWidget {
  const StudentSignUp({Key? key}) : super(key: key);

  @override
  State<StudentSignUp> createState() => _StudentSignUp();
}

class _StudentSignUp extends State<StudentSignUp> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final policeIdCtrl = TextEditingController();
  final policePostCtrl = TextEditingController();
  final idProofCtrl = TextEditingController();
  final confPassCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorText, postError;

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
                        return errorText;
                      },
                    ),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      label: 'Police ID',
                      controller: policeIdCtrl,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Field is Required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    CustomDropDownField(
                      label: 'Post',
                      controller: policePostCtrl,
                      listItems: [
                        'Constable',
                        'Head Constable',
                        'Assistant Sub-Inspector',
                        'Sub-Inspector',
                        'Inspector',
                        'Deputy Superintendant of Police',
                        'Additional Superintendent of Police',
                        'Superintendent of Police',
                        'Senior Superintendent of Police',
                        'Deputy Inspector General of Police',
                        'Inspector-General of Police',
                        'Director-General of Police',
                      ], errorText: postError,
                    ),
                    CustomTextFormField(
                      label: 'Name',
                      controller: nameCtrl,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Field is Required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      label: 'Aadhar Card No.',
                      controller: idProofCtrl,
                      hint: 'Eg.Aadhar Card, Pan Card etc... ',
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Field is Required';
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
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    CustomTextFormField(
                      label: 'Confirm Password',
                      controller: confPassCtrl,
                      isPassword: true,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Field is Required';
                        } else if (val != passCtrl.text) {
                          return 'Password Doesn\'t Match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    CustomFilledButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (policePostCtrl.text.isEmpty) {
                            postError = 'Add Post';
                            setState(() {

                            });
                            return;
                          }
                          postError = null;
                          setState(() {

                          });
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
                            'category': 'Police',
                            'IDProof': idProofCtrl.text,
                            'city': 'Gwalior',
                            'state': 'Madhya Pradesh',
                            'policeID': policeIdCtrl.text,
                            'post': policePostCtrl.text,
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
