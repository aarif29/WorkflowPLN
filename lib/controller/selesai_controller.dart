import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SelesaiController extends GetxController {
  final GetStorage storage = GetStorage();
  late String group;

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
    // Ambil grup dari GetStorage
    group = storage.read('group') ?? 'default';
    // Muat data selesai berdasarkan grup
    loadSelesai();
  }


  void loadSelesai() {
    // Muat data dari GetStorage dengan prefix grup
    selesaiList.value = (storage.read('${group}_selesaiList') ?? []).cast<Map<String, dynamic>>();
  }

  void addSelesai(Map<String, dynamic> selesaiData) {
    selesaiList.add(selesaiData);
    storage.write('${group}_selesaiList', selesaiList.toList());
  }
}