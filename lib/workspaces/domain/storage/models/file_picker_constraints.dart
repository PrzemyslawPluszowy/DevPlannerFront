/// Ograniczenia wyboru plików, które pozwalają pominąć odczyt dużych danych.
///
/// `alreadySelected*` opisuje pliki już zaakceptowane przez właściciela wyboru;
/// `accepted*InBatch` opisuje wcześniejsze pliki z bieżącego pickera/dropu.
final class FilePickerConstraints {
  const FilePickerConstraints({
    required this.maxFiles,
    required this.maxFileSizeBytes,
    required this.maxTotalSizeBytes,
    this.alreadySelectedFileCount = 0,
    this.alreadySelectedBytes = 0,
  }) : assert(maxFiles > 0, 'maxFiles musi być dodatnie.'),
       assert(maxFileSizeBytes > 0, 'maxFileSizeBytes musi być dodatnie.'),
       assert(maxTotalSizeBytes > 0, 'maxTotalSizeBytes musi być dodatnie.'),
       assert(
         alreadySelectedFileCount >= 0,
         'alreadySelectedFileCount nie może być ujemne.',
       ),
       assert(
         alreadySelectedBytes >= 0,
         'alreadySelectedBytes nie może być ujemne.',
       );

  final int maxFiles;
  final int maxFileSizeBytes;
  final int maxTotalSizeBytes;
  final int alreadySelectedFileCount;
  final int alreadySelectedBytes;

  /// Czy plik mieści się w limitach i wolnej części aktualnej selekcji.
  bool canReadFile(
    int size, {
    int acceptedFilesInBatch = 0,
    int acceptedBytesInBatch = 0,
  }) =>
      size >= 0 &&
      size <= maxFileSizeBytes &&
      alreadySelectedFileCount + acceptedFilesInBatch < maxFiles &&
      alreadySelectedBytes + acceptedBytesInBatch + size <= maxTotalSizeBytes;
}
