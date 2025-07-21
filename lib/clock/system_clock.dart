import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SystemClock extends StatefulWidget {
  const SystemClock({super.key});

  @override
  State<SystemClock> createState() => _SystemClockState();
}

class _SystemClockState extends State<SystemClock> {
  late String _timeString;

  @override
  void initState() {
    super.initState();
    _timeString = _formatTime(DateTime.now());
    _updateTime();
  }

  void _updateTime() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _timeString = _formatTime(DateTime.now()));
      }
    });
  }

  String _formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeString,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}