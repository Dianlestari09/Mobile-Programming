import 'package:get/get.dart';

class TasbihController extends GetxController {
  final counter = 0.obs;
  final progress = 0.0.obs;
  final int maxCount = 33;

  void incrementCounter() {
    if (counter.value < maxCount) {
      counter.value++;
      progress.value = counter.value / maxCount;
    }
  }

  void resetCounter() {
    counter.value = 0;
    progress.value = 0.0;
  }
}
