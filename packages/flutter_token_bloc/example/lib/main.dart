import 'package:flutter/material.dart';
import 'package:flutter_token_bloc/flutter_token_bloc.dart';
import 'package:flutter_token_bloc/flutter_token_rx_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterTokenBloc Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FlutterTokenBloc Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final stateManager = MyCounterStateManager();

  @override
  Widget build(BuildContext context) {
    return TokenEffectListener(
      tokenEffect: stateManager.counterEffect,
      onEffect: (_) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('The counter is even!'),
            ),
          );
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              SingleTokenStateBuilder(
                tokenState: stateManager.counterState,
                builder: (context, value) => Text(
                  '$value',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: stateManager.incrementAction.call,
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              onPressed: stateManager.decrementAction.call,
              tooltip: 'Decrement',
              child: const Icon(Icons.remove),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCounterStateManager extends TokenBloc {
  MyCounterStateManager() {
    onVoid(
      // Can use all the RxDart stream operators
      incrementAction.debounceTime(const Duration(seconds: 1)),
      _handleIncrement,
    );
    onVoid(decrementAction, _handleDecrement);
    on(counterState, _handleCounterState);
  }

  final counterState = TokenState<int>.seeded(0);
  final counterEffect = TokenEffect<void>();
  final incrementAction = TokenActionVoid();
  final decrementAction = TokenActionVoid();

  void _handleIncrement() {
    emitStateOf(counterState, valueOf(counterState) + 1);
  }

  void _handleDecrement() {
    emitStateOf(counterState, valueOf(counterState) - 1);
  }

  void _handleCounterState(int newState) {
    if (newState.isEven) {
      emitEffectOf(counterEffect, null);
    }
  }

  @override
  List<TokenSubject> get subjects => [
        counterState,
        counterEffect,
        incrementAction,
        decrementAction,
      ];
}
