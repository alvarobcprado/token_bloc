import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:token_state_manager/src/state_manager/token_state_manager.dart';

class DynamicStateBuilder extends StatelessWidget {
  DynamicStateBuilder({
    required this.tokenStateManager,
    required this.builder,
    super.key,
  });

  final TokenStateManager tokenStateManager;
  final Widget Function(BuildContext context, dynamic data) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Rx.merge(tokenStateManager.subjects.whereType<TokenState>()),
      builder: (context, snapshot) {
        final data = snapshot.data;
        return builder(context, data);
      },
    );
  }
}
