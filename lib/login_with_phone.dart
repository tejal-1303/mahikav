import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:mahikav/components/buttons/filled_buttons.dart';
import 'package:mahikav/constants.dart';
import 'package:mahikav/otp_page.dart';

import 'components/custom_icon_icons.dart';
import 'components/text_form_field.dart';
import 'emergency_buttons.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({Key? key}) : super(key: key);

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  final phoneCtrl = TextEditingController();
  final otpCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool resendOTP = false;
  String? code;
  QuerySnapshot? data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: EmergencyButtons(),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                label: 'Phone No.',
                controller: phoneCtrl,
                hint: '00000 00000',
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Field is Required';
                  }
                  print(phoneCtrl.text);
                  if (data!.size == 0) {
                    return 'Account doesn\'t exists!';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              CustomFilledButton(
                  onPressed: () async {
                    isLoading = true;
                    setState(() {});
                    data = await firestore
                        .collection('users')
                        .where('phoneNo', isEqualTo: phoneCtrl.text)
                        .get();
                    setState(() {});
                    if (_formKey.currentState!.validate()) {
                      await auth.verifyPhoneNumber(
                        phoneNumber: '+91${phoneCtrl.text}',
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          code = verificationId;
                          isLoading = false;
                          setState(() {});
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  OTPPage(verificationId: verificationId),
                            ),
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    }
                  },
                  label: 'Send OTP')
            ],
          ),
        ),
      ),
    );
  }
}
