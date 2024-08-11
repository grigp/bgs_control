import 'package:bgs_control/repositories/bgs_connect/ble_service.dart';
import 'package:bgs_control/repositories/bgs_list/bgs_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AddNewDeviceBottomSheet extends StatelessWidget {
  const AddNewDeviceBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> list = GetIt.I<BleService>()
        .scanResultList
        .value
        .map(
          (r) => r.device.advName,
        )
        .toList();

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
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          GetIt.I<BgsList>().add(list[index]);
                          Navigator.pop(context);
                        },
                        child: Text(
                          list[index],
                          style: const TextStyle(fontSize: 24),
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
