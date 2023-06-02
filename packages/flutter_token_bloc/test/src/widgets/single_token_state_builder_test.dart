import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_token_bloc/flutter_token_bloc.dart';

import '../../helpers.dart';

void main() {
  late TestCounterBloc bloc;

  setUp(() {
    bloc = TestCounterBloc();
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
    'SingleTokenStateBuilder',
    () {
      testWidgets(
        'should not call builder when no process action',
        (tester) async {
          final widget = SingleTokenStateBuilder(
            tokenState: bloc.counterState,
            emptyState: const Text('empty'),
            builder: (context, state) => Text(state.toString()),
          );

          await tester.runAsync(() async {
            await buildWidget(tester, child: widget);
            await tester.pumpAndSettle();
          });

          expect(find.text('0'), findsNothing);
          expect(find.text('empty'), findsOneWidget);
        },
      );

      testWidgets(
        'should call builder when initialData is provided',
        (tester) async {
          final widget = SingleTokenStateBuilder(
            tokenState: bloc.counterState,
            initialData: 0,
            emptyState: const Text('empty'),
            builder: (context, state) => Text(state.toString()),
          );

          await tester.runAsync(() async {
            await buildWidget(tester, child: widget);
            await tester.pumpAndSettle();
          });

          expect(find.text('0'), findsOneWidget);
          expect(find.text('empty'), findsNothing);
        },
      );

      testWidgets(
        'should call builder when process action',
        (tester) async {
          final widget = SingleTokenStateBuilder(
            tokenState: bloc.counterState,
            emptyState: const Text('empty'),
            builder: (context, state) => Text(state.toString()),
          );

          await tester.runAsync(() async {
            await buildWidget(tester, child: widget);
            bloc.incrementCounterAction();
            await tester.pumpAndSettle();
          });

          expect(find.text('empty'), findsNothing);
          expect(find.text('1'), findsOneWidget);
        },
      );

      testWidgets(
        'should not call builder when buildWhen is false',
        (widgetTester) async {
          final widget = SingleTokenStateBuilder(
            tokenState: bloc.counterState,
            emptyState: const Text('empty'),
            builder: (context, state) => Text(state.toString()),
            buildWhen: (previous, current) => false,
          );

          await widgetTester.runAsync(() async {
            await buildWidget(widgetTester, child: widget);
            bloc.incrementCounterAction();
            bloc.incrementCounterAction();
            await widgetTester.pumpAndSettle();
          });

          expect(find.text('empty'), findsOneWidget);
          expect(find.text('1'), findsNothing);
        },
      );

      testWidgets(
        'should call builder when buildWhen is true',
        (widgetTester) async {
          final widget = SingleTokenStateBuilder(
            tokenState: bloc.counterState,
            emptyState: const Text('empty'),
            builder: (context, state) => Text(state.toString()),
            buildWhen: (previous, current) => true,
          );

          await widgetTester.runAsync(() async {
            await buildWidget(widgetTester, child: widget);
            bloc.incrementCounterAction();
            bloc.incrementCounterAction();
            await widgetTester.pumpAndSettle();
          });

          expect(find.text('empty'), findsNothing);
          expect(find.text('2'), findsOneWidget);
        },
      );
    },
  );
}
