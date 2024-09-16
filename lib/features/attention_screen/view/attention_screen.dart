import 'package:flutter/material.dart';

import '../../uikit/texel_button.dart';

class AttentionScreen extends StatefulWidget {
  const AttentionScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<AttentionScreen> createState() => _AttentionScreenState();
}

class _AttentionScreenState extends State<AttentionScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Center(
              child: Image.asset('images/attention.png'),
            ),
            Text(
              'Внимание',
              style: theme.textTheme.titleLarge,
            ),
            Text(
              'имеются противопоказания',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              'Элетростимуляция никогда не должна применяться:',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    '- При беременности;\n'
                        '- У людей, страдающих от грыжи или выпячивания органов;\n'
                        '- К голове;\n'
                        '- К людям, страдающим эпилепсией;\n'
                        '- В местах травматических повреждений нервов, мышц и сухожилий;\n'
                        '- В острый период пишемических поражений тканей мозга и сердца;\n'
                        '- В местах заболевания кожи.',
                    style: theme.textTheme.titleMedium,
                  ),
                ),

            ),
            Center(
              child:
              TexelButton.accent(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                text: 'Понятно',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
