part of 'token_bloc.dart';

/// {@template token_subject}
/// The base class for all [TokenSubject]s.
///
/// Holds the subject and exposes only its [stream] getter and [close] method.
/// {@endtemplate}
abstract class TokenSubject<T> extends StreamView<T> {
  /// {@macro token_subject}
  TokenSubject(
    this._subject,
  ) : super(_subject.stream);

  final Subject<T> _subject;

  /// The [Stream] of the [Subject].
  Stream<T> get stream => _subject.stream;

  /// Closes the [Subject].
  void close() {
    _subject.close();
  }
}

/// {@template token_action}
/// A [TokenSubject] that holds a [PublishSubject].
///
/// It is used to dispatch actions with type [T] for [TokenBloc] process it.
///
/// Example:
/// ```dart
/// final action = TokenAction<int>();
/// action(1);
/// ```
/// {@endtemplate}
class TokenAction<T> extends TokenSubject<T> {
  /// {@macro token_action}
  TokenAction({
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) : super(
          PublishSubject<T>(
            onListen: onListen,
            onCancel: onCancel,
            sync: sync,
          ),
        );

  /// Sends an event T to the subject.
  void call(T value) {
    _subject.add(value);
  }
}

/// {@template token_action_void}
/// A [TokenAction] that holds [PublishSubject] with a void type.
///
/// It is used to dispatch actions without a value for [TokenBloc] process it.
///
/// Example:
/// ```dart
/// final action = TokenVoidAction();
/// action();
/// ```
/// {@endtemplate}
class TokenActionVoid extends TokenAction<void> {
  /// {@macro token_action_void}
  TokenActionVoid({
    super.onListen,
    super.onCancel,
    super.sync = false,
  });

  @override
  void call([void value]) {
    _subject.add(null);
  }
}

/// {@template token_action_state}
/// A special [TokenSubject] that acts as a [TokenAction] but holds a
/// [TokenState].
///
/// It is used to dispatch actions with type [T] for [TokenBloc] process it and
/// to hold the last dispatched action. It can be seeded with a initial value.
///
/// Example:
/// ```dart
/// final action = TokenActionState<int>.seeded(0);
/// action(1);
/// ```
/// {@endtemplate}
class TokenActionState<T> extends TokenState<T> {
  /// {@macro token_action_state}
  TokenActionState({
    super.onListen,
    super.onCancel,
    super.sync = false,
  });

  /// {@macro token_state}
  TokenActionState.seeded(
    super.state, {
    super.onListen,
    super.onCancel,
    super.sync = false,
  }) : super.seeded();

  /// Sends an event T to the subject.
  void call(T value) {
    _subject.add(value);
  }
}

/// {@template token_state}
/// A [TokenSubject] that holds a [BehaviorSubject].
///
/// It is used to emit states with type [T] from [TokenBloc] to be listened and
/// to hold the last emitted state. It can be seeded with a initial value.
///
///
/// This state can be get with the valueOf or valueOrNullOf methods and can be
/// emitted with the emitStateOf method that can be accessed only through the
/// [TokenBloc] classes.
///
/// Example:
/// ```dart
/// class MyStateManager extends TokenBloc {
///   MyStateManager() {
///     // Listen to the counterState and print its value
///     on<int>(counterState, onData: (value) => print(value));
///
///     // Update the counterState with the value of the counterState + 1
///     emitStateOf(counterState, valueOf(counterState) + 1);
///   }
///
///   @override
///   List<TokenSubject> get subjects => [
///     counterState,
///   ];
///
///   final counterState = TokenState.seeded(0);
/// }
/// ```
/// {@endtemplate}
class TokenState<T> extends TokenSubject<T> {
  /// {@macro token_state}
  TokenState({
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) : super(
          BehaviorSubject<T>(
            onListen: onListen,
            onCancel: onCancel,
            sync: sync,
          ),
        );

  /// {@macro token_state}
  TokenState.seeded(
    T state, {
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) : super(
          BehaviorSubject<T>.seeded(
            state,
            onListen: onListen,
            onCancel: onCancel,
            sync: sync,
          ),
        );

  BehaviorSubject<T> get _stateSubject => _subject as BehaviorSubject<T>;
}

/// {@template token_effect}
/// A [TokenSubject] that holds a [PublishSubject].
///
/// It is used to dispatch effects from the [TokenBloc]s to be listened.
///
/// Example:
/// ```dart
/// class MyStateManager extends TokenBloc {
///   MyStateManager() {
///     // Listen to the counterState and print its value
///     on<int>(counterState, onData: (value) {
///       if (value.isEven) {
///         emitEffectOf(counterEffect, 'Even');
///       } else {
///         emitEffectOf(counterEffect, 'Odd');
///       }
///     });
///
///     // Update the counterState with the value of the counterState + 1
///     emitStateOf(counterState, valueOf(counterState) + 1);
///   }
///
///   @override
///   List<TokenSubject> get subjects => [
///     counterState,
///     counterEffect,
///   ];
///
///   final counterState = TokenState.seeded(0);
///   final counterEffect = TokenEffect<String>();
/// }
/// ```
/// {@endtemplate}
///
class TokenEffect<T> extends TokenSubject<T> {
  /// {@macro token_effect}
  TokenEffect({
    void Function()? onListen,
    void Function()? onCancel,
    bool sync = false,
  }) : super(
          PublishSubject<T>(
            onListen: onListen,
            onCancel: onCancel,
            sync: sync,
          ),
        );
}

/// An extension that exposes the [TokenState] methods to the [TokenBloc]s.
/// Should not be used outside of the [TokenBloc]s.
@visibleForTesting
extension TokenBlocStateExtension<T> on TokenState<T> {
  /// Returns the last emitted value of the [TokenState].
  @visibleForTesting
  T get value => _stateSubject.value;

  /// Returns the last emitted value of the [TokenState] or null if no value
  /// has been emitted.
  @visibleForTesting
  T? get valueOrNull => _stateSubject.valueOrNull;

  /// Returns true if the [TokenState] has emitted at least one value.
  @visibleForTesting
  bool get hasValue => _stateSubject.hasValue;

  /// Sends an event T to the subject.
  @visibleForTesting
  void add(T newValue) {
    _stateSubject.add(newValue);
  }
}

/// An extension that exposes the [TokenEffect] methods to the [TokenBloc]s.
/// Should not be used outside of the [TokenBloc]s.
@visibleForTesting
extension TokenBlocEffectExtension<T> on TokenEffect<T> {
  /// Sends an event T to the subject.
  @visibleForTesting
  void add(T newValue) {
    _subject.add(newValue);
  }
}
