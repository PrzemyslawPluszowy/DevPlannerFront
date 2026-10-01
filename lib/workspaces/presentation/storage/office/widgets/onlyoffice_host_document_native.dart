/// Native WebView ładuje HTML swoim API, bez adresu obiektu przeglądarki.
final class OnlyOfficeHostDocument {
  Uri? create(String html) => null;

  bool owns(Uri uri) => false;

  void dispose() {}
}
