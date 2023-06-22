import 'package:flutter/material.dart';

import '../widgets/header_widget.dart';

class UploadScreen extends StatefulWidget {
  final Function()? onTap;
  const UploadScreen({super.key, required this.onTap});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar:header (context, strTitle: "Upload"),
      body: Container(
        /*height: double.infinity,
                width: double.infinity,*/
        // padding: const EdgeInsets.only(right: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: widget.onTap,
                icon: const Icon(
                  Icons.add_photo_alternate,
                  size: 90,
                )),
            const Text('Upload Image')
          ],
        ),
      ),
    );
  }
}
