import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AntrianController extends GetxController {
  final GetStorage storage = GetStorage();
  late String group;

  final surveyQueue = <Map<String, dynamic>>[].obs;
  final rabQueue = <Map<String, dynamic>>[].obs;
  final amsQueue = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil grup dari GetStorage
    group = storage.read('group') ?? 'default';
    // Muat data antrian berdasarkan grup
    loadQueues();
  }

  void loadQueues() {
    // Muat data dari GetStorage dengan prefix grup
    surveyQueue.value = (storage.read('${group}_surveyQueue') ?? []).cast<Map<String, dynamic>>();
    rabQueue.value = (storage.read('${group}_rabQueue') ?? []).cast<Map<String, dynamic>>();
    amsQueue.value = (storage.read('${group}_amsQueue') ?? []).cast<Map<String, dynamic>>();
  }

  void addPermohonan(Map<String, dynamic> permohonan) {
    surveyQueue.add(permohonan);
    storage.write('${group}_surveyQueue', surveyQueue.toList());
  }

  void updatePermohonan(int index, Map<String, dynamic> data, String queueType) {
    switch (queueType) {
      case 'survey':
        surveyQueue[index] = data;
        storage.write('${group}_surveyQueue', surveyQueue.toList());
        break;
      case 'rab':
        rabQueue[index] = data;
        storage.write('${group}_rabQueue', rabQueue.toList());
        break;
      case 'ams':
        amsQueue[index] = data;
        storage.write('${group}_amsQueue', amsQueue.toList());
        break;
    }
  }

  void deleteFromQueue(int index, String queueType) {
    switch (queueType) {
      case 'survey':
        surveyQueue.removeAt(index);
        storage.write('${group}_surveyQueue', surveyQueue.toList());
        break;
      case 'rab':
        rabQueue.removeAt(index);
        storage.write('${group}_rabQueue', rabQueue.toList());
        break;
      case 'ams':
        amsQueue.removeAt(index);
        storage.write('${group}_amsQueue', amsQueue.toList());
        break;
    }
  }

  void moveToRabQueue(int index) {
    rabQueue.add(surveyQueue[index]);
    surveyQueue.removeAt(index);
    storage.write('${group}_surveyQueue', surveyQueue.toList());
    storage.write('${group}_rabQueue', rabQueue.toList());
  }

  void moveToAmsQueue(int index) {
    amsQueue.add(rabQueue[index]);
    rabQueue.removeAt(index);
    storage.write('${group}_rabQueue', rabQueue.toList());
    storage.write('${group}_amsQueue', amsQueue.toList());
  }
}