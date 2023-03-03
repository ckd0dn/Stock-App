import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:practice/data/source/remote/dto/company_info_dto.dart';

class StockApi {
  static const baseUrl = 'https://www.alphavantage.co/';
  static const apiKey = 'GSN98C6ALKPITC1Y';

  late final http.Client _client;

  StockApi({http.Client? client}) : _client = (client ?? http.Client());

  Future<http.Response> getListings({String apiKey = apiKey}) async {
    return await _client.get(
        Uri.parse('$baseUrl/query?function=LISTING_STATUS&apikey=$apiKey'));
  }

  Future<CompanyInfoDTO> getCompanyInfo(
      {required String symbol, String apiKey = apiKey}) async {
    final response = await _client.get(Uri.parse(
        '$baseUrl/query?function=OVERVIEW&symbol=$symbol&apikey=$apiKey'));

    return CompanyInfoDTO.fromJson(jsonDecode(response.body));
  }

  Future<http.Response> getIntradayInfo({
    required String symbol,
    String apiKey = apiKey,
  }) async {
    return await _client.get(Uri.parse(
        '$baseUrl/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=60min&apikey=$apiKey&datatype=csv'));
  }
}