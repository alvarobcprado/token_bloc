<div style="text-align: center; font-family: times new roman">
<h1>TokenBloc</h1>
  <a href="https://pub.dev/packages/token_bloc"><img src="https://img.shields.io/pub/v/token_bloc.svg" alt="Pub.dev Badge"></a>
	<a href="https://github.com/alvarobcprado/token_bloc/actions"><img src="https://github.com/alvarobcprado/token_bloc/actions/workflows/token_bloc.yml/badge.svg" alt="GitHub Build Badge"></a>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>
  <a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="Very Good Analysis Style Badge"></a>

</div>

## About
A dart package that helps implement the [BLoC design pattern](https://www.flutteris.com/blog/en/reactive-programming-streams-bloc) with the power of [Dart Stream](https://api.dart.dev/stable/3.0.3/dart-async/Stream-class.html) extended by the capabilities provided by [RxDart](https://pub.dev/packages/rxdart) library.

## Usage

### Creating a TokenBloc class:

```dart
import 'package:token_bloc/token_bloc.dart';

/// A bloc that manages a counter.
class CounterBloc extends TokenBloc {
  /// Creates a [CounterBloc] and sets the action handlers.
  CounterBloc() {
    /// When an [incrementCounterAction] is dispatched, the [_onIncrementAction] method is called.
    onVoid(incrementCounterAction, _onIncrementAction);
    /// When an [decrementCounterAction] is dispatched, the [_onDecrementAction] method is called.
    onVoid(decrementCounterAction, _onDecrementAction);
  }

  /// The state of the counter with an initial value of 0.
  final counterState = TokenState<int>.seeded(0);

  /// The action to increment the counter.
  final incrementCounterAction = TokenActionVoid();

  /// The action to decrement the counter.
  final decrementCounterAction = TokenActionVoid();

  void _onIncrementAction() {
    /// The current value of the counter is obtained with the [valueOf] method.
    final newValue = valueOf(counterState) + 1;

    /// The new value is emitted with the [emitStateOf] method.
    emitStateOf(counterState, newValue);
  }

  void _onDecrementAction() {
    final newValue = valueOf(counterState) - 1;
    emitStateOf(counterState, newValue);
  }

  /// The [subjects] getter is used to obtain the token subjects that the bloc manages.
  @override
  List<TokenSubject<dynamic>> get subjects => [
        counterState,
        incrementCounterAction,
        decrementCounterAction,
      ];
}
```

### Using a bloc class:

```dart
Future<void> main() async {
  /// Create the `bloc`.
  final bloc = CounterBloc();

  /// Listen to the counter state changes.
  bloc.counterState.listen((state) {
    print('Counter: ${state.value}');
  });

  /// Dispatch the increment action.
  bloc.incrementCounterAction();

  /// Dispatch the decrement action.
  bloc.decrementCounterAction();

  /// Dispose the `bloc` when it is no longer needed.
  await subscription.dispose();
}
```

## Contributing
We welcome contributions to this package. If you would like to contribute, please feel free to open an issue or a pull request.

## Example
To see a complete example, see the [TokenBloc Example](https://github.com/alvarobcprado/token_bloc/blob/main/packages/token_bloc/example) folder.

## License
TokenBloc is licensed under the MIT License. See the [LICENSE](https://github.com/alvarobcprado/token_bloc/blob/main/packages/token_bloc/LICENSE) for details.
