import 'package:flutter/material.dart';
import 'package:token_state_manager/src/state_manager/token_state_manager.dart';

class StateResponseBuilder<Loading extends T, Error extends T,
    Success extends T, T> extends StatelessWidget {
  StateResponseBuilder({
    required this.tokenState,
    required this.successWidgetBuilder,
    required this.onTryAgainTap,
    this.loadingWidgetBuilder,
    this.errorWidgetBuilder,
    super.key,
  }) : assert(T != dynamic);

  final TokenState<T> tokenState;

  final Widget Function(
    BuildContext context,
    Success success,
  ) successWidgetBuilder;

  final Widget Function(
    BuildContext context,
    Loading? loading,
  )? loadingWidgetBuilder;

  final Widget Function(
    BuildContext context,
    Error? error,
    VoidCallback onTryAgain,
  )? errorWidgetBuilder;

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

class UnknownStateTypeException implements Exception {}
