import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class AntrianController extends GetxController {
  final supabase = Supabase.instance.client;
  late String ulp;

  final surveyQueue = <Map<String, dynamic>>[].obs;
  final rabQueue = <Map<String, dynamic>>[].obs;
  final amsQueue = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil ulp dari profil user dan muat data antrian
    fetchUlpAndLoadQueues();
  }

  Future<void> fetchUlpAndLoadQueues() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      print('User ID is null, cannot fetch data');
      return;
    }

    // Ambil ulp dari tabel profiles
    final profileResponse = await supabase
        .from('profiles')
        .select('ulp')
        .eq('id', userId)
        .single();

    ulp = profileResponse['ulp'] ?? 'default';
    print('Fetched ULP: $ulp for user: $userId');

    // Muat data awal dengan filter ulp dan user_id
    await _loadInitialData(userId);

    // Stream data dari Supabase untuk real-time update (tanpa filter tambahan, RLS akan menangani)
    supabase
        .from('survey_queue')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
      print('Survey Queue Stream Update: $data');
      surveyQueue.value = data.map((item) {
        return {
          'row_id': item['id'],
          'data': item['data'] as Map<String, dynamic>,
        };
      }).toList();
      print('Updated surveyQueue: ${surveyQueue.length} items');
    }, onError: (error) {
      print('Survey Queue Stream Error: $error');
    });

    supabase
        .from('rab_queue')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
      print('RAB Queue Stream Update: $data');
      rabQueue.value = data.map((item) {
        return {
          'row_id': item['id'],
          'data': item['data'] as Map<String, dynamic>,
        };
      }).toList();
      print('Updated rabQueue: ${rabQueue.length} items');
    }, onError: (error) {
      print('RAB Queue Stream Error: $error');
    });

    supabase
        .from('ams_queue')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
      print('AMS Queue Stream Update: $data');
      amsQueue.value = data.map((item) {
        return {
          'row_id': item['id'],
          'data': item['data'] as Map<String, dynamic>,
        };
      }).toList();
      print('Updated amsQueue: ${amsQueue.length} items');
    }, onError: (error) {
      print('AMS Queue Stream Error: $error');
    });
  }

  Future<void> _loadInitialData(String userId) async {
    // Muat data awal untuk survey_queue
    final surveyData = await supabase
        .from('survey_queue')
        .select()
        .eq('ulp', ulp)
        .eq('user_id', userId);
    surveyQueue.value = surveyData.map<Map<String, dynamic>>((item) {
      return {
        'row_id': item['id'],
        'data': item['data'] as Map<String, dynamic>,
      };
    }).toList();
    print('Initial surveyQueue load: ${surveyQueue.length} items');

    // Muat data awal untuk rab_queue
    final rabData = await supabase
        .from('rab_queue')
        .select()
        .eq('ulp', ulp)
        .eq('user_id', userId);
    rabQueue.value = rabData.map<Map<String, dynamic>>((item) {
      return {
        'row_id': item['id'],
        'data': item['data'] as Map<String, dynamic>,
      };
    }).toList();
    print('Initial rabQueue load: ${rabQueue.length} items');

    // Muat data awal untuk ams_queue
    final amsData = await supabase
        .from('ams_queue')
        .select()
        .eq('ulp', ulp)
        .eq('user_id', userId);
    amsQueue.value = amsData.map<Map<String, dynamic>>((item) {
      return {
        'row_id': item['id'],
        'data': item['data'] as Map<String, dynamic>,
      };
    }).toList();
    print('Initial amsQueue load: ${amsQueue.length} items');
  }

  Future<void> addPermohonan(Map<String, dynamic> permohonan) async {
    try {
      await supabase.from('survey_queue').insert({
        'user_id': supabase.auth.currentUser?.id,
        'ulp': ulp,
        'data': permohonan,
      });
      print('Successfully added permohonan: $permohonan');
    } catch (e) {
      print('Error adding permohonan: $e');
      Get.snackbar('Error', 'Gagal menambahkan permohonan: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> updatePermohonan(String rowId, Map<String, dynamic> data, String queueType) async {
    String tableName;
    switch (queueType) {
      case 'survey':
        tableName = 'survey_queue';
        break;
      case 'rab':
        tableName = 'rab_queue';
        break;
      case 'ams':
        tableName = 'ams_queue';
        break;
      default:
        throw Exception('Invalid queue type');
    }
    try {
      await supabase.from(tableName).update({'data': data}).eq('id', rowId);
      print('Successfully updated permohonan with rowId: $rowId in $tableName');
    } catch (e) {
      print('Error updating permohonan: $e');
    }
  }

  Future<void> deleteFromQueue(String rowId, String queueType) async {
    String tableName;
    switch (queueType) {
      case 'survey':
        tableName = 'survey_queue';
        break;
      case 'rab':
        tableName = 'rab_queue';
        break;
      case 'ams':
        tableName = 'ams_queue';
        break;
      default:
        throw Exception('Invalid queue type');
    }
    try {
      await supabase.from(tableName).delete().eq('id', rowId);
      print('Successfully deleted from $tableName with rowId: $rowId');
    } catch (e) {
      print('Error deleting from queue: $e');
    }
  }

  Future<void> moveToRabQueue(String rowId) async {
    try {
      // Cari item berdasarkan row_id
      final item = surveyQueue.firstWhere((item) => item['row_id'] == rowId);
      print('Moving item with row_id: $rowId to rab_queue');

      // Insert ke rab_queue
      await supabase.from('rab_queue').insert({
        'user_id': supabase.auth.currentUser?.id,
        'ulp': ulp,
        'data': item['data'],
      });

      // Hapus dari survey_queue
      await deleteFromQueue(rowId, 'survey');

      // Tunggu sebentar untuk memastikan stream Supabase memperbarui data
      await Future.delayed(const Duration(milliseconds: 500));

      // Pastikan UI diperbarui
      surveyQueue.refresh();
      rabQueue.refresh();
      print('Move to RAB successful');
    } catch (e) {
      print('Error moving to RAB queue: $e');
      Get.snackbar('Error', 'Gagal memindahkan data ke Antrian RAB: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> moveToAmsQueue(String rowId) async {
    try {
      final item = rabQueue.firstWhere((item) => item['row_id'] == rowId);
      await supabase.from('ams_queue').insert({
        'user_id': supabase.auth.currentUser?.id,
        'ulp': ulp,
        'data': item['data'],
      });
      await deleteFromQueue(rowId, 'rab');

      await Future.delayed(const Duration(milliseconds: 500));
      rabQueue.refresh();
      amsQueue.refresh();
      print('Move to AMS successful');
    } catch (e) {
      print('Error moving to AMS queue: $e');
      Get.snackbar('Error', 'Gagal memindahkan data ke Antrian AMS: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}