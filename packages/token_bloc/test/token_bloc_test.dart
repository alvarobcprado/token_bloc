// ignore_for_file: lines_longer_than_80_chars

import 'package:test/test.dart';
import 'package:token_bloc/token_rx_utils.dart';

import 'helpers.dart';

void main() {
  late TestCounterBloc bloc;

  setUp(() => bloc = TestCounterBloc());
  tearDown(() => bloc.dispose());

  group(
    'TokenBloc State Handler',
    () {
      test(
        'should update the state of the counterState when incrementCounterAction is called',
        () async {
          bloc.incrementCounterAction();
          expect(bloc.counterState, emits(1));
        },
      );

      test(
        'should update the state of the counterState when decrementCounterAction is called',
        () async {
          bloc.decrementCounterAction();
          expect(bloc.counterState, emits(-1));
        },
      );

      test(
        'should update the state of the inverseCounterState when counterState is incremented',
        () async {
          bloc.incrementCounterAction();
          expect(bloc.counterState, emits(1));
          expect(bloc.inverseCounterState, emits(-1));
        },
      );

      test(
        'should update the state of the inverseCounterState when counterState is decremented',
        () async {
          bloc.decrementCounterAction();
          expect(bloc.counterState, emits(-1));
          expect(bloc.inverseCounterState, emits(1));
        },
      );

      test(
        'should throw an StateError when trying to interact with disposed TokenBloc',
        () async {
          bloc.dispose();
          expect(
            () => bloc.incrementCounterAction(),
            throwsA(isA<StateError>()),
          );
        },
      );
    },
  );

  group(
    'TokenBloc Value Handler',
    () {
      test(
        'should return value when valueOf is called on a TokenState with a value',
        () async {
          expect(bloc.valueOf(bloc.seededCounterState), 1);
        },
      );

      test(
        'should throw an ValueStreamError when valueOf is called on a TokenState without a value',
        () async {
          expect(
            () => bloc.valueOf(bloc.counterState),
            throwsA(isA<ValueStreamError>()),
          );
        },
      );

      test(
        'should return null when valueOrNullOf is called on a TokenState without a value',
        () async {
          expect(bloc.valueOrNullOf(bloc.counterState), null);
        },
      );

      test(
        'should return the true when hasValueOf is called on a TokenState with a value',
        () async {
          expect(bloc.hasValueOf(bloc.seededCounterState), true);
        },
      );

      test(
        'should return the false when hasValueOf is called on a TokenState without a value',
        () async {
          expect(bloc.hasValueOf(bloc.counterState), false);
        },
      );
    },
  );

  group(
    'TokenBloc Listener',
    () {
      test(
        'should call the TypeCallback when stream emits a value',
        () async {
          var onCountValue = 0;

          bloc.on<int>(
            Stream<int>.value(10),
            (value) => onCountValue = value,
          );
          await Future<void>.delayed(Duration.zero);
          expect(onCountValue, 10);
        },
      );

      test(
        'should call the VoidCallback when stream emits a value',
        () async {
          var onCountValue = 0;

          bloc.onVoid(
            Stream<void>.value(null),
            () => onCountValue = 10,
          );

          await Future<void>.delayed(Duration.zero);
          expect(onCountValue, 10);
        },
      );
    },
  );
}
