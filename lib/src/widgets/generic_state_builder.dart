import 'package:flutter/material.dart';
import 'package:token_state_manager/src/state_manager/token_state_manager.dart';
import 'package:token_state_manager/src/widgets/widgets.dart';

class GenericStateBuilder2<T1 extends T, T2 extends T, T>
    extends StatelessWidget {
  GenericStateBuilder2({
    required this.tokenState,
    required this.builder1,
    required this.builder2,
    super.key,
  }) : assert(T != dynamic);

  final TokenState<T> tokenState;
  final Widget Function(BuildContext context, T1? data) builder1;
  final Widget Function(BuildContext context, T2 data) builder2;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: tokenState,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null || data is T1) {
          return builder1(context, data as T1?);
        }
        if (data is T2) {
          return builder2(context, data as T2);
        }
        throw UnknownStateTypeException();
      },
    );
  }
}
