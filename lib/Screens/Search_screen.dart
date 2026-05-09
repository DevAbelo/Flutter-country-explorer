import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/country.dart';
import '../services/country_api_service.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final CountryApiService _apiService = CountryApiService();
  final TextEditingController _controller = TextEditingController();

  List<Country> _results = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _hasSearched = false;

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _hasSearched = true;
    });

    try {
      final results = await _apiService.searchByName(query.trim());
      if (mounted) {
        setState(() {
          _results = results;
          _isLoading = false;
        });
      }
    } on SocketException {
      if (mounted) {
        setState(() {
          _errorMessage = 'No internet connection';
          _isLoading = false;
        });
      }
    } on TimeoutException {
      if (mounted) {
        setState(() {
          _errorMessage = 'Request timed out. Please try again.';
          _isLoading = false;
        });
      }
    } on FormatException {
      if (mounted) {
        setState(() {
          _errorMessage = 'Unexpected data format received';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'An unexpected error occurred: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Countries'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a country name...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    setState(() {
                      _results = [];
                      _hasSearched = false;
                      _errorMessage = null;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: _search,
              textInputAction: TextInputAction.search,
            ),
          ),

          // Results area
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    // Loading
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error
    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => _search(_controller.text),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Not searched yet
    if (!_hasSearched) {
      return const Center(
        child: Text(
          'Search for a country above',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // No results
    if (_results.isEmpty) {
      return const Center(child: Text('No countries found.'));
    }

    // Results list
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final country = _results[index];
        return ListTile(
          leading: Text(
            country.flagEmoji,
            style: const TextStyle(fontSize: 32),
          ),
          title: Text(
            country.commonName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(country.region),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(alpha3Code: country.alpha3Code),
              ),
            );
          },
        );
      },
    );
  }
}