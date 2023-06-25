import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_college_admin_function.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gwalior, Madhya Pradesh'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.community.reference
            .collection('groups')
            .orderBy('updatedAt', descending: true)
            .snapshots(),
        builder: (context, groups) {
          return StreamBuilder<DocumentSnapshot>(
            stream: firestore
                .collection('users')
                .doc(auth.currentUser!.uid)
                .snapshots(),
            builder: (context, user) {
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
          );
        },
      ),
    );
  }
}
