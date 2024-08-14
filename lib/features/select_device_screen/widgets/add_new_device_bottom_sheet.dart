import 'package:bgs_control/repositories/bgs_connect/ble_service.dart';
import 'package:bgs_control/repositories/bgs_list/bgs_list.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AddNewDeviceBottomSheet extends StatefulWidget {
  const AddNewDeviceBottomSheet({
    super.key,
  });

  @override
  State<AddNewDeviceBottomSheet> createState() => _AddNewDeviceBottomSheet();
}

class _AddNewDeviceBottomSheet extends State<AddNewDeviceBottomSheet> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    try {
      GetIt.I<BleService>().scanningStart(update);
    } catch (e) {
      //      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    }
    onScanPressed();
  }

  void update() async {
    //  это не надо скорее всего
    if (mounted) {
      setState(() {}); //  это не надо скорее всего
    }
  }

  Future<void> onScanPressed() async {
    try {
      await GetIt.I<BleService>().bleStartScan();
    } catch (e) {
      // Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
      //     success: false);
    }
    setState(() {}); //  это не надо скорее всего
  }

  Widget wgtMain(BuildContext context, List<String> list) {
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
                        child: Text(list[index],
                            style: listRegistred.contains(list[index])
                                ? TextStyle(
                                    fontSize: 24,
                                    color: Colors.teal.shade700,
                                  )
                                : TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.teal.shade900,
                                  )),
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

  Widget wgtWait(BuildContext context) {
    return SizedBox(
      height: 500,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.teal,
                  ),
                ),
              ),
              Text(
                'Поиск стимуляторов',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.teal.shade900,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> list = GetIt.I<BleService>()
        .scanResultList
        .value
        .map(
          (r) => r.device.advName,
        )
        .toList();

    return (list.isNotEmpty) ? wgtMain(context, list) : wgtWait(context);
  }
}
