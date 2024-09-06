import 'dart:io';

import 'package:bgs_control/repositories/logger/communication_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_viewer/flutter_text_viewer.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../uikit/texel_button.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: theme.textTheme.titleMedium,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TextViewerPage(
              textViewer: TextViewer.textValue(
                formatLog(),
                highLightColor: Colors.yellow,
                focusColor: Colors.orange,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Очистить лог?'),
                  actions: <Widget>[
                    TexelButton.accent(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      text: 'Нет',
                      width: 120,
                    ),
                    TexelButton.secondary(
                      onPressed: () {
                        setState(() {
                          GetIt.I<CommunicationLogger>().clear();
                        });
                        Navigator.pop(context, 'Cancel');
                      },
                      text: 'Да',
                      width: 120,
                    ),
                  ],
                ),
              );
            },
            heroTag: 'Clear',
            tooltip: 'Очистить',
            child: const Icon(Icons.delete_forever),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () async {
              final dir = Platform.isAndroid
                  ? await getExternalStorageDirectory()
                  : await getApplicationSupportDirectory();
              /// TODO Если надо будет файл, то раскомментировать
              // print('--------------------${dir?.path}/exchange.log');
              // var f = File('${dir?.path}/exchange.log');
              // await f.writeAsString(formatLog());
              await Share.share(formatLog());
            },
            heroTag: 'Share',
            tooltip: 'Поделиться',
            child: const Icon(Icons.share),
          ),
        ],
      ),
    );
  }

  String formatLog() {
    String retval = '';
    var lines = GetIt.I<CommunicationLogger>().get();
    for (int i = 0; i < lines.length; ++i) {
      retval = '$retval${lines[i]}\n';
    }
    return retval;
  }
}
