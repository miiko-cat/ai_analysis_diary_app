import 'package:flutter/cupertino.dart';

class KeyboardDismiss extends StatelessWidget {
  final Widget child;

  const KeyboardDismiss({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
