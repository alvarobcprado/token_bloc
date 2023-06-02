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
  });

  Future<void> buildWidget(WidgetTester tester, {required Widget child}) async {
    await tester.pumpWidget(
      MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets(
    'TokenEffectListener should emit effect when process action',
    (tester) async {
      final widget = TokenEffectListener<String>(
        tokenEffect: bloc.counterEffect,
        onEffect: onEffect,
        child: const SizedBox(),
      );

      await buildWidget(
        tester,
        child: widget,
      );

      bloc.incrementCounterAction();
      await tester.pumpAndSettle();
      expect(testText, 'Odd');
    },
  );
}
