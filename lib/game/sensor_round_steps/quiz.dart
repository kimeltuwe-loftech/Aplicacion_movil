import 'dart:async';
import 'package:flutter/material.dart';

// import '../../globals/game_rounds.dart';

class MultipleChoiceStep extends StatefulWidget {
  final VoidCallback onNext;
  final String question;
  final List<String> options;
  final int correctIndex;

  const MultipleChoiceStep({
    super.key,
    required this.onNext,
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  @override
  State<MultipleChoiceStep> createState() => _MultipleChoiceStepState();
}

class _MultipleChoiceStepState extends State<MultipleChoiceStep> {
  int? _selectedIndex;
  bool _isCorrect = false;

  bool _lockedOut = false;
  int _secondsLeft = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startLockout() {
    _timer?.cancel();
    setState(() {
      _lockedOut = true;
      _secondsLeft = 10;
      _selectedIndex = null; // hide what they picked
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() {
          _lockedOut = false;
          _secondsLeft = 0;
        });
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  void _onPick(int index) {
    if (_lockedOut || _isCorrect) return;

    final right = index == widget.correctIndex;

    if (right) {
      setState(() {
        _selectedIndex = index;
        _isCorrect = true;
      });
    } else {
      _startLockout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Pregunta',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Text(
                  widget.question,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),

                if (_isCorrect)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        '¡Correcto!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  )
                else if (_lockedOut)
                  Text(
                    'Intenta de nuevo en $_secondsLeft s',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  )
                else
                  const SizedBox.shrink(),

                const SizedBox(height: 18),

                Column(
                  children: List.generate(widget.options.length, (i) {
                    final isSelected = _selectedIndex == i;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (_lockedOut || _isCorrect)
                              ? null
                              : () => _onPick(i),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.options[i],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              if (isSelected && _isCorrect)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 22),

                if (_isCorrect)
                  ElevatedButton(
                    onPressed: widget.onNext,
                    child: const Text('Next'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
