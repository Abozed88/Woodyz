import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/widgets/profile_widgets.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/features/auth/presentation/pages/settings.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  final Customer? c;
  final Artisan? a;
  const Profile({super.key, this.c, this.a});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late dynamic u;
  String? _editingField;
  final TextEditingController _editController = TextEditingController();
  bool _isUpdating = false;
  bool _isUpdatingAvatar = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  Future<void> _handleSave(String label) async {
    final newValue = _editController.text.trim();
    if (newValue.isEmpty && label != "Bio") return; // Allow empty bio

    setState(() => _isUpdating = true);
    
    final success = await AuthProvider(context: context).updateUserField(
      userId: u.id,
      role: u.role,
      label: label,
      value: newValue,
    );

    if (success && mounted) {
      setState(() {
        if (label == "Phone") u.phone = newValue;
        if (label == "Address") u.address = newValue;
        if (label == "Bio") u.bio = newValue;
        if (label == "Location") u.location = newValue;
        if (label == "Skills") {
          (u as Artisan).skills = newValue.split(',').map((s) => s.trim()).toList();
        }
        _editingField = null;
        _isUpdating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$label updated successfully!")),
      );
    } else if (mounted) {
      setState(() => _isUpdating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update field.")),
      );
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      setState(() => _isUpdatingAvatar = true);
      
      final String? newUrl = await AuthProvider(context: context).updateAvatar(
        File(image.path), 
        u.id,
      );

      if (newUrl != null && mounted) {
        setState(() {
          u.avatarUrl = newUrl;
          _isUpdatingAvatar = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile image updated successfully!")),
        );
      } else if (mounted) {
        setState(() => _isUpdatingAvatar = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile image.")),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _isUpdatingAvatar = false);
      debugPrint("Pick image error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    u = widget.a ?? widget.c;
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 50,),
                    Stack(
                      children: [
                        PImage(image_url: u.avatarUrl),
                        if (_isUpdatingAvatar)
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black26,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(color: Colors.white),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _isUpdatingAvatar ? null : _pickAndUploadAvatar,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(color: theme.colorScheme.surface, width: 2),
                              ),
                              child: Icon(
                                Icons.edit, 
                                color: theme.colorScheme.onPrimary, 
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      u.fullName, 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontFamily: "Saira", 
                        fontSize: 25, 
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      u.role == "customer" ? "Customer" : "Artisan", 
                      style: TextStyle(color: theme.colorScheme.primary, fontFamily: "Saira"),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (u is Customer) ...[
                      _buildProfileRow(context, "Phone", u.phone ?? "N/A"),
                    ] else if (u is Artisan) ...[
                      _buildProfileRow(context, "Bio", u.bio ?? "N/A"),
                      const SizedBox(height: 15),
                      _buildProfileRow(context, "Address", u.address ?? "N/A"),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Skills", 
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              fontSize: 15, 
                              color: theme.colorScheme.primary, 
                              fontFamily: "Saira",
                            ),
                          ),
                          if (_editingField == "Skills")
                            IconButton(
                              onPressed: _isUpdating ? null : () => _handleSave("Skills"),
                              icon: const Icon(Icons.check_circle, color: Colors.yellow, size: 20),
                            )
                          else
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _editingField = "Skills";
                                  _editController.text = (u as Artisan).skills.join(", ");
                                });
                              },
                              icon: Icon(Icons.edit, color: theme.colorScheme.onSurface.withOpacity(0.5), size: 18),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      if (_editingField == "Skills")
                         TextField(
                          controller: _editController,
                          autofocus: true,
                          style: TextStyle(fontFamily: "Saira", color: theme.colorScheme.onSurface),
                          decoration: InputDecoration(
                            hintText: "Skill1, Skill2...",
                            hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.3)),
                            border: UnderlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.primary)),
                          ),
                        )
                      else
                        Wrap(
                          spacing: 8,
                          children: (u as Artisan).skills.map((skill) => Chip(
                            label: Text(
                              skill, 
                              style: TextStyle(
                                fontSize: 10, 
                                color: theme.brightness == Brightness.dark ? Colors.white : theme.colorScheme.onSurface,
                              ),
                            ),
                            backgroundColor: theme.colorScheme.surface,
                            side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.3)),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          )).toList(),
                        ),
                    ],
                    const SizedBox(height: 15),
                    _buildProfileRow(context, "Location", u.location),
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              const Preferences()
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            }, 
            icon: Icon(Icons.settings, color: theme.colorScheme.onSurface),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final isEditing = _editingField == label;
    final primaryColor = theme.colorScheme.primary;

    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label, 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontFamily: "Saira", 
                fontSize: 15, 
                color: primaryColor,
              ),
            ),
          ),
          Expanded(
            child: isEditing 
              ? (label == "Location" 
                  ? DropdownButtonFormField<String>(
                      value: ['Beirut', 'North', 'Tripoli', 'Baalbek', 'South', 'Nabatieh', 'Mountain'].contains(value) ? value : 'Beirut',
                      dropdownColor: theme.colorScheme.surface,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontFamily: "Saira", 
                        fontSize: 15, 
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                      ),
                      items: <String>[
                        'Beirut',
                        'North',
                        'Tripoli',
                        'Baalbek',
                        'South',
                        'Nabatieh',
                        'Mountain'
                      ].map<DropdownMenuItem<String>>((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _editController.text = newValue;
                        }
                      },
                    )
                  : TextField(
                      controller: _editController,
                      autofocus: true,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontFamily: "Saira", 
                        fontSize: 15, 
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                      ),
                    ))
              : Text(
                  value, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontFamily: "Saira", 
                    fontSize: 15, 
                    color: theme.colorScheme.onSurface,
                  ),
                ),
          ),
          IconButton(
            onPressed: _isUpdating ? null : () {
              if (isEditing) {
                _handleSave(label);
              } else {
                setState(() {
                  _editingField = label;
                  _editController.text = value == "N/A" ? "" : value;
                });
              }
            },
            icon: isEditing 
              ? (_isUpdating 
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.yellow)) 
                  : const Icon(Icons.check_circle, color: Colors.yellow, size: 20))
              : Icon(Icons.edit, color: theme.colorScheme.onSurface.withOpacity(0.5), size: 18),
            constraints: const BoxConstraints(),
            padding: const EdgeInsets.all(8),
          ),
        ]
    );
  }
}
