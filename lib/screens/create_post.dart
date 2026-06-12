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
  DateTime? selectedStartDate;
  TimeOfDay? selectedStartTime;
  DateTime? selectedEndDate;
  TimeOfDay? selectedEndTime;

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
    if (isEvent) {
      if (selectedStartDate == null) {
        _showError('Please select start date for the event');
        return;
      }
      if (selectedStartTime == null) {
        _showError('Please select start time for the event');
        return;
      }
    }

    try {
      // Get current user ID
      int authorId = 1; // Default fallback
      try {
        final users = await userStore.findAll();
        if (users.isNotEmpty) {
          authorId = users.first.getId();
        }
      } catch (_) {}

      // Combine date and time for events
      DateTime? eventStartTime;
      DateTime? eventEndTime;
      
      if (isEvent && selectedStartDate != null && selectedStartTime != null) {
        eventStartTime = DateTime(
          selectedStartDate!.year,
          selectedStartDate!.month,
          selectedStartDate!.day,
          selectedStartTime!.hour,
          selectedStartTime!.minute,
        );
        
        if (selectedEndDate != null && selectedEndTime != null) {
          eventEndTime = DateTime(
            selectedEndDate!.year,
            selectedEndDate!.month,
            selectedEndDate!.day,
            selectedEndTime!.hour,
            selectedEndTime!.minute,
          );
        } else {
          // Default to 2 hours after start time if no end time specified
          eventEndTime = eventStartTime.add(const Duration(hours: 2));
        }
      }

      final post = Post(
        authorId: authorId,
        type: isEvent ? PostType.event : PostType.opportunity,
        title: titleController.text,
        description: descriptionController.text,
        category: selectedCategory!,
        location: selectedLocation!,
        campusId: selectedLocation!,
        tags: [selectedCategory!],
        coverImageUrl: _selectedImage?.path ?? '',
        startTime: eventStartTime,
        endTime: eventEndTime,
      );

      await postStore.add(post);
      
      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image selected successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedStartDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        selectedStartDate = date;
      });
    }
  }

  Future<void> _selectStartTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedStartTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        selectedStartTime = time;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedEndDate ?? selectedStartDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: selectedStartDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        selectedEndDate = date;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedEndTime ?? TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        selectedEndTime = time;
      });
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

                    // Date and Time Selection (only for events)
                    if (isEvent) const SizedBox(height: 0),
                    if (isEvent)
                      _buildLabel("Event Start Date & Time"),
                    if (isEvent)
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _selectStartDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                                    const SizedBox(width: 8),
                                    Text(
                                      selectedStartDate != null
                                          ? '${selectedStartDate!.day}/${selectedStartDate!.month}/${selectedStartDate!.year}'
                                          : 'Select Date',
                                      style: TextStyle(
                                        color: selectedStartDate != null ? Colors.black : Colors.grey.shade500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: _selectStartTime,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                                    const SizedBox(width: 8),
                                    Text(
                                      selectedStartTime != null
                                          ? selectedStartTime!.format(context)
                                          : 'Select Time',
                                      style: TextStyle(
                                        color: selectedStartTime != null ? Colors.black : Colors.grey.shade500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                    if (isEvent) const SizedBox(height: 15),
                    if (isEvent) _buildLabel("Event End Date & Time (Optional)"),
                    if (isEvent)
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: _selectEndDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                                    const SizedBox(width: 8),
                                    Text(
                                      selectedEndDate != null
                                          ? '${selectedEndDate!.day}/${selectedEndDate!.month}/${selectedEndDate!.year}'
                                          : 'Select Date',
                                      style: TextStyle(
                                        color: selectedEndDate != null ? Colors.black : Colors.grey.shade500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: _selectEndTime,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                                    const SizedBox(width: 8),
                                    Text(
                                      selectedEndTime != null
                                          ? selectedEndTime!.format(context)
                                          : 'Select Time',
                                      style: TextStyle(
                                        color: selectedEndTime != null ? Colors.black : Colors.grey.shade500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (isEvent) const SizedBox(height: 20),

                    _buildLabel("Title"),

                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.black),
                      decoration: _inputDecoration(
                        "Enter title",
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildLabel("Description"),

                    TextField(
                      controller: descriptionController,
                      style: const TextStyle(color: Colors.black),
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
