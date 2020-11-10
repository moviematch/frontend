import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colours.dart';
import 'package:openapi/api.dart';
import 'dart:math';

class MemberCard extends StatelessWidget {
  static int _kSize = 48;
  static int _kMaxFlagsDisplayed = 5;

  final User member;

  MemberCard({@required this.member});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          decoration: BoxDecoration(
              color: HexColor.fromHex(member.colour),
              borderRadius: BorderRadius.circular(_kSize / 2)),
          clipBehavior: Clip.antiAlias,
          child: Image.network('https://robohash.org/' +
              member.name +
              '?size=$_kSize' +
              'x$_kSize')),
      SizedBox(width: 8),
      SizedBox(
          height: _kSize + 0.0,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(member.name + (member.me ? ' (you)' : ''),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: member.me ? Colors.deepOrange : Colors.black)),
            Builder(
              builder: (context) {
                if (member.countries.length <= 0) {
                  return Text('(No countries selected)');
                } else {
                  List<Widget> flags = [];
                  for (int i = 0;
                      i < min(_kMaxFlagsDisplayed, member.countries.length);
                      ++i) {
                    flags.add(Padding(
                        padding: EdgeInsets.only(right: 6, top: 6),
                        child: CachedNetworkImage(
                            imageUrl: member.countries[i].flag, height: 20)));
                  }
                  if (member.countries.length > _kMaxFlagsDisplayed) {
                    int diff = member.countries.length - _kMaxFlagsDisplayed;
                    flags.add(Text('(+$diff more)'));
                  }
                  return Row(children: flags);
                }
              },
            )
          ])),
    ]);
  }
}
