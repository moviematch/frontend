import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'MenuButton.dart';

class WelcomeCard extends StatelessWidget {
  final void Function() createRoom;
  final void Function() joinRoom;

  WelcomeCard({@required this.createRoom, @required this.joinRoom});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Welcome to Movie Match!',
          textScaleFactor: 1.5,
        ),
        const Text(
            'To get started, create a new room or join an existing room if you have a code.'),
        MenuButton('Create new room', press: createRoom),
        MenuButton('Join existing room', press: joinRoom)
      ],
    );
  }
}
