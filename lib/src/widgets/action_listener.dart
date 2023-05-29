// ignore_for_file: inference_failure_on_function_return_type
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:token_state_manager/src/state_manager/token_state_manager.dart';

class ActionListener<T> extends StatefulWidget {
  const ActionListener({
    required this.child,
    required this.tokenAction,
    required this.onAction,
    this.listenWhen,
    super.key,
  });

  final Widget child;
  final TokenAction<T> tokenAction;
  final void Function(T action) onAction;
  final bool Function(T? previosAction, T currentAction)? listenWhen;

  @override
  _ActionListenerState<T> createState() => _ActionListenerState<T>();
}

class _ActionListenerState<T> extends State<ActionListener<T>> {
  late final StreamSubscription<T> _subscription;
  T? _previousAction;

  @override
  void initState() {
    _subscription = widget.tokenAction.listen(_handleAction);
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _handleAction(T action) {
    if (widget.listenWhen?.call(_previousAction, action) ?? true) {
      widget.onAction(action);
    }
    _previousAction = action;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
