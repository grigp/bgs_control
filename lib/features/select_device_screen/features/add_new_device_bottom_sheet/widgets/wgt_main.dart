import 'package:bgs_control/repositories/bgs_list/bgs_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Добавить устройство',
              style: theme.textTheme.titleMedium, /// TODO(Yasliks): добавить отдельный стиль для боттомШитов
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: list.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!listRegistred.contains(list[index])) {
                              GetIt.I<BgsList>().add(list[index]);
                              Navigator.pop(context);

                              /// Покажем окно предупреждения
                              MaterialPageRoute route = MaterialPageRoute(
                                builder: (context) => const AttentionScreen(
                                  title: 'Предупреждение',
                                ),
                                settings: const RouteSettings(name: '/attention'),
                              );
                              Navigator.of(context).push(route);
                            }
                          },
                          child: Text(
                            list[index],
                            style: listRegistred.contains(list[index])
                                ? theme.textTheme.labelMedium
                                : theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
