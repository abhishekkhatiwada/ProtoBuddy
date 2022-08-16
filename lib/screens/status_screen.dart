import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:protobuddy/providers/auth_provider.dart';
import 'package:protobuddy/screens/auth_screen.dart';
import 'package:protobuddy/screens/homescreen.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: ((context, ref, child) {
        final userStream = ref.watch(authStream);
        return userStream.when(
            data: (data) {
              if (data == null) {
                return AuthScreen();
              } else {
                return HomeScreen();
              }
            },
            error: ((error, stackTrace) => Center(
                  child: Text('$error'),
                )),
            loading: (() => Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )));
      }),
    );
  }
}
