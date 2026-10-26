import 'package:bgs_control/features/hist_seances_screen/widgets/seance_title.dart';
import 'package:bgs_control/features/uikit/texel_button.dart';
import 'package:bgs_control/repositories/database/db_defines.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../assets/colors/colors.dart';
import '../../../generated/l10n.dart';
import '../../../repositories/database/db_provider.dart';
import '../../../utils/baseutils.dart';
import '../../uikit/widgets/back_screen_button.dart';

class HistSeancesScreen extends StatefulWidget {
  const HistSeancesScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<HistSeancesScreen> createState() => _HistSeancesScreenState();
}

class _HistSeancesScreenState extends State<HistSeancesScreen> {
  List<RecordSeance> _seances = [];
  bool _readed = false;
  String _uidHandler = '';
  DateTime _dtc = DateTime(2000, 1, 1, 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    _dtc = DateTime(2000, 1, 1, 0, 0, 0);

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
            if (_readed)
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverList.builder(
                      itemCount: _seances.length,
                      itemBuilder: (context, index) {
                        return _buildTestTitle(
                            context, _seances.length - index - 1);
                      },
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _readSeancesList();

    _uidHandler = GetIt.I<DbProvider>().addHandler(onDbChange);
  }

  @override
  void dispose() {
    GetIt.I<DbProvider>().removeHandler(_uidHandler);
    super.dispose();
  }

  /// Возврвщает тест для списка тестов
  Widget _buildTestTitle(BuildContext context, int index) {
    if (_seances[index].uid != '') {
      return _getSeanceTitle(context, index);
    } else {
      return _getDataDivider(_seances[index].dt);
    }
  }

  /// Возвращает разделитель дат
  Widget _getDataDivider(DateTime dt) {
    return Container(
      padding: const EdgeInsets.only(
        top: 5,
        bottom: 0,
        left: 10,
        right: 10,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '${pdt(dt.day)}:${pdt(dt.month)}:${pdt(dt.year)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          textScaler: const TextScaler.linear(1.0),
        ),
      ),
    );
  }

  /// Возвращает заголовок теста
  Widget _getSeanceTitle(BuildContext context, int index) {
    return SeanceTitle(
      seance: _seances[index],
      isLast: false,
      //index == _tests.length - 1,
      onSelect: (RecordSeance test) async {
      },
      onDelete: (RecordSeance test) async {
        final bool? isDelete = await _askDeleteTest(test.dt);
        if (isDelete!) {
          GetIt.I<DbProvider>().deleteSeance(test.uid);
        }
      },
    );
  }

  void _readSeancesList() async {
    /// Прочитаем
    _seances = await GetIt.I<DbProvider>().getListSeances();

    /// Вставим элементы, соотвествующие смене дат
    if (_seances.isNotEmpty) {
      var dtc = DateTime(2000, 1, 1, 0, 0, 0);

      for (int i = _seances.length - 1; i >= 0; --i) {
        var dt = _seances[i].dt;
        if (dt.day != dtc.day || dt.month != dtc.month || dt.year != dtc.year) {
          _seances.insert(
            i + 1,
            RecordSeance(
              uid: '',
              dt: _seances[i].dt,
              duration: _seances[i].duration,
              max: _seances[i].max,
              average: _seances[i].average,
              comment: _seances[i].comment,
            ),
          );
          dtc = dt;
        }
      }
    }

    /// Оповестим виджет
    setState(() {
      _readed = true;
    });
  }

  /// Обработка сообщения об изменениив БД
  void onDbChange(DBEvents event, String testUid) {
    _readSeancesList();
  }

  Future<bool?> _askDeleteTest(DateTime dt) async {
    var sDelTest = S.of(context).delSeance;
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          '$sDelTest\n${pdt(dt.day)}.${pdt(dt.month)}.${dt.year} ${pdt(dt.hour)}:${pdt(dt.minute)}:${pdt(dt.second)}?',
          textScaler: const TextScaler.linear(1.0),
        ),
        actions: <Widget>[
          TexelButton.accent(
            onPressed: () {
              Navigator.pop(context, false);
            },
            text: S.of(context).no,
            width: 120,
          ),
          TexelButton.secondary(
            onPressed: () {
              Navigator.pop(context, true);
            },
            text: S.of(context).yes,
            width: 120,
          ),
        ],
      ),
    );
  }
}
