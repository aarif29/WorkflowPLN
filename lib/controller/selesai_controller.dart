import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SelesaiController extends GetxController {
  final supabase = Supabase.instance.client;
  late String ulp;

  final selesaiList = <Map<String, dynamic>>[].obs;
  final searchQuery = ''.obs;

  List<Map<String, dynamic>> get filteredSelesaiList {
    if (searchQuery.value.isEmpty) {
      return selesaiList;
    }
    return selesaiList.where((permohonan) {
      final nama = permohonan['nama']?.toString().toLowerCase() ?? '';
      final id = permohonan['id']?.toString().toLowerCase() ?? '';
      final query = searchQuery.value.toLowerCase();
      return nama.contains(query) || id.contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    // Ambil ulp dari profil user dan muat data selesai
    fetchUlpAndLoadSelesai();
  }

  Future<void> fetchUlpAndLoadSelesai() async {
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
        .from('selesai')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
      selesaiList.value = data.map((item) => {
        'id': item['id'], // Simpan ID untuk keperluan update atau hapus
        ...item['data'] as Map<String, dynamic>, // Buka data dari kolom 'data'
      }).toList();
    });
  }

  Future<void> addSelesai(Map<String, dynamic> selesaiData) async {
    await supabase.from('selesai').insert({
      'user_id': supabase.auth.currentUser?.id,
      'ulp': ulp,
      'data': selesaiData,
    });
  }
}