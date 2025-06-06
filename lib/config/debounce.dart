import 'dart:async';

import 'package:flutter/material.dart';

class Debounce {
  Debounce({this.milliseconds = 300});

  final int milliseconds;
  Timer? _debounce;

  void call(VoidCallback callback) {
    _debounce?.cancel();
    _debounce = Timer(
      Duration(milliseconds: milliseconds),
      () {
        _debounce?.cancel();
        callback.call();
      },
    );
  }

  void close() {
    _debounce?.cancel();
  }
}
