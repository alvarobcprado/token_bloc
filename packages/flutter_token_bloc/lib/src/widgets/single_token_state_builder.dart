import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_token_bloc/flutter_token_bloc.dart';

/// {@template single_state_builder}
/// Widget that builds based on the state of a [TokenState] with type [T].
///
/// The [builder] is called every time the [tokenState] emits a new state.
///
/// If [buildWhen] is provided, the [builder] is called only when [buildWhen]
/// returns true.
///
/// If [emptyState] is provided, it is shown when the [tokenState] has no state
/// emitted. By default, it is a SizedBox.shrink().
/// {@endtemplate}
class SingleTokenStateBuilder<T> extends StatefulWidget {
  /// {@macro single_state_builder}
  const SingleTokenStateBuilder({
    required this.tokenState,
    required this.builder,
    this.emptyState = const SizedBox.shrink(),
    this.initialData,
    this.buildWhen,
    super.key,
  });

  /// The [TokenState] to build the widget based on.
  final TokenState<T> tokenState;

  /// The widget builder for the [TokenState].
  final TokenStateWidgetBuilder<T> builder;

  /// The function that determines if the [builder] should be rebuilt.
  final bool Function(T? previousState, T currentState)? buildWhen;

  /// The widget to show when the [tokenState] has no state.
  final Widget emptyState;

  /// The initial state of the [tokenState]. If null, [emptyState] is shown when
  /// the [tokenState] has no state.
  final T? initialData;

  @override
  State<SingleTokenStateBuilder<T>> createState() =>
      _SingleTokenStateBuilderState<T>();
}

class _SingleTokenStateBuilderState<T>
    extends State<SingleTokenStateBuilder<T>> {
  late final StreamSubscription<T> _subscription;
  T? _previousState;
  T? _currentState;

  @override
  void initState() {
    super.initState();
    _currentState = widget.initialData;
    _subscription = widget.tokenState.listen(_handleState);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _handleState(T state) {
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
        : widget.builder(context, _currentState as T);
  }
}
