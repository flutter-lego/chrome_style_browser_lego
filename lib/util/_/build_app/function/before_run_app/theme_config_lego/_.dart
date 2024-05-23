import 'package:flutter/material.dart';

import '../../../../../../main.dart';
import '../../../../../config/theme_config_lego/_.dart';
import '../../../../shared_params/_/material_app.dart';

@ReadyBeforeRunApp()
Future<void> readyForThemeConfigLego() async {
  MaterialAppParams.themeMode = ThemeConfig.startThemeMode;
  MaterialAppParams.lightTheme = ThemeConfig.lightTheme;
  MaterialAppParams.darkTheme = ThemeConfig.darkTheme;
}
