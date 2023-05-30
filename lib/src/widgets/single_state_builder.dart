import 'dart:async';

import 'package:flutter/material.dart';
import 'package:token_state_manager/src/state_manager/token_state_manager.dart';

/// {@template single_state_builder}
/// Widget that builds based on the state of a [TokenState].
///
/// The [builder] is called every time the [tokenState] emits a new state.
///
/// If [buildWhen] is provided, the [builder] is called only when [buildWhen]
/// returns true.
///
/// If [emptyState] is provided, it is shown when the [tokenState] has no state.
/// By default, it is a [SizedBox.shrink()].
/// {@endtemplate}
class SingleStateBuilder<T> extends StatefulWidget {
  /// {@macro single_state_builder}
  const SingleStateBuilder({
    required this.tokenState,
    required this.builder,
    this.emptyState = const SizedBox.shrink(),
    this.buildWhen,
    super.key,
  });

  /// The [TokenState] to build the widget based on.
  final TokenState<T> tokenState;

  /// The widget builder for the [TokenState].
  final Widget Function(BuildContext context, T state) builder;

  /// The function that determines if the [builder] should be rebuilt.
  final bool Function(T? previousState, T currentState)? buildWhen;

  /// The widget to show when the [tokenState] has no state.
  final Widget emptyState;

  @override
  State<SingleStateBuilder<T>> createState() => _SingleStateBuilderState<T>();
}

class _SingleStateBuilderState<T> extends State<SingleStateBuilder<T>> {
  late final StreamSubscription<T> _subscription;
  T? _previousState;
  T? _currentState;

  @override
  void initState() {
    super.initState();
    _subscription = widget.tokenState.listen(_handleState);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  _handleState(T state) {
    if (widget.buildWhen?.call(_previousState, state) ?? true) {
      setState(() {
        _currentState = state;
      });
    }
    _previousState = state;
  }

  @override
  Widget build(BuildContext context) {
    return _currentState == null
        ? widget.emptyState
        : widget.builder(context, _currentState!);
  }
}
