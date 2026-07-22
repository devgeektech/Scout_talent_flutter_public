import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scouttalent2/utils/utils.dart';

Future<File?> pickImageCommon(String kind) async {
  final pickedFile = await ImagePicker().pickImage(
    source: kind == 'gallery' ? ImageSource.gallery : ImageSource.camera,
    imageQuality: 25,
  );

  if (pickedFile != null) {
    final File? cropImg = await cropImage(pickedFile);

    if (cropImg != null) {
      return File(cropImg.path);
    } else {
      return File(pickedFile.path);
    }
  }
  return null;
}

Future<File?> pickPdfFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null && result.files.single.path != null) {
    return File(result.files.single.path!);
  }
  return null;
}