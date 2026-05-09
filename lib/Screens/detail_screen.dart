import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../models/country.dart';
import '../services/country_api_service.dart';
import '../services/api_exception.dart';

class DetailScreen extends StatefulWidget {
  final String alpha3Code;

  const DetailScreen({super.key, required this.alpha3Code});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final CountryApiService _apiService = CountryApiService();
  late Future<Country> _countryFuture;

  @override
  void initState() {
    super.initState();
    _countryFuture = _apiService.fetchByCode(widget.alpha3Code);
  }

  void _retry() {
    setState(() {
      _countryFuture = _apiService.fetchByCode(widget.alpha3Code);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Details'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Country>(
        future: _countryFuture,
        builder: (context, snapshot) {
          // State 1 — Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // State 2 — Error
          if (snapshot.hasError) {
            final error = snapshot.error;
            String message = 'An unexpected error occurred';

            if (error is SocketException) {
              message = 'No internet connection';
            } else if (error is TimeoutException) {
              message = 'Request timed out. Please try again.';
            } else if (error is ApiException) {
              message = 'Server error ${error.statusCode}: ${error.message}';
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
          if (!snapshot.hasData) {
            return const Center(child: Text('No data available.'));
          }

          // State 4 — Data
          final country = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Flag + Name header
                Center(
                  child: Column(
                    children: [
                      Text(
                        country.flagEmoji,
                        style: const TextStyle(fontSize: 80),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        country.commonName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        country.officialName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Divider(),

                // Details
                _infoRow('Region', country.region),
                _infoRow(
                  'Capital',
                  country.capital.isEmpty ? 'N/A' : country.capital.join(', '),
                ),
                _infoRow('Population', country.population.toString()),
                _infoRow('Area', '${country.area.toStringAsFixed(0)} km²'),
                _infoRow(
                  'Currencies',
                  country.currencies.isEmpty
                      ? 'N/A'
                      : country.currencies.entries
                            .map((e) => '${e.value} (${e.key})')
                            .join(', '),
                ),
                _infoRow(
                  'Languages',
                  country.languages.isEmpty
                      ? 'N/A'
                      : country.languages.values.join(', '),
                ),
                _infoRow(
                  'Timezones',
                  country.timezones.isEmpty
                      ? 'N/A'
                      : country.timezones.join(', '),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
