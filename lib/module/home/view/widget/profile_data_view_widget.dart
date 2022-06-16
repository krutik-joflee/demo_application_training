import 'package:flutter/material.dart';

class ProfileDataViewWidget extends StatelessWidget {
  const ProfileDataViewWidget(
      {Key? key, required this.value, required this.title})
      : super(key: key);
  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
