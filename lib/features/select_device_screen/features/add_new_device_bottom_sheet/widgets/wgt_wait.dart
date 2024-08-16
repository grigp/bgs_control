import 'package:flutter/material.dart';

class WgtWait extends StatelessWidget {
  const WgtWait({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Поиск стимуляторов',
              style: theme.textTheme.headlineMedium,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
