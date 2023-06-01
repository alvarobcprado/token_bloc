import 'package:token_bloc/token_bloc.dart';

class TestCounterBloc extends TokenBloc {
  TestCounterBloc() {
    onVoid(incrementCounterAction, _onIncrementAction);
    onVoid(decrementCounterAction, _onDecrementAction);
    on<int>(counterState, _onCounterStateChanged);
  }

  final counterState = TokenState<int>();
  final inverseCounterState = TokenState<int>();
  final incrementCounterAction = TokenActionVoid();
  final decrementCounterAction = TokenActionVoid();
  final seededCounterState = TokenState.seeded(1);

  void _onIncrementAction() {
    final newValue = valueOrNullOf(counterState) ?? 0 + 1;
    updateStateOf(counterState, newValue);
  }

  void _onDecrementAction() {
    final newValue = valueOrNullOf(counterState) ?? 0 - 1;
    updateStateOf(counterState, newValue);
  }

  void _onCounterStateChanged(int state) {
    updateStateOf(inverseCounterState, -state);
  }

  @override
  List<TokenSubject<dynamic>> get subjects => [
        counterState,
        inverseCounterState,
        incrementCounterAction,
        decrementCounterAction,
      ];
}
