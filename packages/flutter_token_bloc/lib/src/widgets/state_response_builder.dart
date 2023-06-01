import 'package:flutter/material.dart';
import 'package:token_bloc/token_bloc.dart';

/// {@template state_response_builder}
/// Widget that builds based on the state of a [TokenState] wich has 3 basic
/// states: [Loading], [Error] and [Success].
///
/// If [loadingWidgetBuilder] is not provided, a [CircularProgressIndicator] is
/// shown.
///
/// If [errorWidgetBuilder] is not provided, a [Text] with the text 'Error' is
/// shown.
///
/// If [tokenState] has no one of the 3 basic states, an
/// [UnknownStateTypeException] is thrown.
/// {@endtemplate}
class StateResponseBuilder<Loading extends T, Error extends T,
    Success extends T, T> extends StatelessWidget {
  /// {@macro state_response_builder}
  const StateResponseBuilder({
    required this.tokenState,
    required this.successWidgetBuilder,
    required this.onTryAgainTap,
    this.loadingWidgetBuilder,
    this.errorWidgetBuilder,
    super.key,
  });

  /// The [TokenState] to build the widget based on.
  final TokenState<T> tokenState;

  /// The widget builder for the [Success] state.
  final Widget Function(
    BuildContext context,
    Success success,
  ) successWidgetBuilder;

  /// The widget builder for the [Loading] state.
  final Widget Function(
    BuildContext context,
    Loading? loading,
  )? loadingWidgetBuilder;

  /// The widget builder for the [Error] state.
  final Widget Function(
    BuildContext context,
    Error? error,
    VoidCallback onTryAgain,
  )? errorWidgetBuilder;

  /// The callback for the [Error] state.
  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: tokenState,
      builder: (context, snapshot) {
        final data = snapshot.data;

        if (data == null || data is Loading) {
          if (loadingWidgetBuilder != null) {
            return loadingWidgetBuilder!(context, data as Loading?);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (data is Error) {
          if (errorWidgetBuilder != null) {
            return errorWidgetBuilder!(context, data as Error, onTryAgainTap);
          }
          return const Center(
            child: Text('Error'),
          );
        }

        if (data is Success) {
          return successWidgetBuilder(context, data as Success);
        }
        throw UnknownStateTypeException();
      },
    );
  }
}

/// Exception thrown when the [TokenState] has an unknown type.
class UnknownStateTypeException implements Exception {}
