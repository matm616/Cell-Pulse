import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _numericInputFormatter = TextInputFormatter.withFunction(
  (oldValue, newValue) {
    return RegExp(r'^\d*\.?\d*$').hasMatch(newValue.text)
        ? newValue
        : oldValue;
  },
);

class QuickCalc extends StatefulWidget {
  const QuickCalc({super.key});

  @override
  State<QuickCalc> createState() => _QuickCalcState();
}

class _QuickCalcState extends State<QuickCalc> {
  final _capacityController = TextEditingController();
  final _resistanceController = TextEditingController();
  final _cRatingController = TextEditingController();
  String? _result;

  @override
  void dispose() {
    _capacityController.dispose();
    _resistanceController.dispose();
    _cRatingController.dispose();
    super.dispose();
  }

  void _checkCRating() {
    final capacityMah = double.tryParse(_capacityController.text);
    final resistanceMohm = double.tryParse(_resistanceController.text);
    final cRating = double.tryParse(_cRatingController.text);

    if (capacityMah == null || resistanceMohm == null) {
      setState(() {
        _result = 'Enter valid capacity and average cell IR values.';
      });
      return;
    }

    final calculatedC = 2500 / (sqrt(capacityMah * resistanceMohm));

    var ratingResult = 0.0;

    if (cRating != null) {
      ratingResult = (calculatedC / cRating) * 100;
    }

    // Add the C-rating calculation here using the parsed values.
    final optionalRatingMessage = cRating != null
        ? '~${ratingResult.toInt()}% of the advertised C rating'
        : '';
    setState(() {
      _result = 'Calculated C-rating: ${calculatedC.toStringAsFixed(1)}'
          '\nEstimated max continuous current: ~${(calculatedC * capacityMah / 1000).toInt()} A'
          '\n$optionalRatingMessage ';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 96,
                  child: TextField(
                    controller: _capacityController,
                    style: const TextStyle(fontSize: 32),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [_numericInputFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Capacity',
                      labelStyle: TextStyle(fontSize: 22),
                      floatingLabelStyle: TextStyle(fontSize: 22),
                      suffixText: 'mAh',
                      suffixStyle: TextStyle(fontSize: 24),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 96,
                  child: TextField(
                    controller: _resistanceController,
                    style: const TextStyle(fontSize: 32),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [_numericInputFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Average cell IR',
                      labelStyle: TextStyle(fontSize: 22),
                      floatingLabelStyle: TextStyle(fontSize: 22),
                      suffixText: 'mΩ',
                      suffixStyle: TextStyle(fontSize: 24),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 96,
                  child: TextField(
                    controller: _cRatingController,
                    style: const TextStyle(fontSize: 32),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [_numericInputFormatter],
                    decoration: const InputDecoration(
                      labelText: 'Label C Rating (optional)',
                      labelStyle: TextStyle(fontSize: 22),
                      floatingLabelStyle: TextStyle(fontSize: 22),
                      suffixText: 'C',
                      suffixStyle: TextStyle(fontSize: 24),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'IR should be measured at room temperature, or at least '
                    'at the same temperature as another battery if '
                    'comparing their values',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 64,
                  child: ElevatedButton(
                    onPressed: _checkCRating,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 22),
                    ),
                    child: const Text('Check C Rating'),
                  ),
                ),
                if (_result != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    _result!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}