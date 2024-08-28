import 'package:flutter/material.dart';

// Search Bar Widget
class SearchBarWidget extends StatelessWidget {
  // Search Controller and onSearchChanged as attributes
  final TextEditingController searchController;
  final Function(String) onSearchChanged;

  // Constructor
  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
  });

  // main build method
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: const InputDecoration(
        hintText: 'Search rooms',
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: onSearchChanged,
    );
  }
}
