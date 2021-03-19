import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:visibility_aware_state/extensions.dart';

abstract class VisibilityAwareState<T extends StatefulWidget> extends State<T>
// ignore: prefer_mixin
    with
        WidgetsBindingObserver,
        _StackChangedListener {
  VisibilityAwareState({this.debugPrintsEnabled = false});

  static final Set<String> _widgetStack = {};
  static final Map<String, int> _widgetStackTimestamps = {};

  static final Set<_StackChangedListener> _listeners = {};

  bool debugPrintsEnabled;

  bool _isWidgetRemoved = false;

  WidgetVisibility? _widgetVisibility;

  /// Adds [widgetName] to the set.
  ///
  /// Returns `true` if [widgetName] was not yet in the set.
  /// Otherwise returns `false` and the set is not changed.
  static bool _addToStack(String widgetName) {
    final bool result = _widgetStack.add(widgetName);
    if (result) {
      _widgetStackTimestamps[widgetName] =
          DateTime.now().millisecondsSinceEpoch;
      for (final listener in _listeners) {
        listener._onAddToStack(widgetName);
      }
      //debugPrint('_addToStack($widgetName) returns true, $_widgetStack');
    }
    return result;
  }

  /// Removes [widgetName] from the set.
  ///
  /// Returns `true` if [widgetName] was in the set, and `false` if not.
  /// The method has no effect if [widgetName] was not in the set.
  static bool _removeFromStack(String widgetName) {
    final bool result = _widgetStack.remove(widgetName);
    if (result) {
      _widgetStackTimestamps.remove(widgetName);
      //debugPrint('_removeFromStack($widgetName) returns true, $_widgetStack');
      for (final listener in _listeners) {
        listener._onRemoveFromStack();
      }
    }
    return result;
  }

  @override
  void _onAddToStack(String widgetName) {
    if (_widgetVisibility != WidgetVisibility.INVISIBLE &&
        runtimeType.toString() != widgetName &&
        !_wasAddedTogetherWith(widgetName)) {
      _onVisibilityChanged(WidgetVisibility.INVISIBLE);
    }
  }

  @override
  void _onRemoveFromStack() {
    if (_widgetStack.isNotEmpty &&
        (runtimeType.toString() == _widgetStack.last ||
            _wasAddedTogetherWith(_widgetStack.last))) {
      _onVisibilityChanged(WidgetVisibility.VISIBLE);
    }
  }

  @override
  void initState() {
    super.initState();
    //debugPrint('$runtimeType.initState()');
    WidgetsBinding.instance!.addPostFrameCallback(_onWidgetLoaded);
    WidgetsBinding.instance!.addObserver(this);
  }

  void _onWidgetLoaded(_) {
    //debugPrint('$runtimeType.onWidgetLoaded()');
    _listeners.add(this);
    WidgetsBinding.instance!.addPersistentFrameCallback((timeStamp) {
      //print(runtimeType);
      if (!_isWidgetRemoved && _addToStack(runtimeType.toString())) {
        //debugPrint('Adding $runtimeType to stack. widgetStack = $_widgetStack');
        _onVisibilityChanged(WidgetVisibility.VISIBLE);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    //debugPrint('$runtimeType.dispose()');
    _isWidgetRemoved = true;
    _listeners.remove(this);
    _removeFromStack(runtimeType.toString());
    //print('Removing $runtimeType from stack. widgetStack = $_widgetStack');
    _onVisibilityChanged(WidgetVisibility.GONE);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // move app to background: inactive -> paused
    // open app from background: resumed
    if (debugPrintsEnabled) {
      debugPrint('$runtimeType.didChangeAppLifecycleState($state)');
    }
    if (state == AppLifecycleState.inactive) {
      // app is inactive (called on iOS if app overview is shown)
      _onVisibilityChanged(WidgetVisibility.INVISIBLE);
    } else if (state == AppLifecycleState.paused) {
      // user is about quit our app temporally
      // (called on iOS if the app is in background and overview was closed)
      _onVisibilityChanged(WidgetVisibility.INVISIBLE);
    } else if (state == AppLifecycleState.resumed) {
      // user returned to our app
      if (runtimeType.toString() == _widgetStack.last ||
          _wasAddedTogetherWith(_widgetStack.last)) {
        _onVisibilityChanged(WidgetVisibility.VISIBLE);
      }
    } else if (state == AppLifecycleState.detached) {
      // still hosted on a flutter engine but is detached from any host views
    }
  }

  bool _wasAddedTogetherWith(String otherWidgetsName) {
    final int? timeOtherWasAdded = _widgetStackTimestamps[otherWidgetsName];
    final int? timeAdded = _widgetStackTimestamps[runtimeType.toString()];
    if (timeOtherWasAdded == null || timeAdded == null) {
      return false;
    }

    final int diff = (timeAdded > timeOtherWasAdded)
        ? timeAdded - timeOtherWasAdded
        : timeOtherWasAdded - timeAdded;

    if (diff < 50) {
      if (debugPrintsEnabled) {
        debugPrint(
            'diff of $otherWidgetsName and ${runtimeType.toString()}: $diff');
      }
      return true;
    }
    return false;
  }

  void _onVisibilityChanged(WidgetVisibility visibility) {
    if (_widgetVisibility != visibility) {
      _widgetVisibility = visibility;
      onVisibilityChanged(visibility);

      if (debugPrintsEnabled) {
        debugPrint(
            '$runtimeType.onVisibilityChanged(${enumToString(visibility)}) - $_widgetStack');
      }
    }
  }

  void onVisibilityChanged(WidgetVisibility visibility) {}

  bool isVisible() {
    return _widgetVisibility == WidgetVisibility.VISIBLE;
  }

  void finish() {
    // close the whole screen
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      SystemNavigator.pop();
    }
  }
}

enum WidgetVisibility { VISIBLE, INVISIBLE, GONE }

mixin _StackChangedListener {
  void _onAddToStack(String widgetName);

  void _onRemoveFromStack();
}
