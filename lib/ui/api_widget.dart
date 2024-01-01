import 'package:flutter/material.dart';

import '../io/api.dart';

class ApiWidget extends InheritedWidget {
  final Api api;
  const ApiWidget({super.key, required super.child, required this.api});

  static ApiWidget? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ApiWidget>();
  }

  static ApiWidget of(BuildContext context) {
    final ApiWidget? result = maybeOf(context);
    assert(result != null, 'No Internet state found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ApiWidget oldWidget) {
    return true;
  }
}