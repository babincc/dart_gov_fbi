import 'package:dart_gov_fbi/utils/json_tool.dart';
import 'package:http/http.dart' as http;

/// Reads an API response, preserving the empty-model behavior for missing IDs.
Future<Map<String, dynamic>> fetchApiJson(
  Uri uri, {
  bool allowNotFound = false,
}) async {
  final response = await http.get(uri);
  if (allowNotFound && response.statusCode == 404) return {};
  if (response.statusCode < 200 || response.statusCode >= 300) {
    throw http.ClientException(
      'FBI API request failed (HTTP ${response.statusCode}).',
      uri,
    );
  }
  return readJson(response.body);
}
