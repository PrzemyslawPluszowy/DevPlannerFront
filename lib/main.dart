import 'package:ready_next/bootstrap/app_bootstrap.dart';
import 'package:ready_next/main_web_url_strategy.dart';

Future<void> main() async {
  // Na webie uzywamy zwyklych sciezek URL zamiast adresow z `#`.
  configureWebUrlStrategy();

  // Bindujemy punkt wejscia do wspolnego bootstrapa aplikacji.
  await bootstrap();
}
