import 'package:test/test.dart';
import 'package:token_bloc/token_bloc.dart';

void main() {
  group(
    'TokenAction',
    () {
      test(
        'should dispatch an event to the subject',
        () async {
          var value = 0;
          final tokenAction = TokenAction<int>()
            ..stream.listen((event) {
              value = event;
            });

          tokenAction(10);

          await Future<void>.delayed(Duration.zero);

          expect(value, 10);
        },
      );

      test(
        'should dispatch an event to the subject with a void type',
        () async {
          var value = 0;
          TokenActionVoid()
            ..stream.listen((_) {
              value = 10;
            })
            ..call();

          await Future<void>.delayed(Duration.zero);

          expect(value, 10);
        },
      );
    },
  );

  group(
    'TokenState',
    () {
      test(
        'should initialize with null value',
        () {
          final tokenState = TokenState<int>();
          expect(tokenState.valueOrNull, null);
        },
      );

      test(
        'should initialize with a value',
        () {
          final tokenState = TokenState<int>.seeded(10);
          expect(tokenState.value, 10);
        },
      );
    },
  );

  group(
    'TokenActionState',
    () {
      test(
        'should initialize with null value',
        () {
          final tokenState = TokenActionState<int>();
          expect(tokenState.valueOrNull, null);
        },
      );

      test(
        'should initialize with a value',
        () {
          final tokenState = TokenActionState<int>.seeded(10);
          expect(tokenState.value, 10);
        },
      );

      test(
        'should update value when called',
        () {
          final tokenState = TokenActionState<int>.seeded(10);
          expect(tokenState.value, 10);
          tokenState(20);
          expect(tokenState.value, 20);
        },
      );
    },
  );
}
