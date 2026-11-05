import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../assets/colors/colors.dart';
import '../../../generated/l10n.dart';
import '../../../repositories/methodic_programs/model/methodic_program.dart';
import '../../../repositories/methodic_programs/storage/program_storage.dart';
import '../../../utils/baseutils.dart';
import '../../personal_program_edit_screen/view/personal_program_edit_screen.dart';
import '../../select_program_screen/widgets/program_title.dart';
import '../../uikit/widgets/back_screen_button.dart';

/// Экран списка методик, созданных пользователем
class PersonalProgramsScreen extends StatefulWidget {
  const PersonalProgramsScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<PersonalProgramsScreen> createState() => _PersonalProgramsScreenState();
}

class _PersonalProgramsScreenState extends State<PersonalProgramsScreen> {
  bool _isReady = false;
  List<MethodicProgram> _programs = [];
  int _idxSelected = -1;

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
            if (_isReady)
              Expanded(
                child: SafeArea(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 20),
                    shrinkWrap: true,
                    children: <Widget>[
                      ..._buildProgramTiles(context),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 100),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: _addMethod,
              heroTag: 'NewMethod',
              tooltip: S.of(context).addMethod,
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: const Icon(
                Icons.add,
                size: 40,
                color: filledAccentButtonColor,
              ),
            ),
            FloatingActionButton(
              onPressed: _editMethod,
              heroTag: 'EditMethod',
              tooltip: S.of(context).editMethod,
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: const Icon(
                Icons.edit,
                size: 40,
                color: filledAccentButtonColor,
              ),
            ),
            FloatingActionButton(
              onPressed: _delMethod,
              heroTag: 'DelMethod',
              tooltip: S.of(context).deleteMethod,
              foregroundColor: Theme.of(context).colorScheme.primary,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: const Icon(
                Icons.close,
                size: 40,
                color: redDarkColor,
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
    _fillListPrograms();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fillListPrograms() async {
    _programs = GetIt.I<ProgramStorage>().getPrograms();

    setState(() {
      _isReady = true;
    });
  }

  List<Widget> _buildProgramTiles(BuildContext context) {
    return _programs
        .mapIndexed(
          (program, index) => ProgramTitle(
            program: program,
            isLast: index == _programs.length - 1,
            isSelected: (index == _idxSelected)? true : false,
            onTap: () async {
              setState(() {
                _idxSelected = index;
              });
            },
          ),
        )
        .where((ProgramTitle test) => !test.program.isDefault)  /// Только не дефолтные методики
        .toList();
  }

  void _addMethod() async {
    pushScreen(
      context,
      (context, animation, secondaryAnimation) => PersonalProgramEditScreen(
        title: S.of(context).addMethod,
        editMode: EditMode.emAdd,
        progId: '',
      ),
      '/EditMethod',
      ShiftDirection.rightToLeft,
    );
  }

  void _editMethod() async {
    pushScreen(
      context,
      (context, animation, secondaryAnimation) => PersonalProgramEditScreen(
        title: S.of(context).editMethod,
        editMode: EditMode.emEdit,
        progId: _programs[_idxSelected].uid,
      ),
      '/EditMethod',
      ShiftDirection.rightToLeft,
    );
  }

  void _delMethod() async {}
}
