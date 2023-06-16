import 'package:flutter/material.dart';
import 'package:mahikav/components/buttons/filled_buttons.dart';

import 'login_signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool? isMember;
  bool? isPolice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Are you a',
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Opacity(
                        opacity: (isPolice == null || isPolice!) ? 1 : 0.5,
                        child: GestureDetector(
                          onTap: () {
                            isPolice = !(isPolice ?? false);
                            if (!isPolice!) {
                              isMember = isPolice = null;
                            } else {
                              isMember = false;
                            }
                            setState(() {});
                          },
                          child: Stack(
                            // alignment: Alignment.center,
                            children: [
                              const Column(
                                children: [
                                  CircleAvatar(
                                    radius: 65,
                                    foregroundImage:
                                        AssetImage('images/police.png'),
                                  ),
                                  Text(
                                    'Police',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                              if (isPolice != null && isPolice!)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 48,
                                ),
                            ],
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: (isMember == null || isMember!) ? 1 : 0.5,
                        child: GestureDetector(
                          onTap: () {
                            isMember = !(isMember ?? false);
                            if (!isMember!) {
                              isMember = isPolice = null;
                            } else {
                              isPolice = false;
                            }
                            setState(() {});
                          },
                          child: Stack(
                            children: [
                              const Column(
                                children: [
                                  CircleAvatar(
                                    radius: 65,
                                    foregroundImage:
                                        AssetImage('images/student.png'),
                                  ),
                                  Text(
                                    'Member',
                                    style: TextStyle(fontSize: 20),
                                  )
                                ],
                              ),
                              if (isMember != null && isMember!)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 48,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
              if ((isPolice != null && isPolice!) ||
                  (isMember != null && isMember!))
                CustomFilledButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => LoginSignUp()));
                  },
                  label: 'Continue',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
