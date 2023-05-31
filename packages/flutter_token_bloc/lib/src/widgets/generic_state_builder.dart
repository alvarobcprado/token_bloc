import 'package:flutter/material.dart';
import 'package:flutter_token_bloc/flutter_token_bloc.dart';

/// {@template generic_state_builder}
/// Widget that builds based on the state of a [TokenState] wich 2 generic
/// states of type [T1] and [T2].
///
/// If [tokenState] has no one of the 2 generic states, an [UnknownStateTypeException]
/// is thrown.
/// {@endtemplate}
class GenericStateBuilder2<T1 extends T, T2 extends T, T>
    extends StatelessWidget {
  /// {@macro generic_state_builder}
  const GenericStateBuilder2({
    required this.tokenState,
    required this.builder1,
    required this.builder2,
    super.key,
  });

  /// The [TokenState] to build the widget based on.
  final TokenState<T> tokenState;

  /// The widget builder for the [T1] or null state.
  final Widget Function(BuildContext context, T1? data) builder1;

  /// The widget builder for the [T2] state.
  final Widget Function(BuildContext context, T2 data) builder2;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: tokenState,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null || data is T1) {
          return builder1(context, data as T1?);
        }
        if (data is T2) {
          return builder2(context, data as T2);
        }
        throw UnknownStateTypeException();
      },
    );
  }
}
