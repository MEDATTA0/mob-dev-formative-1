import 'package:flutter/material.dart';
import 'package:assignment1/constants.dart';
import 'package:assignment1/models/index.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  bool isEvent = true;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedCategory;
  String? selectedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Create Post",
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
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
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined, size: 40),
                  SizedBox(height: 10),
                  Text("Add Cover Image"),
                ],
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
                selectedLocation = value;
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
                selectedCategory = value;
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Publish Post",
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
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
