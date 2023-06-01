// ignore_for_file: library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:token_bloc/token_bloc.dart';

/// {@template effect_listener}
/// Widget that listens to a [TokenEffect] with type [T] and calls [onEffect]
/// when it emits.
///
/// The [listenWhen] is called every time the [TokenEffect] emits and if it
/// returns true, [onEffect] is called.
/// {@endtemplate}
class EffectListener<T> extends StatefulWidget {
  /// {@macro effect_listener}
  const EffectListener({
    required this.child,
    required this.tokenEffect,
    required this.onEffect,
    this.listenWhen,
    super.key,
  });

  /// The child widget.
  final Widget child;

  /// The [TokenEffect] to listen to.
  final TokenEffect<T> tokenEffect;

  /// The function to call when [tokenEffect] emits.
  final void Function(T effect) onEffect;

  /// The function that determines if [onEffect] should be called.
  final bool Function(T? previousEffect, T currentEffect)? listenWhen;

  @override
  _EffectListenerState<T> createState() => _EffectListenerState<T>();
}

class _EffectListenerState<T> extends State<EffectListener<T>> {
  late final StreamSubscription<T> _subscription;
  T? _previousEffect;

  @override
  void initState() {
    _subscription = widget.tokenEffect.listen(_handleEffect);
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _handleEffect(T effect) {
    if (widget.listenWhen?.call(_previousEffect, effect) ?? true) {
      widget.onEffect(effect);
    }
    _previousEffect = effect;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
