import 'dart:io';
import 'package:flutter/material.dart';
import 'package:assignment1/constants.dart';
import 'package:assignment1/models/index.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  final _headlineController = TextEditingController();

  User? _user;
  bool _isLoading = true;
  bool _isSaving = false;
  File? _pickedImage;
  bool _canEdit = true;
  int _daysUntilEdit = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _headlineController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final email = AuthSession().loggedInEmail;
    if (email == null) {
      setState(() => _isLoading = false);
      return;
    }
    final users = await userStore.findAll();
    final user = users.firstWhere(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
      orElse: () => users.first,
    );

    // Load last edit date from Hive meta box
    final box = Hive.box<Map>('users');
    final userMap = box.get(user.getId());
    DateTime? lastEdit;
    if (userMap != null && userMap['lastProfileEdit'] != null) {
      lastEdit = DateTime.tryParse(userMap['lastProfileEdit'] as String);
    }

    bool canEdit = true;
    int daysLeft = 0;
    if (lastEdit != null) {
      final diff = DateTime.now().difference(lastEdit).inDays;
      if (diff < 30) {
        canEdit = false;
        daysLeft = 30 - diff;
      }
    }

    setState(() {
      _user = user;
      _nameController.text = user.fullName;
      _emailController.text = user.email;
      _bioController.text = user.bio ?? '';
      _headlineController.text = user.headline ?? '';
      _canEdit = canEdit;
      _daysUntilEdit = daysLeft;
      _isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    if (!_canEdit) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_user == null) return;

    setState(() => _isSaving = true);

    final box = Hive.box<Map>('users');
    final existingMap = box.get(_user!.getId());
    if (existingMap == null) {
      setState(() => _isSaving = false);
      return;
    }

    final updatedMap = Map<String, dynamic>.from(existingMap);
    updatedMap['fullName'] = _nameController.text.trim();
    updatedMap['bio'] = _bioController.text.trim();
    updatedMap['headline'] = _headlineController.text.trim();
    updatedMap['lastProfileEdit'] = DateTime.now().toIso8601String();

    // Store picked image path as profilePictureUrl (local file path)
    if (_pickedImage != null) {
      updatedMap['profilePictureUrl'] = _pickedImage!.path;
    }

    await box.put(_user!.getId(), updatedMap);

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context);
    }
  }

  InputDecoration _fieldDecoration(String label, {bool enabled = true}) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: enabled ? 0.7 : 0.4),
      ),
      filled: true,
      fillColor: enabled ? theme.colorScheme.surface : Colors.grey.shade100,
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
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    ImageProvider? imageProvider;
    if (_pickedImage != null) {
      imageProvider = FileImage(_pickedImage!);
    } else if (_user?.profilePictureUrl != null) {
      final url = _user!.profilePictureUrl!;
      imageProvider = url.startsWith('http')
          ? NetworkImage(url)
          : FileImage(File(url)) as ImageProvider;
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.primary, width: 3),
          ),
          child: CircleAvatar(
            radius: 55,
            backgroundImage: imageProvider,
            backgroundColor: Colors.grey.shade200,
            child: imageProvider == null
                ? const Icon(Icons.person, size: 55, color: Colors.grey)
                : null,
          ),
        ),
        GestureDetector(
          onTap: _canEdit ? _pickImage : null,
          child: Container(
            decoration: BoxDecoration(
              color: _canEdit ? theme.colorScheme.primary : Colors.grey.shade400,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
        title: Text(
          'Edit Profile',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildAvatar(theme),
              const SizedBox(height: 16),

              // 30-day lock banner
              if (!_canEdit)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lock_clock, color: Colors.orange.shade700, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'You can edit your profile again in $_daysUntilEdit day${_daysUntilEdit == 1 ? '' : 's'}.',
                          style: TextStyle(color: Colors.orange.shade700, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),

              TextFormField(
                controller: _nameController,
                enabled: _canEdit,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: _canEdit ? 1 : 0.5),
                ),
                decoration: _fieldDecoration('Full Name', enabled: _canEdit),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                enabled: false,
                style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                decoration: _fieldDecoration('Email', enabled: false),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _headlineController,
                enabled: _canEdit,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: _canEdit ? 1 : 0.5),
                ),
                decoration: _fieldDecoration('Headline', enabled: _canEdit),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _bioController,
                enabled: _canEdit,
                maxLines: 4,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: _canEdit ? 1 : 0.5),
                ),
                decoration: _fieldDecoration('Bio', enabled: _canEdit),
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canEdit
                        ? theme.colorScheme.primary
                        : Colors.grey.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _canEdit && !_isSaving ? _save : null,
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                      : Text(
                          _canEdit ? 'Save Changes' : 'Editing locked',
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
