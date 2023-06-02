import 'package:flutter_token_bloc/flutter_token_bloc.dart';

class TestCounterBloc extends TokenBloc {
  TestCounterBloc() {
    onVoid(incrementCounterAction, _onIncrementAction);
    on<int>(counterState, _onCounterStateChanged);
  }

  final counterState = TokenState<int>();
  final incrementCounterAction = TokenActionVoid();
  final counterEffect = TokenEffect<String>();

  void _onIncrementAction() {
    final newValue = (valueOrNullOf(counterState) ?? 0) + 1;
    emitStateOf(counterState, newValue);
  }

  void _onCounterStateChanged(int state) {
    if (state.isEven) {
      emitEffectOf(counterEffect, 'Even');
    } else {
      emitEffectOf(counterEffect, 'Odd');
    }
  }

  @override
  List<TokenSubject<dynamic>> get subjects => [
        counterState,
        incrementCounterAction,
        counterEffect,
      ];
}

class TestGenericCounterBloc extends TokenBloc {
  TestGenericCounterBloc() {
    onVoid(incrementCounterAction, _onIncrementAction);
  }
  @override
  List<TokenSubject<dynamic>> get subjects => [
        counterState,
        incrementCounterAction,
      ];

  final counterState = TokenState<CounterState>.seeded(ZeroState());
  final incrementCounterAction = TokenActionVoid();

  void _onIncrementAction() {
    final lastValue = valueOrNullOf(counterState) ?? ZeroState();
    var newValue = lastValue;

    if (lastValue is ZeroState) {
      newValue = OneState();
    } else if (lastValue is OneState) {
      newValue = TwoState();
    } else if (lastValue is TwoState) {
      newValue = ThreeState();
    } else if (lastValue is ThreeState) {
      newValue = FourState();
    } else if (lastValue is FourState) {
      newValue = FiveState();
    } else if (lastValue is FiveState) {
      newValue = ZeroState();
    }

    emitStateOf(counterState, newValue);
  }
}

abstract class CounterState {}

class ZeroState extends CounterState {
  @override
  String toString() => '0';
}

class OneState extends CounterState {
  @override
  String toString() => '1';
}

class TwoState extends CounterState {
  @override
  String toString() => '2';
}

class ThreeState extends CounterState {
  @override
  String toString() => '3';
}

class FourState extends CounterState {
  @override
  String toString() => '4';
}

class FiveState extends CounterState {
  @override
  String toString() => '5';
}
