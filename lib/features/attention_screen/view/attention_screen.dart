import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../repositories/app_monitor/app_monitor.dart';
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
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
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 12),
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    GetIt.I<AppMonitor>().setWindowStatus(AppWindows.awAttention, true);

  }

  @override
  void dispose() {
    GetIt.I<AppMonitor>().setWindowStatus(AppWindows.awAttention, false);
    super.dispose();
  }
}
