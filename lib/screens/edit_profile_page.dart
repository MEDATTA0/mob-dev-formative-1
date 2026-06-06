import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(
    text: "John Doe",
  );

  final emailController = TextEditingController(
    text: "john.doe@alustudent.com",
  );

  final bioController = TextEditingController(
    text: "Passionate about technology and leadership.",
  );

  String selectedCampus = "Kigali";

  final campuses = [
    "Kigali",
    "Mauritius",
  ];

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.dispose();
  }

  InputDecoration fieldDecoration(
    BuildContext context,
    String label,
  ) {
    final theme = Theme.of(context);

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
      ),
      filled: true,
      fillColor: theme.colorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
    );
  }

  void saveProfile() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully"),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: theme.colorScheme.primary,
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.colorScheme.primary,
                        width: 3,
                      ),
                    ),
                    child: const CircleAvatar(
                      radius: 55,
                      backgroundImage: NetworkImage(
                        "https://picsum.photos/200",
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Image picker coming soon",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              TextFormField(
                controller: nameController,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                ),
                decoration: fieldDecoration(
                  context,
                  "Full Name",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: emailController,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                ),
                decoration: fieldDecoration(
                  context,
                  "Email",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: selectedCampus,
                dropdownColor: theme.colorScheme.surface,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                ),
                decoration: fieldDecoration(
                  context,
                  "Campus",
                ),
                items: campuses.map((campus) {
                  return DropdownMenuItem<String>(
                    value: campus,
                    child: Text(
                      campus,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCampus = value!;
                  });
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: bioController,
                maxLines: 4,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                ),
                decoration: fieldDecoration(
                  context,
                  "Bio",
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: saveProfile,
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}