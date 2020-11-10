import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoomCodeInput extends StatefulWidget {
  final void Function(String code) update;

  RoomCodeInput({@required this.update});

  @override
  State<StatefulWidget> createState() {
    return _RoomCodeInputState(update);
  }
}

class _RoomCodeInputState extends State<RoomCodeInput> {
  final void Function(String code) update;
  TextEditingController _textController = TextEditingController();

  _RoomCodeInputState(this.update);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: TextField(
        controller: _textController,
        onChanged: (String value) {
          value = value.toUpperCase();
          String code = '';
          for (var c in value.characters) {
            if ('234679ACDEFGHJKLMNPRTUVWXYZ'.contains(c)) {
              code += c;
            }
          }
          code = code.substring(0, code.length > 8 ? 8 : code.length);
          _textController.value = TextEditingValue(
              text: code,
              selection: TextSelection.fromPosition(
                  TextPosition(offset: code.length)));
          _textController.selection =
              TextSelection.fromPosition(TextPosition(offset: code.length));
          update(code.length >= 3 ? code : null);
        },
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key),
            contentPadding: EdgeInsets.all(0),
            isDense: true,
            labelText: 'Room Code',
            hintText: 'ABC1',
            hintStyle: TextStyle(color: Colors.black26),
            border: OutlineInputBorder()),
        autocorrect: false,
        keyboardType: TextInputType.visiblePassword,
        enableSuggestions: false,
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
