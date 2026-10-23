import 'package:flutter/material.dart';

class HistSeancesScreen extends StatefulWidget {
  const HistSeancesScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<HistSeancesScreen> createState() => _HistSeancesScreenState();
}

class _HistSeancesScreenState extends State<HistSeancesScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        Future.delayed(Duration.zero, () {
          if (!context.mounted) return;
          Navigator.of(context).popUntil(
            ModalRoute.withName('/select_method'),
          );
        });
      },
      child: Scaffold(
          body: SafeArea(
        child: Text('hello'),
      )),
    );
  }
}
