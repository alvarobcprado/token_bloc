// ignore_for_file: avoid_print

import 'package:token_bloc/token_bloc.dart';

/// CounterBloc is a simple example of a TokenBloc.
class ExampleCounterBloc extends TokenBloc {
  ExampleCounterBloc() {
    /// The `onVoid` method is used to listen to Streams without a type.
    onVoid(incrementCounterAction, _onIncrementAction);

    onVoid(decrementCounterAction, _onDecrementAction);

    /// The `on` method is used to listen to Streams with a type.
    on<int>(counterState, _onCounterStateChanged);
  }

  /// The `TokenState` class is used to store and emit state changes.
  final inverseCounterState = TokenState<int>();

  /// The `seeded` constructor is used to set the initial state of a TokenState.
  final counterState = TokenState<int>.seeded(0);

  /// The `TokenAction` class is used to dispatch actions to the bloc proccess.
  final incrementCounterAction = TokenAction<void>();

  /// The `TokenActionVoid` class is used to dispatch void actions to the bloc.
  final decrementCounterAction = TokenActionVoid();

  /// The `TokenEffect` class is used to emit effects that can be listened to.
  final counterEffect = TokenEffect<String>();

  void _onIncrementAction() {
    /// The last emitted state can be accessed using the `valueOf` or
    /// `valueOrNullOf` methods.
    final newValue = valueOf(counterState) + 1;

    /// The `emitStateOf` method is used to emit a new state to the desired
    /// TokenState that was previously declared in the bloc.
    emitStateOf(counterState, newValue);
  }

  void _onDecrementAction() {
    final newValue = valueOf(counterState) - 1;
    emitStateOf(counterState, newValue);
  }

  void _onCounterStateChanged(int state) {
    emitStateOf(inverseCounterState, -state);
    if (state.isEven) {
      /// The `emitEffectOf` method is used to emit a new effect to the desired
      /// TokenEffect that was previously declared in the bloc.
      emitEffectOf(counterEffect, 'Even');
    } else {
      emitEffectOf(counterEffect, 'Odd');
    }
  }

  /// The `subjects` getter is used to return a list of all the subjects that
  /// the bloc handles.
  @override
  List<TokenSubject<dynamic>> get subjects => [
        counterState,
        inverseCounterState,
        incrementCounterAction,
        decrementCounterAction,
        counterEffect,
      ];
}

void main() {
  /// Create a new instance of the `ExampleCounterBloc` class.
  final bloc = ExampleCounterBloc();
  final stateList = <int>[];
  final inverseStateList = <int>[];
  final effectList = <String>[];

  /// Listen to the `counterState` changes emitted by the bloc.
  bloc.counterState.listen(stateList.add);

  /// Listen to the `inverseCounterState` changes emitted by the bloc.
  bloc.inverseCounterState.listen(inverseStateList.add);

  /// Listen to the `counterEffect` changes emitted by the bloc.
  bloc.counterEffect.listen(effectList.add);

  /// Dispatch the `incrementCounterAction` action to the bloc increment the
  /// counter state to 1.
  bloc.incrementCounterAction(null);

  /// Dispatch the `decrementCounterAction` action to the bloc decrement the
  /// counter state to 0.
  bloc.decrementCounterAction();

  /// Dispatch the `incrementCounterAction` action to the bloc increment the
  /// counter state to 1.
  bloc.incrementCounterAction(null);

  /// Dispatch the `incrementCounterAction` action to the bloc decrement the
  /// counter state to 2
  bloc.incrementCounterAction(null);

  Future.delayed(Duration.zero, () {
    /// The `stateList` and `inverseStateList` should have the same length and
    /// both starts with 0 because the `counterState` has been seeded with
    /// the initial value of 0.
    print(stateList); // [0, 1, 0, 1, 2]
    print(inverseStateList); // [0, -1, 0, -1, -2]
    print(effectList); // [Even, Odd, Even, Odd, Even]
  });
}
