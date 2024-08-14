import 'package:flutter/material.dart';

class WgtWait extends StatelessWidget {
  const WgtWait({super.key});

  @override
  Widget build(BuildContext context) {
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
                width: 200,
                height: 200,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.teal,
                ),
              ),
            ),
            Text(
              'Поиск стимуляторов',
              style: TextStyle(
                fontSize: 26,
                color: Colors.teal.shade900,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
