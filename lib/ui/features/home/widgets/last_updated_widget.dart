import 'package:flutter/material.dart';
import 'package:weather_app/core/utils/date_formatters.dart';

class LastUpdatedWidget extends StatelessWidget {
  const LastUpdatedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(color: Colors.blueAccent),
      alignment: Alignment.centerRight,
      child: Text(
        getLastUpdated(DateTime.now()),
        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
