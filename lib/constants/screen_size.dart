import 'package:flutter/widgets.dart';

extension ScreenSize on BuildContext {
  Size get mediaQuerySize => MediaQuery.of(this).size;

  double get fullHeight => mediaQuerySize.height;
  double get fullWidth => mediaQuerySize.width;
}
