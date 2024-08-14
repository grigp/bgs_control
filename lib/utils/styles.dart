import 'package:flutter/material.dart';

final ButtonStyle controlButtonStylePrimary = ElevatedButton.styleFrom(
  foregroundColor: Colors.white,
  backgroundColor: Colors.teal.shade900,
  minimumSize: const Size(350, 55),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
  ),
);

final ButtonStyle controlButtonStyleSecondary = ElevatedButton.styleFrom(
  foregroundColor: Colors.teal.shade500,
  backgroundColor: Colors.teal.shade50,
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

ButtonStyle messageButtonStylePrimary() {
  return TextButton.styleFrom(
    backgroundColor: Colors.teal.shade100,
    foregroundColor: Colors.teal.shade900,
  );
}

ButtonStyle messageButtonStyleSecondary() {
  return TextButton.styleFrom(
    backgroundColor: Colors.teal.shade50,
    foregroundColor: Colors.teal.shade900,
  );
}

ButtonStyle deleteDeviceButtonStyle(){
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.teal.shade50,
    foregroundColor: Colors.teal.shade900,
  );
}
