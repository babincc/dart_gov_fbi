import 'dart:convert';

import 'package:dart_gov_fbi/dart_gov_fbi.dart';
import 'package:dart_gov_fbi/utils/url_tool.dart';
import 'package:test/test.dart';

void main() {
  test('filters preserve special characters without injecting parameters', () {
    final uri = Uri.parse(UrlTool.buildUrl(
      baseUrl: 'https://api.fbi.gov/@wanted',
      queryParams: {'title': 'A & B + café?#', 'page': null},
    ));
    expect(uri.queryParameters, {'title': 'A & B + café?#'});
    expect(uri.fragment, isEmpty);
  });

  test('existing query parameters and fragments survive', () {
    final uri = Uri.parse(UrlTool.buildUrl(
      baseUrl: 'https://example.com/items?page=1#results',
      queryParams: {'page': '2', 'title': 'a/b'},
    ));
    expect(uri.queryParameters, {'page': '2', 'title': 'a/b'});
    expect(uri.fragment, 'results');
  });

  test('absent parameters do not add a query string', () {
    expect(
        UrlTool.buildUrl(
            baseUrl: 'https://example.com/items', queryParams: {'title': null}),
        'https://example.com/items');
  });

  test('art crime result sets round trip through JSON', () {
    const result = ArtCrimeResultSet(total: 1, page: 1, artCrimes: [
      ArtCrime(title: 'Painting', images: [FbiImage(caption: 'Front')])
    ]);
    expect(ArtCrimeResultSet.fromJson(jsonDecode(jsonEncode(result.toJson()))),
        result);
  });

  test('wanted person result sets round trip through JSON', () {
    const result = WantedPersonResultSet(total: 1, page: 1, wantedPersons: [
      WantedPerson(title: 'Person', images: [FbiImage(caption: 'Photo')])
    ]);
    expect(
        WantedPersonResultSet.fromJson(jsonDecode(jsonEncode(result.toJson()))),
        result);
  });
}
