import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/domain/entities/auth_entities.dart';

class Location extends StatefulWidget {
  final User user;
  const Location({super.key, required this.user});
  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.user.location.isNotEmpty ? widget.user.location : 'Beirut';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Location",
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
            fontSize: 14,
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
              dropdownColor: theme.colorScheme.surface,
              icon: Icon(Icons.keyboard_arrow_down, color: primaryColor),
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 16,
                fontFamily: "Saira",
              ),
              borderRadius: BorderRadius.circular(12),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedValue = newValue;
                    widget.user.location = newValue;
                  });
                }
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
                      Icon(Icons.location_on_outlined, color: primaryColor, size: 18),
                      const SizedBox(width: 12),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
