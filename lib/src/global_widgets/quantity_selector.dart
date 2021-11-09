import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Enum to manage the possible action to increase or decrease
enum SelectorType { decrease, increase, both }

class QuantitySelector extends StatefulWidget {
  const QuantitySelector({Key? key, required this.stock}) : super(key: key);

  // Stock of the product
  final int stock;

  @override
  QuantitySelectorState createState() => QuantitySelectorState();
}

class QuantitySelectorState extends State<QuantitySelector> {
  late Timer _timer;
  int _currentQuantity = 1;
  SelectorType _selectorType = SelectorType.increase;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          getActionButton(Icons.remove, (int timerTick) {
            if (_currentQuantity > 1) {
              setState(() {
                _currentQuantity = _currentQuantity - timerTick;
                _selectorType = SelectorType.both;
              });
            }
            if (_currentQuantity <= 1) {
              setState(() {
                _currentQuantity = 1;
                _selectorType = SelectorType.increase;
              });
            }
          }, type: SelectorType.values[0]),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Text(
              _currentQuantity.toString(),
              style: TextStyle(fontSize: 12),
            ),
          ),
          getActionButton(Icons.add, (int timerTick) {
            if (widget.stock > _currentQuantity) {
              setState(() {
                _currentQuantity = _currentQuantity + timerTick;
                _selectorType = SelectorType.both;
              });
            }

            if (_currentQuantity >= widget.stock) {
              setState(() {
                _currentQuantity = widget.stock;
                _selectorType = SelectorType.decrease;
              });
            }
          }, type: SelectorType.values[1]),
        ],
      ),
    );
  }

  Widget getActionButton(IconData icon, void Function(int timerTick) onTap,
      {required SelectorType type}) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
          onTap(timer.tick);
        });
      },
      onTapCancel: () {
        _timer.cancel();
      },
      onTapUp: (TapUpDetails details) {
        _timer.cancel();
      },
      onTap: () {
        onTap(1);
      },
      child: Container(
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          color: widget.stock == 1
              ? Colors.grey.shade300
              : _selectorType == type || _selectorType == SelectorType.both
                  ? Colors.white
                  : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          icon,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  int getQuantity() {
    return _currentQuantity;
  }
}
