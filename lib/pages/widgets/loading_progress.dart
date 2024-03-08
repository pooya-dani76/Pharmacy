import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 50,
      width: 50,
      child: LoadingIndicator(
          indicatorType: Indicator.ballPulseSync,
          colors: [Colors.red, Colors.blue, Colors.green],
          strokeWidth: 5,
          backgroundColor: Colors.transparent,
          pathBackgroundColor: Colors.black),
    );
  }
}
