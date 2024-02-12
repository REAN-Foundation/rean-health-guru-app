import 'package:flutter/material.dart';
import 'package:patient/infra/themes/app_colors.dart';
import 'package:patient/infra/utils/common_utils.dart';

class CustomTooltip extends StatelessWidget {
  final Widget? child;
  final String? message;

  CustomTooltip({@required this.message, @required this.child});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      message: message ?? '',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(20),
      showDuration: Duration(seconds: 10),
      decoration: BoxDecoration(
        color: colorEDEDED.withOpacity(1),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
      preferBelow: true,
      verticalOffset: 0,
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
    announceText(message ?? '');
    Future.delayed(
        Duration(seconds: 10),
            () {
          tooltip?.deactivate();
        }
    );
  }
}