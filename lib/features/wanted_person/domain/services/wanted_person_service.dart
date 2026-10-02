import 'package:dart_gov_fbi/constants/api_fields.dart';
import 'package:dart_gov_fbi/features/wanted_person/domain/models/wanted_person.dart';
import 'package:dart_gov_fbi/features/wanted_person/domain/models/wanted_person_result_set.dart';
import 'package:dart_gov_fbi/utils/api_tool.dart';
import 'package:dart_gov_fbi/utils/url_tool.dart';

class WantedPersonService {
  static Future<WantedPerson> fetchWantedPerson(String id) async {
    final String host = 'https://api.fbi.gov/@wanted-person/$id';

    final responseArr = await fetchApiJson(
      Uri.parse(host),
      allowNotFound: true,
    );

    if (responseArr.isEmpty) return WantedPerson.empty();

    responseArr[ApiFields.id] = id;

    return WantedPerson.fromJson(responseArr);
  }

  static Future<WantedPersonResultSet> fetchWantedPersons({
    int? pageSize,
    int? page,
    String? sortOn,
    String? sortOrder,
    String? title,
    String? fieldOffices,
    String? personClassification,
    String? posterClassification,
    String? status,
  }) async {
    final String host = _buildUrl(
      pageSize: pageSize,
      page: page,
      sortOn: sortOn,
      sortOrder: sortOrder,
      title: title,
      fieldOffices: fieldOffices,
      personClassification: personClassification,
      posterClassification: posterClassification,
      status: status,
    );

    final responseArr = await fetchApiJson(Uri.parse(host));

    if (responseArr.isEmpty) return WantedPersonResultSet.empty();

    return WantedPersonResultSet.fromJson(responseArr);
  }

  /// Builds the URL for the API call.
  static String _buildUrl({
    int? pageSize,
    int? page,
    String? sortOn,
    String? sortOrder,
    String? title,
    String? fieldOffices,
    String? personClassification,
    String? posterClassification,
    String? status,
  }) {
    const String baseUrl = 'https://api.fbi.gov/@wanted';

    return UrlTool.buildUrl(
      baseUrl: baseUrl,
      queryParams: {
        'pageSize':
            pageSize == null ? null : (pageSize < 1 ? 1 : pageSize).toString(),
        'page': page?.toString(),
        'sort_on': sortOn,
        'sort_order': sortOrder,
        'title': title,
        'field_offices': fieldOffices,
        'person_classification': personClassification,
        'poster_classification': posterClassification,
        'status': status,
      },
    );
  }
}
