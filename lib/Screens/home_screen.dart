import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/country.dart';
import '../services/country_api_service.dart';
import 'detail_screen.dart';
import 'Search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CountryApiService _apiService = CountryApiService();
  late Future<List<Country>> _countriesFuture;

  @override
  void initState() {
    super.initState();
    _countriesFuture = _apiService.fetchAllCountries();
  }

  void _retry() {
    setState(() {
      _countriesFuture = _apiService.fetchAllCountries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🌍 Country Explorer'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Country>>(
        future: _countriesFuture,
        builder: (context, snapshot) {
          // State 1 — Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading countries...'),
                ],
              ),
            );
          }

          // State 2 — Error
          if (snapshot.hasError) {
            final error = snapshot.error;
            String message = 'An unexpected error occurred';

            if (error is SocketException) {
              message = 'No internet connection';
            } else if (error is TimeoutException) {
              message = 'Request timed out. Please try again.';
            } else if (error is FormatException) {
              message = 'Unexpected data format received';
            } else {
              message = 'An unexpected error occurred: ${error.toString()}';
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // State 3 — No data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No countries found.'));
          }

          // State 4 — Data
          final countries = snapshot.data!;
          return ListView.builder(
            itemCount: countries.length,
            itemBuilder: (context, index) {
              final country = countries[index];
              return ListTile(
                leading: Text(
                  country.flagEmoji,
                  style: const TextStyle(fontSize: 32),
                ),
                title: Text(
                  country.commonName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${country.region} • Pop: ${country.population.toString()}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DetailScreen(alpha3Code: country.alpha3Code),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
