import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';
import 'MemberCard.dart';

class MembersDisplay extends StatelessWidget {
  final Room room;

  MembersDisplay({@required this.room});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: room.users.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 12, left: 12, right: 12),
      itemBuilder: (context, index) => MemberCard(member: room.users[index]),
      separatorBuilder: (context, _) => Divider(color: Colors.black38),
    );
  }
}
