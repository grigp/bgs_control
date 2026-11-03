import 'package:bgs_control/utils/baseutils.dart';
import 'package:flutter/material.dart';

//class PersonalProgramEditScreen extends StatefulWidget {

import '../../../assets/colors/colors.dart';
import '../../../generated/l10n.dart';
import '../../uikit/widgets/back_screen_button.dart';

/// Экран редактирования методики, созданной пользователем
class PersonalProgramEditScreen extends StatefulWidget {
  const PersonalProgramEditScreen({
    super.key,
    required this.title,
    required this.editMode,
  });

  final String title;
  final EditMode editMode;

  @override
  State<PersonalProgramEditScreen> createState() =>
      _PersonalProgramEditScreenState();
}

class _PersonalProgramEditScreenState extends State<PersonalProgramEditScreen> {
  late TextEditingController _textMethodName;
  late TextEditingController _textDescription;
  late TextEditingController _textElectrods;
  late TextEditingController _textAreases;
  late TextEditingController _textRecomend;

  bool _isReady = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        Future.delayed(Duration.zero, () {
          if (!context.mounted) return;
          Navigator.pop(context, 0);
        });
      },
      child: Scaffold(
        backgroundColor: white,
        body: Column(
          children: [
            Container(
              color: white,
              width: double.infinity,
              height: 110,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      BackScreenButton(
                        onBack: () {
                          Navigator.pop(context, 0);
                        },
                        hasBackground: true,
                        isClose: false,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.left,
                          textScaler: const TextScaler.linear(1.0),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              height: 0,
              indent: 0,
              thickness: 1,
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(),
                shrinkWrap: true,
                children: <Widget>[
                  if (_isReady)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 12,
                      ),
                      child: Column(
                        children: [
                          Text(
                            S.of(context).MethodName,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1.0),
                            style: const TextStyle(
                              color: black,
                              fontSize: 20,
                            ),
                          ),
                          TextField(
                            controller: _textMethodName,
                            style: Theme.of(context).textTheme.headlineSmall,
                            onChanged: _onNameChanged,
                            keyboardType: TextInputType.name,
                          ),
                          Text(
                            S.of(context).MethodDescription,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1.0),
                            style: const TextStyle(
                              color: black,
                              fontSize: 20,
                            ),
                          ),
                          TextField(
                            controller: _textDescription,
                            style: Theme.of(context).textTheme.headlineSmall,
                            onChanged: _onNameChanged,
                            keyboardType: TextInputType.name,
                          ),
                          Text(
                            S.of(context).compatibleElectrodeTypes,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1.0),
                            style: const TextStyle(
                              color: black,
                              fontSize: 20,
                            ),
                          ),
                          TextField(
                            controller: _textElectrods,
                            style: Theme.of(context).textTheme.headlineSmall,
                            onChanged: _onNameChanged,
                            keyboardType: TextInputType.name,
                          ),
                          Text(
                            S.of(context).areasStimulation,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1.0),
                            style: const TextStyle(
                              color: black,
                              fontSize: 20,
                            ),
                          ),
                          TextField(
                            controller: _textAreases,
                            style: Theme.of(context).textTheme.headlineSmall,
                            onChanged: _onNameChanged,
                            keyboardType: TextInputType.name,
                          ),
                          Text(
                            S.of(context).recommendationsForProcedure,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1.0),
                            style: const TextStyle(
                              color: black,
                              fontSize: 20,
                            ),
                          ),
                          TextField(
                            controller: _textRecomend,
                            style: Theme.of(context).textTheme.headlineSmall,
                            onChanged: _onNameChanged,
                            keyboardType: TextInputType.name,
                          ),
                          Text(
                            S.of(context).Stages,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1.0),
                            style: const TextStyle(
                              color: black,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: _save,
              heroTag: 'NewMethod',
              tooltip: S.of(context).addMethod,
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: const Icon(
                Icons.save,
                size: 40,
                color: filledAccentButtonColor,
              ),
            ),
            FloatingActionButton(
              onPressed: _cancel,
              heroTag: 'EditMethod',
              tooltip: S.of(context).editMethod,
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: const Icon(
                Icons.close,
                size: 40,
                color: filledAccentButtonColor,
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _textMethodName = TextEditingController(text: '');
    _textDescription = TextEditingController(text: '');
    _textElectrods = TextEditingController(text: '');
    _textAreases = TextEditingController(text: '');
    _textRecomend = TextEditingController(text: '');
    _isReady = true;
  }

  @override
  void dispose() {
    _textMethodName.dispose();
    _textDescription.dispose();
    _textElectrods.dispose();
    _textAreases.dispose();
    _textRecomend.dispose();

    super.dispose();
  }

  void _onNameChanged(String value) {
    // if (value != '') {
    //   _timeWait = int.tryParse(value)!;
    // }
  }

  void _save() async {
    Navigator.pop(context, 0);
  }

  void _cancel() async {
    Navigator.pop(context, 0);
  }
}
