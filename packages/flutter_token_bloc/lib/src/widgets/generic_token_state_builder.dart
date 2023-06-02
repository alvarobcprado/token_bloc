import 'package:flutter/material.dart';
import 'package:flutter_token_bloc/flutter_token_bloc.dart';

/// Builder for a widget based on the state of a [TokenState] with type [T].
typedef TokenStateWidgetBuilder<T> = Widget Function(
  BuildContext context,
  T data,
);

/// {@template generic_token_state_builder}
/// Widget that builds based on the generic state types of a [TokenState] with
/// type [T].
///
/// If [tokenState] has no one of the generic states, an
/// [UnknownStateTypeException] is thrown.
/// {@endtemplate}
class GenericTokenStateBuilder2<T1 extends T, T2 extends T, T>
    extends StatelessWidget {
  /// {@macro generic_token_state_builder}
  const GenericTokenStateBuilder2({
    required this.tokenState,
    required this.builder1,
    required this.builder2,
    super.key,
  });

  /// The [TokenState] to build the widget based on.
  final TokenState<T> tokenState;

  /// The widget builder for the [T1] or null state.
  final TokenStateWidgetBuilder<T1?> builder1;

  /// The widget builder for the [T2] state.
  final TokenStateWidgetBuilder<T2> builder2;

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

/// {@macro generic_token_state_builder}
class GenericTokenStateBuilder3<T1 extends T, T2 extends T, T3 extends T, T>
    extends StatelessWidget {
  /// {@macro generic_token_state_builder}
  const GenericTokenStateBuilder3({
    required this.tokenState,
    required this.builder1,
    required this.builder2,
    required this.builder3,
    super.key,
  });

  /// The [TokenState] to build the widget based on.
  final TokenState<T> tokenState;

  /// The widget builder for the [T1] or null state.
  final TokenStateWidgetBuilder<T1?> builder1;

  /// The widget builder for the [T2] state.
  final TokenStateWidgetBuilder<T2> builder2;

  /// The widget builder for the [T3] state.
  final TokenStateWidgetBuilder<T3> builder3;

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
        if (data is T3) {
          return builder3(context, data as T3);
        }
        throw UnknownStateTypeException();
      },
    );
  }
}

/// {@macro generic_token_state_builder}
class GenericTokenStateBuilder4<T1 extends T, T2 extends T, T3 extends T,
    T4 extends T, T> extends StatelessWidget {
  /// {@macro generic_token_state_builder}
  const GenericTokenStateBuilder4({
    required this.tokenState,
    required this.builder1,
    required this.builder2,
    required this.builder3,
    required this.builder4,
    super.key,
  });

  /// The [TokenState] to build the widget based on.
  final TokenState<T> tokenState;

  /// The widget builder for the [T1] or null state.
  final TokenStateWidgetBuilder<T1?> builder1;

  /// The widget builder for the [T2] state.
  final TokenStateWidgetBuilder<T2> builder2;

  /// The widget builder for the [T3] state.
  final TokenStateWidgetBuilder<T3> builder3;

  /// The widget builder for the [T4] state.
  final TokenStateWidgetBuilder<T4> builder4;

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
        if (data is T3) {
          return builder3(context, data as T3);
        }
        if (data is T4) {
          return builder4(context, data as T4);
        }
        throw UnknownStateTypeException();
      },
    );
  }
}

/// {@macro generic_token_state_builder}
class GenericTokenStateBuilder5<T1 extends T, T2 extends T, T3 extends T,
    T4 extends T, T5 extends T, T> extends StatelessWidget {
  /// {@macro generic_token_state_builder}
  const GenericTokenStateBuilder5({
    required this.tokenState,
    required this.builder1,
    required this.builder2,
    required this.builder3,
    required this.builder4,
    required this.builder5,
    super.key,
  });

  /// The [TokenState] to build the widget based on.
  final TokenState<T> tokenState;

  /// The widget builder for the [T1] or null state.
  final TokenStateWidgetBuilder<T1?> builder1;

  /// The widget builder for the [T2] state.
  final TokenStateWidgetBuilder<T2> builder2;

  /// The widget builder for the [T3] state.
  final TokenStateWidgetBuilder<T3> builder3;

  /// The widget builder for the [T4] state.
  final TokenStateWidgetBuilder<T4> builder4;

  /// The widget builder for the [T5] state.
  final TokenStateWidgetBuilder<T5> builder5;

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
        if (data is T3) {
          return builder3(context, data as T3);
        }
        if (data is T4) {
          return builder4(context, data as T4);
        }
        if (data is T5) {
          return builder5(context, data as T5);
        }

        throw UnknownStateTypeException();
      },
    );
  }
}

/// Used to throw an exception when the state type is not defined in the
/// GenericTokenStateBuilder widgets.
class UnknownStateTypeException implements Exception {
  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'UnknownStateTypeException: The state type is not defined in the GenericTokenStateBuilder';
  }
}
