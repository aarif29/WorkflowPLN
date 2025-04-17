import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AntrianController extends GetxController {
  // Gunakan RxList untuk state yang reaktif
  final surveyQueue = <Map<String, dynamic>>[].obs;
  final rabQueue = <Map<String, dynamic>>[].obs;
  final amsQueue = <Map<String, dynamic>>[].obs;
  final completedQueue = <Map<String, dynamic>>[].obs;

  // Inisialisasi GetStorage
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Muat data dari penyimpanan lokal saat controller diinisialisasi
    loadDataFromStorage();
    // Tambahkan listener untuk menyimpan data setiap kali ada perubahan
    ever(surveyQueue, (_) => saveDataToStorage());
    ever(rabQueue, (_) => saveDataToStorage());
    ever(amsQueue, (_) => saveDataToStorage());
    ever(completedQueue, (_) => saveDataToStorage());
  }

  void loadDataFromStorage() {
    // Muat data dari penyimpanan lokal
    final List<dynamic>? storedSurveyQueue = storage.read('surveyQueue');
    final List<dynamic>? storedRabQueue = storage.read('rabQueue');
    final List<dynamic>? storedAmsQueue = storage.read('amsQueue');
    final List<dynamic>? storedCompletedQueue = storage.read('completedQueue');

    if (storedSurveyQueue != null) {
      surveyQueue.assignAll(storedSurveyQueue.cast<Map<String, dynamic>>());
    }
    if (storedRabQueue != null) {
      rabQueue.assignAll(storedRabQueue.cast<Map<String, dynamic>>());
    }
    if (storedAmsQueue != null) {
      amsQueue.assignAll(storedAmsQueue.cast<Map<String, dynamic>>());
    }
    if (storedCompletedQueue != null) {
      completedQueue.assignAll(storedCompletedQueue.cast<Map<String, dynamic>>());
    }
  }

  void saveDataToStorage() {
    // Simpan data ke penyimpanan lokal
    storage.write('surveyQueue', surveyQueue.toList());
    storage.write('rabQueue', rabQueue.toList());
    storage.write('amsQueue', amsQueue.toList());
    storage.write('completedQueue', completedQueue.toList());
  }

  // Menambahkan permohonan baru ke antrian survey
  void addPermohonan(Map<String, dynamic> permohonan) {
    surveyQueue.add(permohonan);
  }

  // Memperbarui permohonan di antrian tertentu
  void updatePermohonan(int index, Map<String, dynamic> data, String queueType) {
    switch (queueType) {
      case 'survey':
        surveyQueue[index] = data;
        break;
      case 'rab':
        rabQueue[index] = data;
        break;
      case 'ams':
        amsQueue[index] = data;
        break;
      case 'completed':
        completedQueue[index] = data;
        break;
    }
  }

  // Menghapus permohonan dari antrian tertentu
  void deleteFromQueue(int index, String queueType) {
    switch (queueType) {
      case 'survey':
        surveyQueue.removeAt(index);
        break;
      case 'rab':
        rabQueue.removeAt(index);
        break;
      case 'ams':
        amsQueue.removeAt(index);
        break;
      case 'completed':
        completedQueue.removeAt(index);
        break;
    }
  }

  // Memindahkan permohonan dari antrian survey ke RAB
  void moveToRabQueue(int index) {
    rabQueue.add(surveyQueue[index]);
    surveyQueue.removeAt(index);
  }

  // Memindahkan permohonan dari antrian RAB ke AMS
  void moveToAmsQueue(int index) {
    amsQueue.add(rabQueue[index]);
    rabQueue.removeAt(index);
  }

  // Memindahkan permohonan dari antrian AMS ke Completed
  void moveToCompletedQueue(int index) {
    completedQueue.add(amsQueue[index]);
    amsQueue.removeAt(index);
  }
}