import 'package:flutter/material.dart';
import 'package:token_state_manager/token_state_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
    return Scaffold(
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
            SingleStateBuilder(
              tokenState: stateManager.counterState,
              builder: (context, value) => Text(
                '$value',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: stateManager.incrementAction,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyCounterStateManager extends TokenStateManager {
  MyCounterStateManager() {
    onVoid(incrementAction, onData: _handleIncrement);
  }

  final counterState = TokenState<int>.seeded(0);
  final incrementAction = TokenVoidAction();

  void _handleIncrement() {
    updateStateOf(counterState, valueOf(counterState) + 1);
  }

  @override
  List<TokenSubject> get subjects => [
        counterState,
        incrementAction,
      ];
}
