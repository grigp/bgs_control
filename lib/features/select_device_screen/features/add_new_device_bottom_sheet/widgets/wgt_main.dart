import 'package:bgs_control/assets/colors/colors.dart';
import 'package:bgs_control/repositories/bgs_list/bgs_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../utils/baseutils.dart';
import '../../../../attention_screen/view/attention_screen.dart';

class WgtMain extends StatelessWidget {
  const WgtMain({
    super.key,
    required this.list,
  });

  final List<String> list;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var listRegistred = GetIt.I<BgsList>().getList();
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Row(
              children: [
                Text(
                  S.of(context).addStimulator,
                  style: theme.textTheme.titleMedium,
                  textScaler: const TextScaler.linear(1.0),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: filledSecondaryItemColor,
                      borderRadius: BorderRadius.circular(300),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 0,
            indent: 0,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: list.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox.shrink(),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (!listRegistred.contains(list[index])) {
                      GetIt.I<BgsList>().add(list[index]);
                      Navigator.pop(context);

                      /// Покажем окно предупреждения
                      pushScreen(
                        context,
                        (context, animation, secondaryAnimation) =>
                            AttentionScreen(
                          title: S.of(context).warning,
                        ),
                        '/select',
                        ShiftDirection.rightToLeft,
                      );
                    }
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          children: [
                            Image.asset(
                              'images/device.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                getFullDeviceName(list[index]),
                                overflow: TextOverflow.ellipsis,
                                textScaler: const TextScaler.linear(1.0),
                                style: listRegistred.contains(list[index])
                                    ? theme.textTheme.labelMedium
                                        ?.copyWith(color: Colors.black26)
                                    : theme.textTheme.labelMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        height: 0,
                        indent: 0,
                        thickness: 1,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
