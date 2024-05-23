import 'package:flutter/material.dart';
import '../../../../../main.dart';
import 'theme_config_lego/_.dart';

Future<void> readyBeforeRunApp() async {
  if (_done) return;
  _done = true;
  await Future.wait([
    readyForThemeConfigLego(),
  ]);

}

bool _done = false;
