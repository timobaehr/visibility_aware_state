# visibility_aware_state

A state for StatefulWidgets that is aware of its visibility.

That can be useful for screen view tracking or e.g. if your app shows files it can be used to
automatically refresh the files when the app is reopened again.

In Android, Activity classes had the onResume() method. In Flutter widgets this is missing. This
library offers `void onVisibilityChanged(WidgetVisibility visibility)` to do something similar.

## Features

Notice when:
* the app is put in the background or brought out of the background
* the widget initially becomes visible
* the widget becomes invisible (a new page is pushed)
* the widget is removed from stack
* the widget becomes visible again (e.g. back button on Android is pressed)

Close the current screen via `finish()` like in Android.

Check if the widget is currently visible using `bool isVisible()`.

## Getting started

In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  visibility_aware_state: <latest_version>
```

In your library add the following import:

```dart
import 'package:visibility_aware_state/visibility_aware_state.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.io/).

## Example

```dart
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
```

Here is a specific example where the visibility is used for screen view tracking:

```dart
import 'package:flutter/widgets.dart';
import 'package:visibility_aware_state/visibility_aware_state.dart';

import 'tracker.dart';

abstract class ScreenState<T extends StatefulWidget>
    extends VisibilityAwareState<T> with Screen {

  @override
  void onVisibilityChanged(WidgetVisibility visibility) {
    if (visibility == WidgetVisibility.VISIBLE) {
      Tracker().trackScreen(this);
    }
    super.onVisibilityChanged(visibility);
  }

  @override
  String screenName() {
    return runtimeType.toString();
  }

}

mixin Screen {

  String screenName();

}
```

## Contributions

Feel free to contribute to this project.

If you find a bug or want a feature, but don't know how to fix/implement it, please fill an [issue](https://github.com/timobaehr/visibility_aware_state/issues).
If you fixed a bug or implemented a new feature, please send a [pull request](https://github.com/timobaehr/visibility_aware_state/pulls).