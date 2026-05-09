import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/country.dart';
import 'api_exception.dart';

class CountryApiService {
  final String _baseUrl = 'restcountries.com';
  final Duration _timeout = const Duration(seconds: 10);
  final Map<String, String> _headers = const {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Private method to check response status
  void _checkResponse(http.Response response) {
    if (response.statusCode != 200) {
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Server error: ${response.statusCode}',
      );
    }
  }

  // Fetch ALL countries
  Future<List<Country>> fetchAllCountries() async {
    final uri = Uri.https(_baseUrl, '/v3.1/all', {
      'fields': 'name,flag,region,population,cca3',
    });

    try {
      final response = await http.get(uri, headers: _headers).timeout(_timeout);

      _checkResponse(response);

      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data
          .map((e) => Country.fromJson(e as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw const SocketException('No internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timed out');
    } on FormatException {
      throw const FormatException('Unexpected data format received');
    }
  }

  // Search countries by name
  Future<List<Country>> searchByName(String name) async {
    final uri = Uri.https(_baseUrl, '/v3.1/name/$name');

    try {
      final response = await http.get(uri, headers: _headers).timeout(_timeout);

      _checkResponse(response);

      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data
          .map((e) => Country.fromJson(e as Map<String, dynamic>))
          .toList();
    } on SocketException {
      throw const SocketException('No internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timed out');
    } on FormatException {
      throw const FormatException('Unexpected data format received');
    }
  }

  // Fetch single country by code (for detail screen)
  Future<Country> fetchByCode(String code) async {
    final uri = Uri.https(_baseUrl, '/v3.1/alpha/$code');

    try {
      final response = await http.get(uri, headers: _headers).timeout(_timeout);

      _checkResponse(response);

      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return Country.fromJson(data.first as Map<String, dynamic>);
    } on SocketException {
      throw const SocketException('No internet connection');
    } on TimeoutException {
      throw TimeoutException('Request timed out');
    } on FormatException {
      throw const FormatException('Unexpected data format received');
    }
  }
}
