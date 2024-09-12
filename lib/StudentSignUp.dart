import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mahikav/components/text_form_field.dart';

import 'components/buttons/dropdown_text_field.dart';
import 'components/buttons/filled_buttons.dart';
import 'constants.dart';
import 'home_page.dart';
import 'otp_page.dart';

class StudentSignUp extends StatefulWidget {
  const StudentSignUp({Key? key}) : super(key: key);

  @override
  State<StudentSignUp> createState() => _StudentSignUp();
}

class _StudentSignUp extends State<StudentSignUp>
    with SingleTickerProviderStateMixin {
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final idProofCtrl = TextEditingController();
  final cellID = TextEditingController();
  final collegeAddrCtrl = TextEditingController();
  final confPassCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? errorText;

  String? postError;
  bool isLoading = false;

  late final tabCtrl = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: Column(
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     FloatingActionButton(
      //       backgroundColor: Colors.red.shade900,
      //       child: Icon(
      //         CustomIcon.mic,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {},
      //     ),
      //     SizedBox(
      //       height: 10,
      //     ),
      //     FloatingActionButton(
      //       backgroundColor: Colors.green,
      //       child: Icon(
      //         Icons.call,
      //         color: Colors.white,
      //       ),
      //       onPressed: () async {
      //         await FlutterPhoneDirectCaller.callNumber('+917021051913');
      //       },
      //     ),
      //   ],
      // ),
      appBar: AppBar(
        bottom: TabBar(
          controller: tabCtrl,
          tabs: const [
            Tab(
              text: 'Using Email',
            ),
            Tab(
              text: 'Using Phone',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabCtrl,
        children: List.generate(
          tabCtrl.length,
          (index) => SafeArea(
            child: ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (index == 0)
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
                        if (index == 0)
                          const SizedBox(
                            height: 10,
                          ),
                        CustomTextFormField(
                          label: 'Phone No.',
                          controller: phoneCtrl,
                          hint: '00000 00000',
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Field is Required';
                            }
                            return errorText;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          label: 'Member ID',
                          controller: cellID,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Field is Required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        StreamBuilder<QuerySnapshot>(
                            stream: firestore
                                .collection('colleges')
                                .orderBy('collegeAddress')
                                .snapshots(),
                            builder: (context, snapshot) {
                              return CustomDropDownField(
                                label: 'College Address',
                                controller: collegeAddrCtrl,
                                listItems: snapshot.hasData
                                    ? List.generate(
                                        snapshot.data!.size,
                                        (i) => snapshot.data!.docs[i]
                                            ['collegeAddress'],
                                      )
                                    : [],
                                errorText: postError,
                              );
                            }),
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
                        const SizedBox(height: 10),
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
                        if (index == 0) const SizedBox(height: 10),
                        if (index == 0)
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
                        if (index == 0) const SizedBox(height: 10),
                        if (index == 0)
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
                        // SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: CustomFilledButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if (collegeAddrCtrl.text.isEmpty) {
                postError = 'Add Post';
                setState(() {});
                return;
              }
              Map<String, dynamic> data = {
                'name': nameCtrl.text,
                'email': emailCtrl.text,
                'phoneNo': phoneCtrl.text,
                'category': 'Member',
                'IDProof': idProofCtrl.text,
                'city': 'Gwalior',
                'state': 'Madhya Pradesh',
                'studentID': cellID.text,
                'collegeAddress': collegeAddrCtrl.text,
                'isVerifiedUser': null,
              };
              postError = null;
              setState(() {});
              if (tabCtrl.index == 0) {
                try {
                  isLoading = true;

                  setState(() {});
                  await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: emailCtrl.text,
                    password: passCtrl.text,
                  )
                      .then((value) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(auth.currentUser!.uid)
                        .set(data)
                        .then((value) {
                      isLoading = false;
                      setState(() {});
                    });
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                      (route) => false,
                    );
                    // TODO: Add Navigator to HomePage
                  });
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
              } else {
                await auth.verifyPhoneNumber(
                  phoneNumber: '+91${phoneCtrl.text}',
                  verificationCompleted: (PhoneAuthCredential credential) {},
                  verificationFailed: (FirebaseAuthException e) {},
                  codeSent: (String verificationId, int? resendToken) {
                    setState(() {});
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OTPPage(
                          verificationId: verificationId,
                          data: data,
                        ),
                      ),
                    );
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );
              }
            }
          },
          label: 'Sign Up',
        ),
      ),
    );
  }
}
