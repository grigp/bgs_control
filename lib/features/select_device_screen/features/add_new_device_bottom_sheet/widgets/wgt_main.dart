import 'package:bgs_control/repositories/bgs_list/bgs_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class WgtMain extends StatelessWidget {
  const WgtMain({
    super.key,
    required this.list,
  });

  final List<String> list;

  @override
  Widget build(BuildContext context) {
    var listRegistred = GetIt.I<BgsList>().getList();
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Добавить устройство',
              style: TextStyle(
                fontSize: 26,
                color: Colors.teal.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            ListView.separated(
              shrinkWrap: true,
              itemCount: list.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 20),
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
                          }
                        },
                        child: Text(
                          list[index],
                          style: listRegistred.contains(list[index])
                              ? TextStyle(
                                  fontSize: 24,
                                  color: Colors.teal.shade700,
                                )
                              : TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.teal.shade900,
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
