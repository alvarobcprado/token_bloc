import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

part './token_state.dart';

typedef TypeCallback<T> = void Function(T value);

extension _TokenStateManagerExtension<T> on TokenState<T> {
  T get value => this._stateSubject.value;

  T? get valueOrNull => this._stateSubject.valueOrNull;

  bool get hasValue => this._stateSubject.hasValue;

  void add(T newValue) {
    this._stateSubject.add(newValue);
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
///  on<int>(counterState, (value) => print(value));
///  onVoid(incrementAction, () => updateStateOf(counterState, valueOf(counterState) + 1));
///  onVoid(decrementAction, () => updateStateOf(counterState, valueOf(counterState) - 1));
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
  @protected
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

  @protected
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

  /// Returns the value of a [TokenState].
  ///
  /// It is a wrapper for the [BehaviorSubject.value] getter.
  @protected
  T valueOf<T>(TokenState<T> state) {
    return state.value;
  }

  /// Returns the value of a [TokenState] or null if it has no value.
  ///
  /// It is a wrapper for the [BehaviorSubject.valueOrNull] getter.
  @protected
  T? valueOrNullOf<T>(TokenState<T> state) {
    return state.valueOrNull;
  }

  /// Updates the value of a [TokenState].
  ///
  /// It is a wrapper for the [BehaviorSubject.add] method.
  @protected
  void updateStateOf<T, S extends T>(TokenState<T> state, S newValue) {
    state.add(newValue);
  }

  /// Returns true if the [TokenState] has a value. Otherwise, returns false.
  ///
  /// It is a wrapper for the [BehaviorSubject.hasValue] getter.
  @protected
  bool hasValueOf<T>(TokenState<T> state) {
    return state.hasValue;
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
