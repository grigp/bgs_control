import 'package:bgs_control/repositories/logger/communication_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_viewer/flutter_text_viewer.dart';
import 'package:get_it/get_it.dart';

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
    );
  }

  String formatLog(){
    String retval = '';
    var lines = GetIt.I<CommunicationLogger>().get();
    for (int i = 0; i < lines.length; ++i){
      retval = '$retval${lines[i]}\n';
    }
    return retval;
  }
}
