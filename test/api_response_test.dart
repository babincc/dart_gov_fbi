import 'dart:convert';

import 'package:dart_gov_fbi/dart_gov_fbi.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

void main() {
  test('current and legacy API IDs are supported', () {
    expect(
        WantedPerson.fromJson(
            {'pathId': 'https://api.fbi.gov/@wanted-person/abc'}).id,
        'abc');
    expect(
        ArtCrime.fromJson({'pathId': 'https://api.fbi.gov/@artcrimes/abc'}).id,
        'abc');
    expect(
        WantedPerson.fromJson(
            {'@id': 'https://api.fbi.gov/@wanted-person/legacy'}).id,
        'legacy');
    expect(
        ArtCrime.fromJson({'@id': 'https://api.fbi.gov/@artcrimes/legacy'}).id,
        'legacy');
  });

  test('invalid page sizes preserve the one-item minimum', () async {
    await http.runWithClient(() async {
      for (final size in [-50, 0]) {
        await fetchWantedPersons(pageSize: size);
        await fetchArtCrimes(pageSize: size);
      }
    },
        () => MockClient((request) async {
              expect(request.url.queryParameters['pageSize'], '1');
              return http.Response(
                  jsonEncode({'total': 0, 'page': 1, 'items': []}), 200);
            }));
  });

  test('404 detail responses return empty models', () async {
    await http.runWithClient(() async {
      expect((await fetchWantedPerson('missing')).isEmpty, true);
      expect((await fetchArtCrime('missing')).isEmpty, true);
    },
        () => MockClient(
            (_) async => http.Response('{"detail":"UID not found"}', 404)));
  });

  test('HTTP failures are reported before parsing error bodies', () async {
    for (final status in [403, 422, 429, 500]) {
      await http.runWithClient(() async {
        final matcher = throwsA(isA<http.ClientException>().having(
            (error) => error.message, 'message', contains('HTTP $status')));
        await expectLater(fetchWantedPersons(), matcher);
        await expectLater(fetchArtCrimes(), matcher);
        await expectLater(fetchWantedPerson('abc'), matcher);
        await expectLater(fetchArtCrime('abc'), matcher);
      },
          () => MockClient(
              (_) async => http.Response('<html>Error</html>', status)));
    }
  });
}
