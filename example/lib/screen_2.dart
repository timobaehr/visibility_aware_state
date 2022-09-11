import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_aware_state/visibility_aware_state.dart';

class Screen2 extends StatefulWidget {
  const Screen2({Key? key}) : super(key: key);

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends VisibilityAwareState<Screen2> {

  _Screen2State(): super(debugPrintsEnabled: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 2'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _headline('You are on page 2 now.'),
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
  }
}
