import 'package:flutter_riverpod/flutter_riverpod.dart';

class Antrian {
  final List<Map<String, String?>> surveyQueue;
  final List<Map<String, String?>> rabQueue;
  final List<Map<String, String?>> amsQueue;

  Antrian({
    required this.surveyQueue,
    required this.rabQueue,
    required this.amsQueue,
  });

  Antrian copyWith({
    List<Map<String, String?>>? surveyQueue,
    List<Map<String, String?>>? rabQueue,
    List<Map<String, String?>>? amsQueue,
  }) {
    return Antrian(
      surveyQueue: surveyQueue ?? this.surveyQueue,
      rabQueue: rabQueue ?? this.rabQueue,
      amsQueue: amsQueue ?? this.amsQueue,
    );
  }
}

class AntrianNotifier extends Notifier<Antrian> {
  @override
  Antrian build() {
    return Antrian(
      surveyQueue: [],
      rabQueue: [],
      amsQueue: [],
    );
  }

  void addToSurveyQueue(Map<String, String?> newPermohonan) {
    state = state.copyWith(
      surveyQueue: [...state.surveyQueue, newPermohonan],
    );
  }

  void updatePermohonan(int index, Map<String, String?> updatedPermohonan, String queueType) {
    switch (queueType) {
      case 'survey':
        final updatedQueue = List<Map<String, String?>>.from(state.surveyQueue);
        updatedQueue[index] = updatedPermohonan;
        state = state.copyWith(surveyQueue: updatedQueue);
        break;
      case 'rab':
        final updatedQueue = List<Map<String, String?>>.from(state.rabQueue);
        updatedQueue[index] = updatedPermohonan;
        state = state.copyWith(rabQueue: updatedQueue);
        break;
      case 'ams':
        final updatedQueue = List<Map<String, String?>>.from(state.amsQueue);
        updatedQueue[index] = updatedPermohonan;
        state = state.copyWith(amsQueue: updatedQueue);
        break;
      default:
        break;
    }
  }

  void moveToRabQueue(int index) {
    final item = state.surveyQueue[index];
    final updatedSurvey = List<Map<String, String?>>.from(state.surveyQueue)..removeAt(index);
    final updatedRab = [...state.rabQueue, item];
    
    state = state.copyWith(
      surveyQueue: updatedSurvey,
      rabQueue: updatedRab,
    );
  }

  void moveToAmsQueue(int index) {
    final item = state.rabQueue[index];
    final updatedRab = List<Map<String, String?>>.from(state.rabQueue)..removeAt(index);
    final updatedAms = [...state.amsQueue, item];
    
    state = state.copyWith(
      rabQueue: updatedRab,
      amsQueue: updatedAms,
    );
  }

  void deleteFromQueue(int index, String queueType) {
    switch (queueType) {
      case 'survey':
        final updatedQueue = List<Map<String, String?>>.from(state.surveyQueue);
        updatedQueue.removeAt(index);
        state = state.copyWith(surveyQueue: updatedQueue);
        break;
      case 'rab':
        final updatedQueue = List<Map<String, String?>>.from(state.rabQueue);
        updatedQueue.removeAt(index);
        state = state.copyWith(rabQueue: updatedQueue);
        break;
      case 'ams':
        final updatedQueue = List<Map<String, String?>>.from(state.amsQueue);
        updatedQueue.removeAt(index);
        state = state.copyWith(amsQueue: updatedQueue);
        break;
      default:
        break;
    }
  }
}

final antrianProvider = NotifierProvider<AntrianNotifier, Antrian>(() {
  return AntrianNotifier();
});