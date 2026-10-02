class UrlTool {
  static String buildUrl({
    required String baseUrl,
    Map<String, String?>? queryParams,
  }) {
    final uri = Uri.parse(baseUrl);
    final parameters = <String, String>{...uri.queryParameters};
    for (final entry in (queryParams ?? <String, String?>{}).entries) {
      if (entry.value != null) {
        parameters[entry.key] = entry.value!;
      }
    }
    if (parameters.isEmpty) return uri.toString();
    return uri.replace(queryParameters: parameters).toString();
  }
}
