import 'package:isar/isar.dart';

part 'photo_metadata.g.dart';

@embedded
class PhotoMetadata {
  // Store EXIF as JSON string since Map<String,String> isn't supported
  String exifDataJson = '{}';
  DateTime? dateTaken;
  double? latitude;
  double? longitude;
  int fileSize = 0;

  PhotoMetadata();
}
