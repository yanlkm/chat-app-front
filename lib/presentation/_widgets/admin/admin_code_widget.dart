import 'package:flutter/material.dart';

// Admin Code Widget
class AdminCodeWidget extends StatelessWidget {
  // Code Controller
  final TextEditingController codeController;

  // Attributes
  final String currentCode;
  final bool isCodeCopied;

  // Callbacks
  final VoidCallback onCreateCode;
  final VoidCallback onCopyCode;

  // Constructor
  const AdminCodeWidget({
    super.key,
    required this.codeController,
    required this.currentCode,
    required this.isCodeCopied,
    required this.onCreateCode,
    required this.onCopyCode,
  });

  // Build Method
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Generate Code
        const Text(
          'Generate Code',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'CODE',
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Create Code Button
            ElevatedButton(
              onPressed: onCreateCode,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size(90, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Icon(
                Icons.arrow_circle_right_outlined,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Current Code Generated
        if (currentCode.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(5),
            ),
            width: MediaQuery.of(context).size.width * 0.5,
            child: ListTile(
              // Current Code
              title: Text(
                currentCode,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Copy Code Button
              trailing: IconButton(
                onPressed: onCopyCode,
                icon: Icon(
                  isCodeCopied ? Icons.check : Icons.copy,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
