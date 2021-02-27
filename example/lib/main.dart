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
        title: Text('Example app'),
      ),
      body: Center(
        child: Text('Welcome to visibility_aware_state example app.'),
      ),
    );
  }

  @override
  void onVisibilityChanged(WidgetVisibility visibility) {
    // TODO: Use visibility
    super.onVisibilityChanged(visibility);
  }
}