part of './token_state_manager.dart';

/// The base class for all [TokenSubject]s.
///
/// Holds the subject and exposes only its [stream] getter and [close] method.
abstract class TokenSubject<T, S extends Subject<T>> extends StreamView<T> {
  TokenSubject(
    this._subject,
  ) : super(_subject.stream);

  final S _subject;

  Stream<T> get stream => _subject.stream;

  void close() {
    _subject.close();
  }
}

/// A [TokenSubject] that holds a [PublishSubject].
///
/// It is used to dispatch actions with the [call] method.
///
/// Example:
/// ```dart
/// final action = TokenAction<int>();
/// action(1);
/// ```
class TokenAction<T> extends TokenSubject<T, PublishSubject<T>> {
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

  void call(T value) {
    _subject.add(value);
  }
}

/// A [TokenAction] that holds [PublishSubject] with no value.
///
/// It is used to dispatch actions with the [call] method without passing a
/// value.
///
/// Example:
/// ```dart
/// final action = TokenVoidAction();
/// action();
/// ```
class TokenVoidAction extends TokenAction<void> {
  TokenVoidAction({
    super.onListen,
    super.onCancel,
    super.sync = false,
  });

  @override
  void call([void value]) {
    _subject.add(null);
  }
}

/// A [TokenSubject] that holds a [BehaviorSubject].
///
/// It is used to hold the state of the view. It can be seeded with a initial
/// value.
///
/// This value can be get with the [valueOf] [valueOrNullOf] and
/// [updateStateOf] methods that can be accessed only through the
/// [TokenStateManager] classes.
///
/// Example:
/// ```dart
/// class MyStateManager extends TokenStateManager {
///   MyStateManager() {
///     // Listen to the counterState and print its value
///     on<int>(counterState, onData: (value) => print(value));
///
///     // Update the counterState with the value of the counterState + 1
///     updateStateOf(counterState, valueOf(counterState) + 1);
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
class TokenState<T> extends TokenSubject<T, BehaviorSubject<T>> {
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

  T get _value => _subject.value;
  T? get _valueOrNull => _subject.valueOrNull;
  void _add(T value) => _subject.add(value);
}
