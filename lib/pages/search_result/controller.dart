import 'package:get/get.dart';
import 'package:pilipala/pages/desktop/index.dart';

class SearchResultController extends GetxController {
  String? keyword;
  int tabIndex = 0;

  @override
  void onInit() {
    super.onInit();
    if (getParameters.keys.isNotEmpty) {
      keyword = getParameters['keyword'];
    }
  }
}
