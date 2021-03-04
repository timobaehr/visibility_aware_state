import 'package:flutter/material.dart';
import 'package:visibility_aware_state/visibility_aware_state.dart';

void main() =>
    runApp(MaterialApp(debugShowCheckedModeBanner: false, home: Example()));

class Example extends StatefulWidget {
  @override
  _ExampleState createState() => _ExampleState();
}

class _ExampleState extends VisibilityAwareState<Example> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text('Example app'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Welcome to visibility_aware_state example app.',
                style: Theme.of(context).textTheme.headline5),
              _headline('Features'),
              _item('Detect when a widget becomes invisible or visible'),
              _item('Check if the widget is currently visible using `bool isVisible()`'),
              _item('Close the current screen via `finish()` (Android style)'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headline(String headline) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(headline,
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _item(String item) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text('► $item'),
    );
  }

  @override
  void onVisibilityChanged(WidgetVisibility visibility) {
    switch(visibility) {
      case WidgetVisibility.VISIBLE:
        // Like Android's Activity.onResume()
        break;
      case WidgetVisibility.INVISIBLE:
        // Like Android's Activity.onPause()
        break;
      case WidgetVisibility.GONE:
        // Like Android's Activity.onDestroy()
        break;
    }
    super.onVisibilityChanged(visibility);
  }
}