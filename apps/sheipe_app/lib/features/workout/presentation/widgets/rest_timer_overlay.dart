import 'dart:async';
import 'package:flutter/material.dart';

/// A simple countdown overlay used during an active workout. The widget owns
/// a Timer and rebuilds every second; on completion it auto-dismisses via
/// [onComplete]. Skip dismisses immediately.
class RestTimerOverlay extends StatefulWidget {
  const RestTimerOverlay({
    super.key,
    required this.seconds,
    required this.onComplete,
    required this.onSkip,
  });

  final int seconds;
  final VoidCallback onComplete;
  final VoidCallback onSkip;

  @override
  State<RestTimerOverlay> createState() => _RestTimerOverlayState();
}

class _RestTimerOverlayState extends State<RestTimerOverlay> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _remaining--);
      if (_remaining <= 0) {
        _timer?.cancel();
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_remaining}s',
              style: const TextStyle(fontSize: 64, color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextButton(onPressed: widget.onSkip, child: const Text('Skip', style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
