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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Category", 
          style: TextStyle(
            fontSize: 14, 
            color: theme.colorScheme.onSurface.withOpacity(0.7), 
            fontFamily: "Saira",
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1), width: 1.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              dropdownColor: theme.colorScheme.surface,
              icon: Icon(Icons.keyboard_arrow_down, color: primaryColor),
              style: TextStyle(
                fontSize: 16, 
                color: theme.colorScheme.onSurface, 
                fontFamily: "Saira",
              ),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedValue = newValue;
                    widget.p.category = newValue;
                  });
                }
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
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontFamily: "Saira")),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class ChooseStatus extends StatefulWidget {
  final Product p;
  const ChooseStatus({super.key, required this.p});

  @override
  State<ChooseStatus> createState() => _ChooseStatusState();
}

class _ChooseStatusState extends State<ChooseStatus> {
  ProductStatus? selectedValue = ProductStatus.inStock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Availability Status",
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            fontFamily: "Saira",
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1), width: 1.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ProductStatus>(
              value: selectedValue,
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              dropdownColor: theme.colorScheme.surface,
              icon: Icon(Icons.keyboard_arrow_down, color: primaryColor),
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface,
                fontFamily: "Saira",
              ),
              onChanged: (ProductStatus? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedValue = newValue;
                    widget.p.status = newValue;
                  });
                }
              },
              items: ProductStatus.values.map<DropdownMenuItem<ProductStatus>>((ProductStatus value) {
                return DropdownMenuItem<ProductStatus>(
                  value: value,
                  child: Text(value.displayName, style: const TextStyle(fontFamily: "Saira")),
                );
              }).toList(),
            ),
          ),
        ),
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
  late double _value;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    _value = widget.p.price;
    controller = TextEditingController(text: _value.toString());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove_circle_outline, color: primaryColor),
            onPressed: () {
              setState(() {
                if (_value > 0) _value--;
                widget.p.price = _value;
                controller.text = _value.toString();
              });
            },
          ),

          SizedBox(
            width: 80,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold, 
                color: theme.colorScheme.onSurface,
              ),
              cursorColor: primaryColor,
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.zero,
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
            icon: Icon(Icons.add_circle_outline, color: primaryColor),
            onPressed: () {
              setState(() {
                if (_value < 50000) _value++;
                widget.p.price = _value;
                controller.text = _value.toString();
              });
            },
          ),
        ],
      ),
    );
  }
}

class StockIndicator extends StatefulWidget {
  final Product p;
  const StockIndicator({super.key, required this.p});

  @override
  _StockIndicatorState createState() => _StockIndicatorState();
}

class _StockIndicatorState extends State<StockIndicator> {
  late int _value;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    _value = widget.p.stock;
    controller = TextEditingController(text: _value.toString());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove_circle_outline, color: primaryColor),
            onPressed: () {
              setState(() {
                if (_value > 0) _value--;
                widget.p.stock = _value;
                controller.text = _value.toString();
              });
            },
          ),
          SizedBox(
            width: 80,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              cursorColor: primaryColor,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              controller: controller,
              onChanged: (v) {
                int? newValue = int.tryParse(v);
                if (newValue != null) {
                  _value = newValue;
                  widget.p.stock = _value;
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: primaryColor),
            onPressed: () {
              setState(() {
                _value++;
                widget.p.stock = _value;
                controller.text = _value.toString();
              });
            },
          ),
        ],
      ),
    );
  }
}

class AvailabilityToggle extends StatefulWidget {
  final Product p;
  const AvailabilityToggle({super.key, required this.p});

  @override
  State<AvailabilityToggle> createState() => _AvailabilityToggleState();
}

class _AvailabilityToggleState extends State<AvailabilityToggle> {
  late bool _isAvailable;

  @override
  void initState() {
    super.initState();
    _isAvailable = widget.p.isAvailable;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SwitchListTile(

      title: const Text(
        "Is Available",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: "Saira",
        ),
      ),
      subtitle: Text(
        _isAvailable ? "Visible to customers" : "Hidden from search",
        style: TextStyle(
          fontSize: 12,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          fontFamily: "Saira",
        ),
      ),
      value: _isAvailable,
      activeThumbColor: Colors.white,
      activeTrackColor: Colors.green,
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: theme.colorScheme.onSurface.withOpacity(0.1),
      onChanged: (bool value) {
        setState(() {
          _isAvailable = value;
          widget.p.isAvailable = value;
        });
      },
      contentPadding: EdgeInsets.zero,
    );
  }
}
