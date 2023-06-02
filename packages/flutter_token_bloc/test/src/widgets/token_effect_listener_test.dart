import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_token_bloc/flutter_token_bloc.dart';

import '../../helpers.dart';

void main() async {
  late TestCounterBloc bloc;
  var testText = 'test';

  void onEffect(String effect) {
    testText = effect;
  }

  setUp(() {
    bloc = TestCounterBloc();
    testText = 'test';
  });

  tearDown(() => bloc.dispose());

  Future<void> buildWidget(WidgetTester tester, {required Widget child}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: child,
      ),
    );
  }

  group(
    'TokenEffectListener',
    () {
      testWidgets(
        'should not call onEffect when no process action',
        (tester) async {
          final widget = TokenEffectListener<String>(
            tokenEffect: bloc.counterEffect,
            onEffect: onEffect,
            child: const SizedBox(),
          );

          await tester.runAsync(() async {
            await buildWidget(
              tester,
              child: widget,
            );
            await tester.pumpAndSettle();
          });

          expect(testText, 'test');
        },
      );

      testWidgets(
        'should call onEffect when process action',
        (tester) async {
          final widget = TokenEffectListener<String>(
            tokenEffect: bloc.counterEffect,
            onEffect: onEffect,
            child: const SizedBox(),
          );

          await tester.runAsync(() async {
            await buildWidget(
              tester,
              child: widget,
            );
            bloc.incrementCounterAction();
            await tester.pumpAndSettle();
          });
          expect(testText, 'Odd');
        },
      );

      testWidgets(
        'should not call onEffect when listenWhen is false',
        (tester) async {
          final widget = TokenEffectListener<String>(
            tokenEffect: bloc.counterEffect,
            onEffect: onEffect,
            listenWhen: (previousEffect, currentEffect) => false,
            child: const SizedBox(),
          );

          await tester.runAsync(() async {
            await buildWidget(
              tester,
              child: widget,
            );
            bloc.incrementCounterAction();
            bloc.incrementCounterAction();
            await tester.pumpAndSettle();
          });
          expect(testText, 'test');
        },
      );

      testWidgets(
        'should call onEffect when listenWhen is true',
        (tester) async {
          final widget = TokenEffectListener<String>(
            tokenEffect: bloc.counterEffect,
            onEffect: onEffect,
            listenWhen: (previousEffect, currentEffect) => true,
            child: const SizedBox(),
          );

          await tester.runAsync(() async {
            await buildWidget(
              tester,
              child: widget,
            );
            bloc.incrementCounterAction();
            bloc.incrementCounterAction();
            await tester.pumpAndSettle();
            await Future<void>.delayed(Duration.zero);
          });
          expect(testText, 'Even');
        },
      );
    },
  );
}
