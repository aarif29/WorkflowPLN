import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    if (userId == null) return;

    // Ambil ulp dari tabel profiles
    final profileResponse = await supabase
        .from('profiles')
        .select('ulp')
        .eq('id', userId)
        .single();

    ulp = profileResponse['ulp'] ?? 'default';

    // Stream data dari Supabase untuk real-time update
    supabase
        .from('survey_queue')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
      surveyQueue.value = data.map((item) => item['data'] as Map<String, dynamic>).toList();
    });

    supabase
        .from('rab_queue')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
      rabQueue.value = data.map((item) => item['data'] as Map<String, dynamic>).toList();
    });

    supabase
        .from('ams_queue')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
      amsQueue.value = data.map((item) => item['data'] as Map<String, dynamic>).toList();
    });
  }

  Future<void> addPermohonan(Map<String, dynamic> permohonan) async {
    await supabase.from('survey_queue').insert({
      'user_id': supabase.auth.currentUser?.id,
      'ulp': ulp,
      'data': permohonan,
    });
  }

  Future<void> updatePermohonan(String id, Map<String, dynamic> data, String queueType) async {
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
    await supabase.from(tableName).update({'data': data}).eq('id', id);
  }

  Future<void> deleteFromQueue(String id, String queueType) async {
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
    await supabase.from(tableName).delete().eq('id', id);
  }

  Future<void> moveToRabQueue(String id) async {
    final item = surveyQueue.firstWhere((item) => item['id'] == id);
    await supabase.from('rab_queue').insert({
      'user_id': supabase.auth.currentUser?.id,
      'ulp': ulp,
      'data': item,
    });
    await deleteFromQueue(id, 'survey');
  }

  Future<void> moveToAmsQueue(String id) async {
    final item = rabQueue.firstWhere((item) => item['id'] == id);
    await supabase.from('ams_queue').insert({
      'user_id': supabase.auth.currentUser?.id,
      'ulp': ulp,
      'data': item,
    });
    await deleteFromQueue(id, 'rab');
  }
}