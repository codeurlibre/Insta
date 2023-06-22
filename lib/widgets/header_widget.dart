import 'package:flutter/material.dart';

header(context,
    {required String strTitle,
    bool isAppTitle = false,
    disableBackButton = false}) {
  return AppBar(
    iconTheme: const IconThemeData(color: Colors.white),
    automaticallyImplyLeading: disableBackButton ? false : true,
    title: Text(
      isAppTitle ? "Instagram" : strTitle,
      style: TextStyle(color: Colors.white, fontSize: isAppTitle ? 45 : 22),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Colors.transparent,
  );
}
