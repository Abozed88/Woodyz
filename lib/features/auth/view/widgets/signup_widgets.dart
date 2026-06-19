import 'package:flutter/material.dart';
import 'package:woodyz/features/controller/auth_controller.dart';

class TypeRadio extends StatelessWidget {
  final String type;
  final String selectedType;
  final ValueChanged<String?> onChanged;

  const TypeRadio({
    super.key,
    required this.type,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const Color selectedColor = Color(0xFFFCCB25);
    const Color unselectedColor = Color(0xFF383834);
    const Color borderColor = Color(0xFF505050);

    bool isSelected = selectedType == type;
    double width = MediaQuery.of(context).size.width;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: 0.33 * width,
      height: 70,
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
          colors: [Color(0xFFFCCB25), Color(0xFFF2A71B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: isSelected ? null : unselectedColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? selectedColor : borderColor,
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: selectedColor.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ]
            : [],
      ),
      child: Center(
        child: RadioListTile<String>(
          value: type,
          groupValue: selectedType,
          onChanged: onChanged,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                type == "cust" ? Icons.person : Icons.handyman,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                type == "cust" ? "Customer" : "Artisan",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                  letterSpacing: 0.3,
                  fontFamily: "Saira"
                ),
              ),
            ],
          ),
          activeColor: Colors.white,
          controlAffinity: ListTileControlAffinity.trailing,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }
}

class Location extends StatefulWidget {
  final User user;
  const Location({super.key, required this.user});
  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String selectedValue = 'Beirut';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Location:", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: "Saira"),),
        SizedBox(width: 15,),
        DropdownButton<String>(
          value: selectedValue,
          dropdownColor: const Color(0xFF2A2A2A),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFFCC107)),
          iconSize: 28,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: "Saira",
          ),
          underline: Container(
            height: 2,
            color: const Color(0xFFFCC107),
          ),
          borderRadius: BorderRadius.circular(12),
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
              widget.user.location = selectedValue;
            });
          },
          items: <String>[
            'Beirut',
            'North',
            'Tripoli',
            'Baalbek',
            'South',
            'Nabatieh',
            'Mountain'
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFFFCC107), size: 18),
                  const SizedBox(width: 8),
                  Text(value),
                ],
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}

