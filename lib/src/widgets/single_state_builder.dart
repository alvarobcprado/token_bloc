import 'dart:async';

import 'package:flutter/material.dart';
import 'package:token_state_manager/src/state_manager/token_state_manager.dart';

class SingleStateBuilder<T> extends StatefulWidget {
  SingleStateBuilder({
    required this.tokenState,
    required this.builder,
    this.emptyState = const SizedBox.shrink(),
    this.handleWhen,
    super.key,
  });

  final TokenState<T> tokenState;
  final Widget Function(BuildContext context, T state) builder;
  final bool Function(T? previousState, T currentState)? handleWhen;
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
    if (widget.handleWhen?.call(_previousState, state) ?? true) {
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
