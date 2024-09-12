import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mahikav/components/buttons/filled_buttons.dart';
import 'package:mahikav/components/emergency_buttons.dart';
import 'package:mahikav/first_page.dart';
import 'package:mahikav/notifications.dart';

import 'add_college_admin_function.dart';
import 'components/custom_icon_icons.dart';
import 'components/group_tiles.dart';
import 'constants.dart';

// import '../../../components/custom_text.dart';
// import '../../../constants.dart';

class CommunitiesTopicList extends StatefulWidget {
  const CommunitiesTopicList({Key? key, required this.community})
      : super(key: key);
  final DocumentSnapshot community;

  @override
  State<CommunitiesTopicList> createState() => _CommunitiesTopicListState();
}

class _CommunitiesTopicListState extends State<CommunitiesTopicList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .snapshots(),
        builder: (context, user) {
          return Scaffold(
            floatingActionButton:
                user.hasData && user.data!['category'] == 'Member'
                    ? const EmergencyButtons()
                    : null,
            appBar: AppBar(
              title: Text('${user.data!['city']}, ${user.data!['state']}'),
              actions: [
                if (user.hasData && user.data!['category'] != 'Member')
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const Notifications()));
                    },
                    icon: const Icon(Icons.notifications),
                  ),
                IconButton(
                    onPressed: () {
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation) {
                          return AlertDialog(
                            title: Text('Nearby locations'),
                            content: Text('This feature is underway. Wait for the update!'),
                            actions: [
                              CustomFilledButton(
                                onPressed: () {
                                  Navigator.maybePop(context);
                                },
                                label: 'Okay',
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.location_on_rounded)),
                IconButton(
                  onPressed: () async {
                    await auth.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const FirstPage()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout_rounded),
                )
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: widget.community.reference
                  .collection('groups')
                  .orderBy('updatedAt', descending: true)
                  .snapshots(),
              builder: (context, groups) {
                if (groups.hasData && user.hasData) {
                  final userData = user.data;
                  final groupList = groups.data!.docs;
                  List<Widget> list = [];
                  for (QueryDocumentSnapshot z in groupList) {
                    if (userData!['category'] == 'Member' &&
                        !z['isGeneral'] &&
                        userData['collegeAddress'] != z['collegeName']) {
                      continue;
                    }
                    list.add(
                      GroupTile(userData: userData, community: z),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (userData!['category'] == 'Admin')
                        ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          leading: const Icon(
                            Icons.add_location_alt_rounded,
                            size: 40,
                            color: kColorDark,
                          ),
                          title: Text(
                            'Add New College',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddCollege_Admin(
                                  community: widget.community,
                                ),
                              ),
                            );
                          },
                        ),
                      if (userData['category'] == 'Admin')
                        const Divider(
                          indent: 20,
                          endIndent: 20,
                          height: 0,
                        ),
                      Column(
                        children: list,
                      ),
                    ],
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: kColorDark,
                  ),
                );
              },
            ),
          );
        });
  }
}
