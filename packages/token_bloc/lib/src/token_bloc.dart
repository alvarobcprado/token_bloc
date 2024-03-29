// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'token_subject.dart';

/// Type callback that takes a value of type [T].
typedef TypeCallback<T> = void Function(T value);

/// Void callback.
typedef VoidCallback = void Function();

/// A [TokenBloc] is a class that holds a list of [TokenSubject]s that
/// can be used to manage the state using the BLoC design pattern.
///
/// It must be extended and the [subjects] must be implemented with the list of
/// [TokenSubject]s that will be used to manage the state.
///
/// Example of usage:
/// ```dart
/// class MyStateManager extends TokenBloc {
///  MyStateManager() {
///  on<int>(counterState, (value) => print(value));
///  onVoid(incrementAction, () => emitStateOf(counterState, valueOf(counterState) + 1));
///  onVoid(decrementAction, () => emitStateOf(counterState, valueOf(counterState) - 1));
/// }
///
///  @override
///  List<TokenSubject> get subjects => [
///   counterState,
///   incrementAction,
///   decrementAction,
///  ];
///
///  final counterState = TokenState.seeded(0);
///  final incrementAction = TokenVoidAction();
///  final decrementAction = TokenVoidAction();
/// }
/// ```
abstract class TokenBloc {
  final CompositeSubscription _subscriptions = CompositeSubscription();

  /// The list of [TokenSubject]s that will be used to manage the state.
  /// It must be implemented in the [TokenBloc] classes to disposes the
  /// [TokenSubject]s correctly.
  List<TokenSubject<dynamic>> get subjects;

  /// Listens to a [Stream] with type [T] and cancels the subscription when the
  /// [TokenBloc] is disposed.
  @protected
  @visibleForTesting
  void on<T>(
    Stream<T> stream,
    TypeCallback<T>? onData, {
    Function? onError,
    VoidCallback? onDone,
    bool? cancelOnError,
  }) {
    stream
        .listen(
          onData,
          onError: onError,
          onDone: onDone,
          cancelOnError: cancelOnError,
        )
        .addTo(_subscriptions);
  }

  /// Listens to a [Stream] with [void] type and cancels the subscription when
  /// the [TokenBloc] is disposed.
  @protected
  @visibleForTesting
  void onVoid(
    Stream<void> stream,
    VoidCallback? onData, {
    Function? onError,
    VoidCallback? onDone,
    bool? cancelOnError,
  }) {
    on<void>(
      stream,
      (_) => onData?.call(),
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  /// Returns the last emmited value of the given [TokenState].
  @protected
  @visibleForTesting
  T valueOf<T>(TokenState<T> tokenState) {
    _validateTokenSubject(tokenState);
    return tokenState.value;
  }

  /// Returns the last emmited value of the given [TokenState] or null if the
  /// [TokenState] has no value emmited.
  ///
  /// Throws a [StateError] if the given [TokenState] is not part of the
  /// [subjects] list of this [TokenBloc].
  /// {@endtemplate}
  @protected
  @visibleForTesting
  T? valueOrNullOf<T>(TokenState<T> tokenState) {
    _validateTokenSubject(tokenState);
    return tokenState.valueOrNull;
  }

  /// Emits the given [state] to the given [TokenState].
  ///
  /// Throws a [StateError] if the given [TokenState] is not part of the
  /// [subjects] list of this [TokenBloc].
  /// {@endtemplate}
  @protected
  @visibleForTesting
  void emitStateOf<T, S extends T>(TokenState<T> tokenState, S state) {
    _validateTokenSubject(tokenState);
    tokenState.add(state);
  }

  /// Returns true if the [TokenState] has at least one value emmited.
  ///
  /// Throws a [StateError] if the given [TokenState] is not part of the
  /// [subjects] list of this [TokenBloc].
  /// {@endtemplate}
  @protected
  @visibleForTesting
  bool hasValueOf<T>(TokenState<T> tokenState) {
    _validateTokenSubject(tokenState);
    return tokenState.hasValue;
  }

  /// Emits the given [effect] to the given [tokenEffect].
  ///
  ///  Throws a [StateError] if the given [TokenEffect] is not part of the
  /// [subjects] list of this [TokenBloc].
  /// {@endtemplate}
  @protected
  @visibleForTesting
  void emitEffectOf<T, S extends T>(TokenEffect<T> tokenEffect, S effect) {
    _validateTokenSubject(tokenEffect);
    tokenEffect.add(effect);
  }

  void _validateTokenSubject(TokenSubject<dynamic> tokenSubject) {
    if (subjects.contains(tokenSubject) == false) {
      throw StateError(
        'The given TokenSubject is not part of the subjects list of this TokenBloc. '
        'Please add it to the subjects list of this TokenBloc.',
      );
    }
  }

  /// Closes all the [TokenSubject]s and cancels all the subscriptions.
  @mustCallSuper
  void dispose() {
    for (final subject in subjects) {
      subject.close();
    }
    _subscriptions.dispose();
  }
}
