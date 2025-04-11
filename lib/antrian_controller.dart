import 'package:get/get.dart';

class AntrianController extends GetxController {
  // Gunakan RxList untuk state yang reaktif
  final surveyQueue = <Map<String, String?>>[].obs;
  final rabQueue = <Map<String, String?>>[].obs;
  final amsQueue = <Map<String, String?>>[].obs;
  final completedQueue = <Map<String, String?>>[].obs;

  // Menambahkan permohonan baru ke antrian survey
  void addPermohonan(Map<String, String?> permohonan) {
    surveyQueue.add(permohonan);
  }

  // Memperbarui permohonan di antrian tertentu
  void updatePermohonan(int index, Map<String, String?> data, String queueType) {
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
