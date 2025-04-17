import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SelesaiController extends GetxController {
  // Daftar permohonan selesai asli
  final RxList<Map<String, dynamic>> selesaiList = <Map<String, dynamic>>[].obs;
  // Daftar permohonan yang sudah difilter
  final RxList<Map<String, dynamic>> filteredSelesaiList = <Map<String, dynamic>>[].obs;
  // Kata kunci pencarian
  final RxString searchQuery = ''.obs;

  // Inisialisasi GetStorage
  final GetStorage storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Muat data dari penyimpanan lokal saat controller diinisialisasi
    loadDataFromStorage();
    // Inisialisasi filteredSelesaiList dengan semua data saat pertama kali
    filteredSelesaiList.assignAll(selesaiList);
    // Dengarkan perubahan pada searchQuery dan filter daftar
    ever(searchQuery, (_) => filterSelesaiList());
    // Dengarkan perubahan pada selesaiList untuk memperbarui filteredSelesaiList
    ever(selesaiList, (_) => filterSelesaiList());
    // Simpan data ke penyimpanan lokal setiap kali selesaiList berubah
    ever(selesaiList, (_) => saveDataToStorage());
  }

  void loadDataFromStorage() {
    // Muat data dari penyimpanan lokal
    final List<dynamic>? storedSelesaiList = storage.read('selesaiList');
    if (storedSelesaiList != null) {
      selesaiList.assignAll(storedSelesaiList.cast<Map<String, dynamic>>());
    }
  }

  void saveDataToStorage() {
    // Simpan data ke penyimpanan lokal
    storage.write('selesaiList', selesaiList.toList());
  }

  // Fungsi untuk menambahkan permohonan selesai
  void addSelesai(Map<String, dynamic> permohonan) {
    selesaiList.add(permohonan);
    // filterSelesaiList akan dipanggil otomatis melalui ever(selesaiList, ...)
  }

  // Fungsi untuk memfilter daftar berdasarkan kata kunci
  void filterSelesaiList() {
    print('Filtering with query: ${searchQuery.value}');
    print('Original list: ${selesaiList.length} items');
    if (searchQuery.value.isEmpty) {
      filteredSelesaiList.assignAll(selesaiList);
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredSelesaiList.assignAll(selesaiList.where((permohonan) {
        final id = permohonan['id']?.toString().toLowerCase() ?? '';
        final nama = permohonan['nama']?.toString().toLowerCase() ?? '';
        final match = id.contains(query) || nama.contains(query);
        print('Permohonan: $nama, No. AMS: $id, Match: $match');
        return match;
      }).toList());
    }
    print('Filtered list: ${filteredSelesaiList.length} items');
  }
}