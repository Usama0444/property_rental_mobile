import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadPropertyImagesController extends GetxController {
  // RxString imagePath = ''.obs;
  RxString imagePath1 = ''.obs;
  RxString imagePath2 = ''.obs;
  RxString imagePath3 = ''.obs;
  RxString imagePath4 = ''.obs;

  /// pickVideo
  Future<String?> getVideo(ImageSource imageSource) async {
    ImagePicker imagePicker = ImagePicker();
    final video = await imagePicker.pickVideo(source: imageSource);
    if (video == null) {
      return null;
    } else {
      return video.path.toString();
    }
  }
}
