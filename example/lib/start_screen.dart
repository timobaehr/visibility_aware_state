import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:visibility_aware_state/visibility_aware_state.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends VisibilityAwareState<StartScreen> {

  _StartScreenState(): super(debugPrintsEnabled: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welcome to visibility_aware_state example app.',
                  style: Theme.of(context).textTheme.headline5),
              _headline('Features'),
              _item('Detect when a widget becomes invisible or visible'),
              _item('Check if the widget is currently visible using `bool isVisible()`'),
              _item('Close the current screen via `finish()` (Android style)'),
              TextButton(onPressed: () => GoRouter.of(context).push('/page2'), child: Text('Go to page 2'))
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
  }
}
