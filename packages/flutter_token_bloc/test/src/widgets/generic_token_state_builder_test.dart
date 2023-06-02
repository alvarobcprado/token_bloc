// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_token_bloc/flutter_token_bloc.dart';

import '../../helpers.dart';

void main() {
  late TestGenericCounterBloc bloc;

  setUp(() {
    bloc = TestGenericCounterBloc();
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
    'GenericTokenStateBuilder2',
    () {
      testWidgets(
        'should throw UnknownStateTypeException when state is not T1 or T2',
        (tester) async {
          final widget =
              GenericTokenStateBuilder2<OneState, TwoState, CounterState>(
            tokenState: bloc.counterState,
            builder1: (context, state) => Text(state.toString()),
            builder2: (context, state) => Text(state.toString()),
          );

          await tester.runAsync(() async {
            await buildWidget(tester, child: widget);
            await tester.pumpAndSettle();
          });

          expect(tester.takeException(), isA<UnknownStateTypeException>());
        },
      );

      testWidgets(
        'should build widget based on state type',
        (tester) async {
          final widget =
              GenericTokenStateBuilder2<ZeroState, OneState, CounterState>(
            tokenState: bloc.counterState,
            builder1: (context, state) => Text(state.toString()),
            builder2: (context, state) => Text(state.toString()),
          );

          await tester.runAsync(() async {
            await buildWidget(tester, child: widget);
            await tester.pumpAndSettle();
          });

          expect(find.text('0'), findsOneWidget);

          await tester.runAsync(() async {
            bloc.incrementCounterAction();
            await tester.pumpAndSettle();
          });

          expect(find.text('1'), findsOneWidget);
        },
      );
    },
  );

  group(
    'GenericTokenStateBuilder3',
    () {
      testWidgets(
        'should throw UnknownStateTypeException when state is not T1, T2 or T3',
        (tester) async {
          final widget = GenericTokenStateBuilder3<OneState, TwoState,
              ThreeState, CounterState>(
            tokenState: bloc.counterState,
            builder1: (context, state) => Text(state.toString()),
            builder2: (context, state) => Text(state.toString()),
            builder3: (context, state) => Text(state.toString()),
          );

          await tester.runAsync(() async {
            await buildWidget(tester, child: widget);
            await tester.pumpAndSettle();
          });

          expect(tester.takeException(), isA<UnknownStateTypeException>());
        },
      );

      testWidgets(
        'should build widget based on state type',
        (tester) async {
          final widget = GenericTokenStateBuilder3<ZeroState, OneState,
              TwoState, CounterState>(
            tokenState: bloc.counterState,
            builder1: (context, state) => Text(state.toString()),
            builder2: (context, state) => Text(state.toString()),
            builder3: (context, state) => Text(state.toString()),
          );

          await tester.runAsync(() async {
            await buildWidget(tester, child: widget);
            await tester.pumpAndSettle();
          });

          expect(find.text('0'), findsOneWidget);

          await tester.runAsync(() async {
            bloc.incrementCounterAction();
            await tester.pumpAndSettle();
          });

          expect(find.text('1'), findsOneWidget);

          await tester.runAsync(() async {
            bloc.incrementCounterAction();
            await tester.pumpAndSettle();
          });

          expect(find.text('2'), findsOneWidget);
        },
      );
    },
  );

  group(
    'GenericTokenStateBuilder4',
    () {
      testWidgets(
        'should throw UnknownStateTypeException when state is not T1, T2, T3 or T4',
        (tester) async {
          final widget = GenericTokenStateBuilder4<OneState, TwoState,
              ThreeState, FourState, CounterState>(
            tokenState: bloc.counterState,
            builder1: (context, state) => Text(state.toString()),
            builder2: (context, state) => Text(state.toString()),
            builder3: (context, state) => Text(state.toString()),
            builder4: (context, state) => Text(state.toString()),
          );

          await tester.runAsync(() async {
            await buildWidget(tester, child: widget);
            await tester.pumpAndSettle();
          });

          expect(tester.takeException(), isA<UnknownStateTypeException>());
        },
      );

      testWidgets(
        'should build widget based on state type',
        (tester) async {
          final widget = GenericTokenStateBuilder4<ZeroState, OneState,
              TwoState, ThreeState, CounterState>(
            tokenState: bloc.counterState,
            builder1: (context, state) => Text(state.toString()),
            builder2: (context, state) => Text(state.toString()),
            builder3: (context, state) => Text(state.toString()),
            builder4: (context, state) => Text(state.toString()),
          );

          await tester.runAsync(() async {
            await buildWidget(tester, child: widget);
            await tester.pumpAndSettle();
          });

          expect(find.text('0'), findsOneWidget);

          await tester.runAsync(() async {
            bloc.incrementCounterAction();
            await tester.pumpAndSettle();
          });

          expect(find.text('1'), findsOneWidget);

          await tester.runAsync(() async {
            bloc.incrementCounterAction();
            await tester.pumpAndSettle();
          });

          expect(find.text('2'), findsOneWidget);

          await tester.runAsync(() async {
            bloc.incrementCounterAction();
            await tester.pumpAndSettle();
          });

          expect(find.text('3'), findsOneWidget);
        },
      );
    },
  );

  group(
    'GenericTokenStateBuilder5',
    () {
      testWidgets(
        'should throw UnknownStateTypeException when state is not T1, T2, T3, T4 or T5',
        (tester) async {
          final widget = GenericTokenStateBuilder5<OneState, TwoState,
              ThreeState, FourState, FiveState, CounterState>(
            tokenState: bloc.counterState,
            builder1: (context, state) => Text(state.toString()),
            builder2: (context, state) => Text(state.toString()),
            builder3: (context, state) => Text(state.toString()),
            builder4: (context, state) => Text(state.toString()),
            builder5: (context, state) => Text(state.toString()),
          );

          await tester.runAsync(() async {
            await buildWidget(tester, child: widget);
            await tester.pumpAndSettle();
          });

          expect(tester.takeException(), isA<UnknownStateTypeException>());
        },
      );

      testWidgets(
        'should build widget based on state type',
        (tester) async {
          final widget = GenericTokenStateBuilder5<ZeroState, OneState,
              TwoState, ThreeState, FourState, CounterState>(
            tokenState: bloc.counterState,
            builder1: (context, state) => Text(state.toString()),
            builder2: (context, state) => Text(state.toString()),
            builder3: (context, state) => Text(state.toString()),
            builder4: (context, state) => Text(state.toString()),
            builder5: (context, state) => Text(state.toString()),
          );

          await tester.runAsync(() async {
            await buildWidget(tester, child: widget);
            await tester.pumpAndSettle();
          });

          expect(find.text('0'), findsOneWidget);

          await tester.runAsync(() async {
            bloc.incrementCounterAction();
            await tester.pumpAndSettle();
          });

          expect(find.text('1'), findsOneWidget);

          await tester.runAsync(() async {
            bloc.incrementCounterAction();
            await tester.pumpAndSettle();
          });

          expect(find.text('2'), findsOneWidget);

          await tester.runAsync(() async {
            bloc.incrementCounterAction();
            await tester.pumpAndSettle();
          });

          expect(find.text('3'), findsOneWidget);

          await tester.runAsync(() async {
            bloc.incrementCounterAction();
            await tester.pumpAndSettle();
          });

          expect(find.text('4'), findsOneWidget);
        },
      );
    },
  );
}
