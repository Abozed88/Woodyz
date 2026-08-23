import 'package:flutter/material.dart';
import 'package:woodyz/features/products/domain/entities/product_entity.dart';

class ChooseCategory extends StatefulWidget {
  final Product p;
  const ChooseCategory({super.key, required this.p});
  @override
  State<ChooseCategory> createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Category:", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
        const SizedBox(width: 15,),
        DropdownButton<String>(
          value: selectedValue,
          borderRadius: BorderRadius.circular(12),
          dropdownColor: const Color.fromRGBO(33, 33, 32, 1),
          icon: const Icon(
            Icons.arrow_drop_down, color: Color.fromRGBO(252, 184, 25, 1),),
          alignment: Alignment.center,
          iconSize: 30,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),
          onChanged: (String? newValue) {
            setState(() {
              if (newValue != null) {
                selectedValue = newValue;
                widget.p.category = newValue;
              }
            });
          },
          items: <String>[
            'Furniture',
            'Decor',
            'Bedroom',
            'Bowls',
            'Kitchenware',
            'Outdoor',
            'Art',
            'Toys',
            'Others'
          ]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(fontFamily: "Saira"),),
            );
          }).toList(),
        )
      ],
    );
  }
}

class NumberIndicator extends StatefulWidget {
  final Product p;
  const NumberIndicator({super.key, required this.p});

  @override
  _NumberIndicatorState createState() => _NumberIndicatorState();
}

class _NumberIndicatorState extends State<NumberIndicator> {
  double _value = 1;
  late TextEditingController controller = TextEditingController(text: "1");

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_drop_up, color: Color.fromRGBO(252, 184, 25, 1)),
          onPressed: () {
            setState(() {
              if (_value < 50000) _value++;
              widget.p.price = _value;
              controller.text = _value.toString();
            });
          },
        ),

        SizedBox(
          width: 80,
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 5),
            ),
            controller: controller,
            onChanged: (v) {
              double? newValue = double.tryParse(v);
              if (newValue != null) {
                _value = newValue;
                widget.p.price = _value;
              }
            },
          ),
        ),

        IconButton(
          icon: const Icon(Icons.arrow_drop_down, color: Color.fromRGBO(252, 184, 25, 1)),
          onPressed: () {
            setState(() {
              if (_value > 0) _value--;
              widget.p.price = _value;
              controller.text = _value.toString();
            });
          },
        ),
      ],
    );
  }
}
