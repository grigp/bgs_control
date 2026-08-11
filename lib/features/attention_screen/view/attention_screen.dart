import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../generated/l10n.dart';
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
                S.of(context).attention,
                style: theme.textTheme.titleLarge,
              ),
              Text(
                S.of(context).havingContraindications,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              Text(
                S.of(context).electrostimulationShouldNeverBeUsed,
                style: theme.textTheme.titleMedium,
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    S.of(context).contraindications,
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
                  text: S.of(context).itIsClear,
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
