import 'package:flutter/material.dart';

final ButtonStyle controlButtonStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: Colors.teal.shade900,
  minimumSize: const Size(350, 55),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
  ),
);

final ButtonStyle deviceListItemStyle = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: Colors.teal.shade900,
  minimumSize: const Size(300, 55),
  // shape: const RoundedRectangleBorder(
  //   borderRadius: BorderRadius.all(Radius.circular(5)),
  // ),
);
