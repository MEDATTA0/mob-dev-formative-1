import 'package:flutter/material.dart';
import 'package:assignment1/constants.dart';
import 'package:assignment1/models/index.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  bool isEvent = true;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedCategory;
  String? selectedLocation;

  Future<void> _publishPost() async {
    if (titleController.text.isEmpty) {
      _showError('Please enter a title');
      return;
    }
    if (descriptionController.text.isEmpty) {
      _showError('Please enter a description');
      return;
    }
    if (selectedLocation == null) {
      _showError('Please select a location');
      return;
    }
    if (selectedCategory == null) {
      _showError('Please select a category');
      return;
    }

    try {
      final post = Post(
        title: titleController.text,
        description: descriptionController.text,
        category: selectedCategory!,
        location: selectedLocation!,
        campusId: selectedLocation!,
        tags: [selectedCategory!],
        isEvent: isEvent,
        coverImageUrl: _selectedImage?.path ?? '',
        startTime: isEvent ? DateTime.now().add(const Duration(days: 1)) : null,
        endTime: isEvent ? DateTime.now().add(const Duration(days: 1, hours: 2)) : null,
      );

      await postStore.add(post);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post published successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showError('Failed to publish post: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Image'),
          content: const Text('Choose image source'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _pickImageFromSource(ImageSource.camera);
              },
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _pickImageFromSource(ImageSource.gallery);
              },
              child: const Text('Gallery'),
            ),
          ],
        ),
      );
    } catch (e) {
      _showError('Failed to open image picker: $e');
    }
  }

  Future<void> _pickImageFromSource(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image selected successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: AppColors.text),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      "Create Post",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event / Opportunity Toggle
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEvent = true;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isEvent
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Center(
                                  child: Text("Event"),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEvent = false;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: !isEvent
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Center(
                                  child: Text("Opportunity"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Cover Image
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_outlined, 
                                    size: 40,
                                    color: Colors.grey.shade500,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Tap to Add Cover Image",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildLabel("Title"),

                    TextField(
                      controller: titleController,
                      decoration: _inputDecoration(
                        "Enter title",
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildLabel("Description"),

                    TextField(
                      controller: descriptionController,
                      maxLines: 5,
                      decoration: _inputDecoration(
                        "Describe your event...",
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildLabel("Location"),

                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration("Select location"),
                      items: const [
                        DropdownMenuItem(
                          value: "Kigali Campus",
                          child: Text("Kigali Campus"),
                        ),
                        DropdownMenuItem(
                          value: "Mauritius Campus",
                          child: Text("Mauritius Campus"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedLocation = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    _buildLabel("Category"),

                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration("Select category"),
                      items: const [
                        DropdownMenuItem(
                          value: "Technology",
                          child: Text("Technology"),
                        ),
                        DropdownMenuItem(
                          value: "Leadership",
                          child: Text("Leadership"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _publishPost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Publish Post",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: AppColors.text,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 14,
      ),
      filled: true,
      fillColor: AppColors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }
}
