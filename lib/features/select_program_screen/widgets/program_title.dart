
import 'package:bgs_control/repositories/methodic_programs/model/methodic_program.dart';
import 'package:flutter/material.dart';

class ProgramTitle extends StatefulWidget{
  const ProgramTitle({
    super.key,
    required this.program,
    required this.onTap,
  });

  final MethodicProgram program;
  final VoidCallback? onTap;

  @override
  State<ProgramTitle> createState() => _ProgramTitleState();
}

class _ProgramTitleState extends State<ProgramTitle> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            widget.onTap?.call();
          },
          child: _buildTitle(context, theme),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context, ThemeData theme) {
    // if (widget.program.device.platformName.isNotEmpty) {
      return Row(
//        mainAxisAlignment: MainAxisAlignment.start,
//        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
//            width: double.infinity,
            height: 80,
            margin: const EdgeInsets.only(
              left: 0,
              top: 10,
              right: 10,
              bottom: 10,
            ),
            child: Row(
                children: [
                  Image.asset('lib/assets/icons/programs/${widget.program.image}'),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.program.title,
                        style: theme.textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        width: 300, //double.infinity,
                        height: 50,
                        child: Text(
                          widget.program.description,
                          style: theme.textTheme.labelSmall,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                        ),
                      ),
                      // Text(
                      //   widget.program.description,
                      //   style: theme.textTheme.labelSmall,
                      //   overflow: TextOverflow.ellipsis,
                      //   maxLines: 2,
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          // _buildConnectButton(context),
        ],
      );
    // } else {
    //   return Text(widget.program.device.remoteId.str);
    // }
  }
}