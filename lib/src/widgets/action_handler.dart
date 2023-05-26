// ignore_for_file: inference_failure_on_function_return_type
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:token_state_manager/src/state_manager/token_state_manager.dart';

class ActionHandler<T> extends StatefulWidget {
  const ActionHandler({
    required this.child,
    required this.tokenAction,
    required this.onReceived,
    this.handleWhen,
    super.key,
  });

  final Widget child;
  final TokenAction<T> tokenAction;
  final void Function(T action) onReceived;
  final bool Function(T? previosAction, T currentAction)? handleWhen;

  @override
  _ActionHandlerState<T> createState() => _ActionHandlerState<T>();
}

class _ActionHandlerState<T> extends State<ActionHandler<T>> {
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
    if (widget.handleWhen?.call(_previousAction, action) ?? true) {
      widget.onReceived(action);
    }
    _previousAction = action;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
