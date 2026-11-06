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
import '../../uikit/texel_button.dart';
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
                            onPressed: _addStage,
                            child: Text(
                              S.of(context).addStage,
                              style: const TextStyle(
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

  TextField _buildTextFieldSubmit(TextEditingController contrroller, String hintText,
      ValueChanged<String> onSubmited) {
    return TextField(
      controller: contrroller,
      style: const TextStyle(color: Colors.black, fontSize: 20),
      decoration: editProgramDecoration(hintText),
      onSubmitted: onSubmited,
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
      decoration: editProgramDecorationTime(context),
      onChanged: onChanged,
      keyboardType: TextInputType.number,
      // Валидация введенных данных
      validator: (value) {
        if (value == null || value.isEmpty) {
          return S.of(context).InputTime;
        }
        if (value.length < 5) {
          return S.of(context).InputTimeTotal_min_sec;
        }

        // Разделяем строку на минуты и секунды
        final parts = value.split(':');
        final minutes = int.tryParse(parts[0]) ?? 0;
        final seconds = int.tryParse(parts[1]) ?? 0;

        // Секунд не может быть больше 59
        if (seconds >= 60) {
          return S.of(context).SecondsOutOfBounds;
        }
        // Опционально: ограничение на минуты, если нужно
        if (minutes > 99) {
          return S.of(context).MinutesOutOfBound;
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
        onDelete: _deleteStage,
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
      retval.add(_buildTextLabel(S.of(context).stageName));
      retval.add(_buildTextFieldSubmit(
          _textStageName, S.of(context).InputStageName, _onStageNameSubmited));
      retval.add(const SizedBox(height: 10));

      /// Длительность этапа
      retval.add(_buildTextLabel(S.of(context).stageDuration));
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

  void _addStage() {
    setState(() {
      _program.newStage();
      _idxSelStage = _program.stagesCount() - 1;
    });
  }

  void _deleteStage() {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          S.of(context).askDeleteStageFromProgram(_program.stage(_idxSelStage).comment),
        ),
        actions: <Widget>[
          TexelButton.accent(
            onPressed: () => Navigator.pop(context, false),
            text: S.of(context).no,
            width: 120,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: TextButton(
              onPressed: () {
                setState(() {
                  _program.deleteStage(_idxSelStage);
                });
                Navigator.pop(context, true);
              },
              child: Text(
                S.of(context).yes,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onNameChanged(String value) {
    _program.title = value;
  }

  void _onDescriptionChanged(String value) {
    _program.description = value;
  }

  void _onElectrodeChanged(String value) {
    _program.electrods = value;
  }

  void _onAreasesChanged(String value) {
    _program.areases = value;
  }

  void _onRecomendationChanged(String value) {
    _program.recomendations = value;
  }

  void _onStageNameSubmited(String value) {
    if (_idxSelStage >= 0) {
      setState(() {
        _program.stage(_idxSelStage).comment = value;
      });
    }
  }

  void _onStageDurationChanged(String value) {
    if (_idxSelStage >= 0) {
      _program.stage(_idxSelStage).duration = getSecCountByString(value);
    }
  }

  void _onAmChanged(bool isAm) {
    if (_idxSelStage >= 0) {
      _program.stage(_idxSelStage).isAm = isAm;
    }
  }

  void _onAmModeChanged(AmMode amMode) {
    if (_idxSelStage >= 0) {
      _program.stage(_idxSelStage).amMode = amMode;
    }
  }

  void _onFmChanged(bool isFm) {
    if (_idxSelStage >= 0) {
      _program.stage(_idxSelStage).isFm = isFm;
    }
  }

  void _onFreqChanged(double freq) {
    if (_idxSelStage >= 0) {
      _program.stage(_idxSelStage).frequency = freq;
    }
  }

  void _onIntensivityChanged(Intensivity intensivity) {
    if (_idxSelStage >= 0) {
      _program.stage(_idxSelStage).intensivity = intensivity;
    }
  }
}
