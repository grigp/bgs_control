import 'package:bgs_control/utils/baseutils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

//class PersonalProgramEditScreen extends StatefulWidget {

import '../../../assets/colors/colors.dart';
import '../../../generated/l10n.dart';
import '../../../repositories/methodic_programs/model/methodic_program.dart';
import '../../../repositories/methodic_programs/storage/program_storage.dart';
import '../../../utils/text_fields_decoration/edit_program_decoration.dart';
import '../../uikit/widgets/back_screen_button.dart';

/// Экран редактирования методики, созданной пользователем
class PersonalProgramEditScreen extends StatefulWidget {
  const PersonalProgramEditScreen({
    super.key,
    required this.title,
    required this.editMode,
    required this.progId,
  });

  final String title;
  final EditMode editMode;
  final String progId;

  @override
  State<PersonalProgramEditScreen> createState() =>
      _PersonalProgramEditScreenState();
}

class _PersonalProgramEditScreenState extends State<PersonalProgramEditScreen> {
  late MethodicProgram _program;
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
                            style: nameParamStyle(),
                          ),
                          TextField(
                            controller: _textMethodName,
                            style: const TextStyle(color: Colors.black, fontSize: 20),
                            decoration: editProgramDecoration('Введите название программы'),
                            onChanged: _onNameChanged,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            S.of(context).MethodDescription,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1.0),
                            style: nameParamStyle(),
                          ),
                          TextField(
                            controller: _textDescription,
                            style: const TextStyle(color: Colors.black, fontSize: 20),
                            decoration: editProgramDecoration('Введите описание программы'),
                            onChanged: _onNameChanged,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            S.of(context).compatibleElectrodeTypes,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1.0),
                            style: nameParamStyle(),
                          ),
                          TextField(
                            controller: _textElectrods,
                            style: const TextStyle(color: Colors.black, fontSize: 20),
                            decoration: editProgramDecoration('Введите типы электродов'),
                            onChanged: _onNameChanged,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            S.of(context).areasStimulation,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1.0),
                            style: nameParamStyle(),
                          ),
                          TextField(
                            controller: _textAreases,
                            style: const TextStyle(color: Colors.black, fontSize: 20),
                            decoration: editProgramDecoration('Введите типы электродов'),
                            onChanged: _onNameChanged,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            S.of(context).recommendationsForProcedure,
                            textAlign: TextAlign.left,
                            textScaler: const TextScaler.linear(1.0),
                            style: nameParamStyle(),
                          ),
                          TextField(
                            controller: _textRecomend,
                            style: const TextStyle(color: Colors.black, fontSize: 20),
                            decoration: editProgramDecoration('Введите рекомендации'),
                            onChanged: _onNameChanged,
                            keyboardType: TextInputType.name,
                          ),
                          const SizedBox(height: 20),
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

    _program = GetIt.I<ProgramStorage>().getProgram(widget.progId);

    _textMethodName = TextEditingController(text: _program.title);
    _textDescription = TextEditingController(text: _program.description);
    _textElectrods = TextEditingController(text: _program.electrods);
    _textAreases = TextEditingController(text: _program.areases);
    _textRecomend = TextEditingController(text: _program.recomendations);
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
