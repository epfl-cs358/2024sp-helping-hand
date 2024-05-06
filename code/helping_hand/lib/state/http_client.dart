import "package:helping_hand/state/fake/fake_http_client.dart";
import "package:hooks_riverpod/hooks_riverpod.dart";
import "package:http/http.dart" as http;

final httpClientProvider = Provider<http.Client>(
  (ref) => FakeHttpClient(),
  // (ref) => http.Client(),
);
