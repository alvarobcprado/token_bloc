// ignore_for_file: inference_failure_on_function_return_type
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:token_state_manager/src/state_manager/token_state_manager.dart';

/// {@template action_listener}
/// Widget that listens to a [TokenAction] and calls [onAction] when it emits.
///
/// The [listenWhen] is called every time the [TokenAction] emits and if it returns true,
/// [onAction] is called.
/// {@endtemplate}
class ActionListener<T> extends StatefulWidget {
  /// {@macro action_listener}
  const ActionListener({
    required this.child,
    required this.tokenAction,
    required this.onAction,
    this.listenWhen,
    super.key,
  });

  /// The child widget.
  final Widget child;

  /// The [TokenAction] to listen to.
  final TokenAction<T> tokenAction;

  /// The function to call when [tokenAction] emits.
  final void Function(T action) onAction;

  /// The function that determines if [onAction] should be called.
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
