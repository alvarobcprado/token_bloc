import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:token_bloc/src/state_manager/token_bloc.dart';

/// {@template dynamic_state_builder}
/// Widget that builds based on the state of all [TokenState]s of a [TokenBloc].
///
/// The [builder] is called every time of any [TokenState] from [tokenStateManager] changes.
/// The data param is the last emitted state.
/// {@endtemplate}
class DynamicStateBuilder extends StatelessWidget {
  /// {@macro dynamic_state_builder}
  const DynamicStateBuilder({
    required this.tokenStateManager,
    required this.builder,
    super.key,
  });

  /// The [TokenBloc] to build the widget based its [TokenState]s.
  final TokenBloc tokenStateManager;

  /// The widget builder for the [TokenState].
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
