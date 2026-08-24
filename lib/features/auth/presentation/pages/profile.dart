import 'package:flutter/material.dart';
import 'package:woodyz/features/auth/presentation/widgets/profile_widgets.dart';
import 'package:woodyz/features/auth/presentation/providers/auth_provider.dart';
import 'package:woodyz/features/auth/presentation/pages/settings.dart';

class Profile extends StatefulWidget {
  final Customer? c;
  final Artisan? a;
  const Profile({super.key, this.c, this.a});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late dynamic u;
  @override
  void initState() {
    if(widget.c == null){
      u = widget.a as Artisan;
    }
    else{
      u = widget.c as Customer;
    }
    super.initState();
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
                    PImage(image_url: u.avatarUrl),
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
                      const SizedBox(height: 15),
                      _buildProfileRow(context, "Address", (u as Customer).address ?? "N/A"),
                    ] else if (u is Artisan) ...[
                      _buildProfileRow(context, "Bio", (u as Artisan).bio ?? "N/A"),
                      const SizedBox(height: 15),
                      _buildProfileRow(context, "Address", (u as Artisan).address ?? "N/A"),
                      const SizedBox(height: 15),
                      Text(
                        "Skills", 
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 15, 
                          color: theme.colorScheme.primary, 
                          fontFamily: "Saira",
                        ),
                      ),
                      const SizedBox(height: 5),
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
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label, 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontFamily: "Saira", 
                fontSize: 15, 
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value, 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontFamily: "Saira", 
                fontSize: 15, 
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ]
    );
  }
}
