import 'package:bgs_control/utils/baseutils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

//class PersonalProgramEditScreen extends StatefulWidget {

import '../../../assets/colors/colors.dart';
import '../../../generated/l10n.dart';
import '../../../repositories/bgs_connect/bgs_defines.dart';
import '../../../repositories/methodic_programs/model/methodic_program.dart';
import '../../../repositories/methodic_programs/storage/program_storage.dart';
import '../../../utils/text_fields_decoration/edit_program_decoration.dart';
import '../../direct_control_screen/widgets/params_widget.dart';
import '../../uikit/widgets/back_screen_button.dart';
import '../widgets/edit_stage_title.dart';

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
  late TextEditingController _textStageName;
  late TextEditingController _textStageDuration;

  bool _isReady = false;
  int _idxSelStage = -1;

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
                        children: <Widget>[
                          ..._buildHeader(context),
                          ..._buildStagesTiles(context),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Добавить этап',
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          ..._buildStage(context),
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
    _textStageName = TextEditingController(text: '');
    _textStageDuration = TextEditingController(text: '');
    _isReady = true;
  }

  @override
  void dispose() {
    _textMethodName.dispose();
    _textDescription.dispose();
    _textElectrods.dispose();
    _textAreases.dispose();
    _textRecomend.dispose();
    _textStageName.dispose();
    _textStageDuration.dispose();

    super.dispose();
  }

  void _onNameChanged(String value) {
    // if (value != '') {
    //   _timeWait = int.tryParse(value)!;
    // }
  }

  void _onDescriptionChanged(String value) {}

  void _onElectrodeChanged(String value) {}

  void _onAreasesChanged(String value) {}

  void _onRecomendationChanged(String value) {}

  void _onStageNameChanged(String value) {}

  void _onStageDurationChanged(String value) {}

  void _save() async {
    Navigator.pop(context, 0);
  }

  void _cancel() async {
    Navigator.pop(context, 0);
  }

  Text _buildTextLabel(String text) {
    return Text(
      text,
      textAlign: TextAlign.left,
      textScaler: const TextScaler.linear(1.0),
      style: nameParamStyle(),
    );
  }

  TextField _buildTextField(TextEditingController contrroller, String hintText,
      ValueChanged<String> onChanged) {
    return TextField(
      controller: contrroller,
      style: const TextStyle(color: Colors.black, fontSize: 20),
      decoration: editProgramDecoration(hintText),
      onChanged: onChanged,
      keyboardType: TextInputType.name,
    );
  }

  TextFormField _buildTextTimeField(TextEditingController contrroller,
      String hintText, ValueChanged<String> onChanged) {
    // Настраиваем маску: # означает любую цифру
    final timeMaskFormatter = MaskTextInputFormatter(
      mask: '##:##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );

    return TextFormField(
      controller: contrroller,
      inputFormatters: [timeMaskFormatter],
      style: const TextStyle(color: Colors.black, fontSize: 20),
      decoration: editProgramDecorationTime(),
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      // Валидация введенных данных
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Введите время';
        }
        if (value.length < 5) {
          return 'Введите время полностью (ММ:СС)';
        }

        // Разделяем строку на минуты и секунды
        final parts = value.split(':');
        final minutes = int.tryParse(parts[0]) ?? 0;
        final seconds = int.tryParse(parts[1]) ?? 0;

        // Секунд не может быть больше 59
        if (seconds >= 60) {
          return 'Секунды не могут быть больше 59';
        }
        // Опционально: ограничение на минуты, если нужно
        if (minutes > 99) {
          return 'Максимум 99 минут';
        }

        return null;
      },
    );
  }

  List<Widget> _buildHeader(BuildContext context) {
    List<Widget> retval = [];

    /// Название программы
    retval.add(_buildTextLabel(S.of(context).MethodName));
    retval.add(_buildTextField(
        _textMethodName, S.of(context).inputMethodName, _onNameChanged));
    retval.add(const SizedBox(height: 10));

    /// Описание программы
    retval.add(_buildTextLabel(S.of(context).MethodDescription));
    retval.add(_buildTextField(_textDescription,
        S.of(context).inputMethodDescription, _onDescriptionChanged));
    retval.add(const SizedBox(height: 10));

    /// Тип электродов
    retval.add(_buildTextLabel(S.of(context).compatibleElectrodeTypes));
    retval.add(_buildTextField(
        _textElectrods, S.of(context).InputElectrodeType, _onElectrodeChanged));
    retval.add(const SizedBox(height: 10));

    /// Зоны стимуляции
    retval.add(_buildTextLabel(S.of(context).areasStimulation));
    retval.add(_buildTextField(
        _textAreases, S.of(context).InputStimulAreases, _onAreasesChanged));
    retval.add(const SizedBox(height: 10));

    /// Рекомендации
    retval.add(_buildTextLabel(S.of(context).recommendationsForProcedure));
    retval.add(_buildTextField(_textRecomend, S.of(context).InputRecomendations,
        _onRecomendationChanged));
    retval.add(const SizedBox(height: 20));

    retval.add(_buildTextLabel(S.of(context).Stages));

    return retval;
  }

  List<Widget> _buildStagesTiles(BuildContext context) {
    List<Widget> retval = [];
    for (int i = 0; i < _program.stagesCount(); ++i) {
      retval.add(EditStageTitle(
        stage: _program.stage(i),
        onTap: () async {
          setState(() {
            _idxSelStage = i;
          });
        },
        isSelected: i == _idxSelStage,
      ));
      if (i < _program.stagesCount() - 1) {
        retval.add(const SizedBox(height: 6));
      }
    }
    return retval;
  }

  List<Widget> _buildStage(BuildContext context) {
    List<Widget> retval = [];

    if (_idxSelStage >= 0 && _idxSelStage < _program.stagesCount()) {
      /// Комментарий к этапу
      retval.add(_buildTextLabel('Название этапа'));
      retval.add(_buildTextField(
          _textStageName, 'Введите название этапа', _onStageNameChanged));
      retval.add(const SizedBox(height: 10));

      /// Длительность этапа
      retval.add(_buildTextLabel('Длительность этапа'));
      retval.add(const SizedBox(height: 10));
      retval.add(
          _buildTextTimeField(_textStageDuration, '', _onStageDurationChanged));
      retval.add(const SizedBox(height: 10));

      /// Заполнение полей
      _textStageName.text = _program.stage(_idxSelStage).comment;
      _textStageDuration.text =
          getTimeBySecCount(_program.stage(_idxSelStage).duration ~/ 1000);

      /// Поля ввода параметров воздействия
      retval.add(
        ParamsWidget(
          isAm: _program.stage(_idxSelStage).isAm,
          onAmChanged: _onAmChanged,
          amMode: _program.stage(_idxSelStage).amMode,
          onAmModeChanged: _onAmModeChanged,
          isFm: _program.stage(_idxSelStage).isFm,
          onFmChanged: _onFmChanged,
          freq: _program.stage(_idxSelStage).frequency,
          onFreqChanged: _onFreqChanged,
          intensivity: _program.stage(_idxSelStage).intensivity,
          onIntensivityChanged: _onIntensivityChanged,
          colorsStyle: ParamsColorsStyle.pcsYellow,
        ),
      );
    }

    return retval;
  }

  void _onAmChanged(bool isAm) {

  }

  void _onAmModeChanged(AmMode amMode) {

  }

  void _onFmChanged(bool isFm) {

  }

  void _onFreqChanged(double freq) {

  }

  void _onIntensivityChanged(Intensivity intensivity) {

  }
}
