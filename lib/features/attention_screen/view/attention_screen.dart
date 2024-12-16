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
            const SizedBox(height: 20),
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
            const SizedBox(height: 10),
            Text(
              'Элетростимуляция никогда не должна применяться:',
              style: theme.textTheme.titleMedium,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(
                  '- Для детей;\n'
                  '- При беременности;\n'
                  '- К голове, в области сердца, в области крупных сосудов, при варикозном расширении вен, тромбозе, тромбофлебите; в области открытых и закрытых кровотечений, в местах травматических повреждений костей, нервов, мышц, сухожилий и мягких тканей, в области грыж и выпячивании тканей; в области поражений и заболеваний кожи (в том числе в области невусов (родимых пятен);\n'
                  '- Лицам с неустойчивой психикой;\n'
                  '- Лицам с эпилепсией, кардиостимуляторами (искусственными водителями ритмов сердца), в острый период ишемических и геморрагических поражений тканей мозга и сердца, онкологическими заболеваниями;\n'
                  '- При появлении аллергических реакций;\n'
                  '- При управлении транспортными средствами, механизмами, электротехническим оборудованием;\n'
                  '- при нарушении целостности изделия.\n\n'
                  'После процедуры возможно кратковременное покраснение в области воздействия. Не допускайте болевых и дискомфортных ощущений. Не допускайте использование электрода с сухими токопроводящими площадками.',
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ),
            Center(
              child: TexelButton.accent(
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
