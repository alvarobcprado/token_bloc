import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

part './token_state.dart';

extension _TokenStateManagerExtension<T> on TokenState<T> {
  T get value => this._value;

  T? get valueOrNull => this._valueOrNull;

  void add(T newValue) {
    this._add(newValue);
  }
}

/// A [TokenStateManager] is a class that holds a list of [TokenSubject]s that
/// can be used to manage the state of the view.
///
/// It must be extended and the [subjects] must be implemented with the list of
/// [TokenSubject]s that will be used to manage the state of the view.
///
/// Example of usage:
/// ```dart
/// class MyStateManager extends TokenStateManager {
///  MyStateManager() {
///  on<int>(counterState, onData: (value) => print(value));
///  onVoid(incrementAction, onData: () => updateStateOf(counterState, valueOf(counterState) + 1));
///  onVoid(decrementAction, onData: () => updateStateOf(counterState, valueOf(counterState) - 1));
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
abstract class TokenStateManager {
  final CompositeSubscription _subscriptions = CompositeSubscription();

  /// The list of [TokenSubject]s that will be used to manage the state of the
  /// view. It must be implemented.
  List<TokenSubject> get subjects;

  /// Listens to a [Stream] and adds the events to the [_subscriptions] list.
  ///
  /// It is a wrapper for the [Stream.listen] method.
  void on<T>(
    Stream<T> stream,
    void Function(T)? onData, {
    Function? onError,
    void Function()? onDone,
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

  void onVoid(
    Stream<void> stream,
    void Function()? onData, {
    Function? onError,
    void Function()? onDone,
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

  /// Returns the value of a [TokenState].
  ///
  /// It is a wrapper for the [BehaviorSubject.value] getter.
  T valueOf<T>(TokenState<T> state) {
    return state.value;
  }

  /// Returns the value of a [TokenState] or null if it has no value.
  ///
  /// It is a wrapper for the [BehaviorSubject.valueOrNull] getter.
  T? valueOrNullOf<T>(TokenState<T> state) {
    return state.valueOrNull;
  }

  /// Updates the value of a [TokenState].
  ///
  /// It is a wrapper for the [BehaviorSubject.add] method.
  void updateStateOf<T, S extends T>(TokenState<T> state, S newValue) {
    state.add(newValue);
  }

  /// Closes all the [TokenSubject]s.
  @mustCallSuper
  void dispose() {
    for (final subject in subjects) {
      subject.close();
    }
    _subscriptions.dispose();
  }
}
