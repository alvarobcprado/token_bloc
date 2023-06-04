<div style="text-align: center; font-family: times new roman">
<h1>TokenBloc</h1>
  <a href="https://pub.dev/packages/flutter_token_bloc"><img src="https://img.shields.io/pub/v/flutter_token_bloc.svg" alt="Pub.dev Badge"></a>
	<a href="https://github.com/alvarobcprado/token_bloc/actions"><img src="https://github.com/alvarobcprado/token_bloc/actions/workflows/flutter_token_bloc.yml/badge.svg" alt="GitHub Build Badge"></a>
	<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="MIT License Badge"></a>
  <a href="https://pub.dev/packages/very_good_analysis"><img src="https://img.shields.io/badge/style-very_good_analysis-B22C89.svg" alt="Very Good Analysis Style Badge"></a>

</div>

## About
A package that provides a set of Widgets that helps the TokenBlocs integration with [Flutter](https://flutter.dev). Built to be used with [TokenBloc](https://pub.dev/packages/token_bloc).

## Usage

### Creating a TokenBloc class:

```dart
import 'package:token_bloc/token_bloc.dart';

class CounterBloc extends TokenBloc {
  CounterBloc() {
    onVoid(incrementCounterAction, _onIncrementAction);
    onVoid(decrementCounterAction, _onDecrementAction);
    on<int>(counterState, _onCounterStateChange);
  }

  final counterState = TokenState<int>.seeded(0);
  final counterEffect = TokenEffect<String>();
  final incrementCounterAction = TokenActionVoid();
  final decrementCounterAction = TokenActionVoid();

  void _onIncrementAction() {
    final newValue = valueOf(counterState) + 1;
    emitStateOf(counterState, newValue);
  }

  void _onDecrementAction() {
    final newValue = valueOf(counterState) - 1;
    emitStateOf(counterState, newValue);
  }

  void _onCounterStateChange(int newValue) {
    if (newValue == 0) {
      emitEffectOf(counterEffect, 'Counter is zero');
    }else{
      emitEffectOf(counterEffect, 'Counter is $newValue');
    }
  }

  @override
  List<TokenSubject<dynamic>> get subjects => [
        counterState,
        counterEffect,
        incrementCounterAction,
        decrementCounterAction,
      ];
}
```

### Consuming the TokenBloc:

```dart
class CounterPage extends StatelessWidget {
  const CounterPage({required this.counterBloc, 
  Key? key,
  }) : super(key: key);

  final CounterBloc counterBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: SingleTokenStateBuilder(
        tokenState: counterBloc.counterState,
        builder: (context, count) => Center(child: Text('$count')),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: counterBloc.incrementCounterAction.call,
          ),
          const SizedBox(height: 4),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: counterBloc.decrementCounterAction.call,
          ),
        ],
      ),
    );
  }
}
```

## FlutterTokenBloc Widgets

### SingleTokenStateBuilder
`SingleTokenStateBuilder` handles building a widget in response to new states emitted by a single `TokenState` instance.

```dart
SingleTokenStateBuilder(
  tokenState: counterBloc.counterState,
  builder: (context, count) {
    // return widget here based on the state of counterBloc.counterState
  }
)
```

The TokenState can be initialized without a value, in this case, the `emptyState` parameter will be used to build the widget. By default, `emptyState` is a SizedBox.shrink().

```dart
SingleTokenStateBuilder(
  tokenState: counterBloc.counterState,
  emptyState: const Text('Empty') // optional,
  builder: (context, count) {
    // if counterState has no previous state emmited, this builder will not be called
  }
)
```

For more granular control over the `builder` calls, you can provide a `buildWhen` function. The `buildWhen` function will be invoked on each state change. `buildWhen` takes the previous state and current state and returns a boolean which determines whether or not to rebuild the widget with the current state. If `buildWhen` returns false, `builder` will not be called.

```dart
SingleTokenStateBuilder(
  tokenState: counterBloc.counterState,
  buildWhen: (previous, current) {
    // return true/false to determine whether or not
    // to rebuild the widget with the current state
  },
  builder: (context, count) {
    // return widget here based on the state of counterBloc.counterState
    // this builder will only be called when buildWhen returns true
  }
)
```

### GenericTokenStateBuilder
`GenericTokenStateBuilder` handles building a widget in response to the generics state types `T` emitted by a single `TokenState` instance.

```dart
GenericTokenStateBuilder2<Loading, Success, HomeState>(
  tokenState: homeBloc.homeState,
  builder1: (context, loadingData) {
    // return widget here to represent the loading state
  }
  builder2: (context, successData) {
    // return widget here to represent the success state
  }
)
```

The `TokenState` can be initialized without a value, in this case, the `builder1` parameter will be used to build the widget.

Case the `TokenState` emits a state that is not handled by the `GenericTokenStateBuilder`, an `UnknownStateTypeException` will be thrown.

The `GenericTokenStateBuilder` can be used with 2 to 5 generics types by using the variants `GenericTokenStateBuilder2`, `GenericTokenStateBuilder3`, `GenericTokenStateBuilder4` and `GenericTokenStateBuilder5` respectively.

### TokenEffectListener
`TokenEffectListener` handles the effects emitted by a `TokenEffect` instance. It's useful for executing side effects such as navigation or showing a dialog controlled by the TokenBloc process.

```dart
TokenEffectListener(
  tokenEffect: counterBloc.counterEffect,
  onEffect: (effect) {
    // call side effects here based on the effect emitted
    // e.g. Navigator.of(context).pushNamed('/next_page', arguments: effect);
  }
  child: // child widget
)
```

For more granular control over the `onEffect` calls, you can provide a `listenWhen` function. The `listenWhen` function will be invoked on each effect change. `listenWhen` takes the previous effect and current effect and returns a boolean which determines whether or not to execute `onEffect` with the current effect. If `listenWhen` returns false, `onEffect` will not be called.

```dart
TokenEffectListener(
  tokenEffect: counterBloc.counterEffect,
  listenWhen: (previous, current) {
    // return true/false to determine whether or not
    // to execute onEffect with the current effect
  },
  onEffect: (effect) {
    // call side effects here based on the effect emitted
    // this callback will only be called when listenWhen returns true
  }
  child: // child widget
)
```

## Contributing
We welcome contributions to this package. If you would like to contribute, please feel free to open an issue or a pull request.

## Example
To see a complete example, see the [FlutterTokenBloc Example](https://github.com/alvarobcprado/token_bloc/blob/main/packages/flutter_token_bloc/example) folder.

## License
TokenBloc is licensed under the MIT License. See the [LICENSE](https://github.com/alvarobcprado/token_bloc/blob/main/packages/flutter_token_bloc/LICENSE) for details.
