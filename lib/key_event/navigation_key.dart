import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class My_Key_Event extends StatefulWidget {
   My_Key_Event({Key? key}) : super(key: key);

  @override
  State<My_Key_Event> createState() => _My_Key_EventState();
}

class _My_Key_EventState extends State<My_Key_Event> {

  var count;
  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.arrowUp): () {
          setState(() => count = count + 1);
        },
        const SingleActivator(LogicalKeyboardKey.arrowDown): () {
          setState(() => count = count - 1);
        },
      },
      child: Focus(
        autofocus: true,
        child: Column(
          children: <Widget>[
            const Text('Press the up arrow key to add to the counter'),
            const Text('Press the down arrow key to subtract from the counter'),
            Text('count: $count'),
          ],
        ),
      ),
    );
  }
}
