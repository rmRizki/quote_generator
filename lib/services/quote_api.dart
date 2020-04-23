import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quote_generator/models/quote.dart';

class QuoteApi {
  final String _baseUrl = 'https://api.quotable.io/random';

  Future<Quote> fetchRandomQuote() async {
    final response = await http.get(_baseUrl);
    if (response.statusCode == 200) {
      return Quote.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
}
