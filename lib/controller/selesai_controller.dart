import 'package:get/get.dart';

class SelesaiController extends GetxController {
  // Daftar permohonan selesai asli
  final RxList<Map<String, String>> selesaiList = <Map<String, String>>[].obs;
  // Daftar permohonan yang sudah difilter
  final RxList<Map<String, String>> filteredSelesaiList = <Map<String, String>>[].obs;
  // Kata kunci pencarian
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi filteredSelesaiList dengan semua data saat pertama kali
    filteredSelesaiList.assignAll(selesaiList);
    // Dengarkan perubahan pada searchQuery dan filter daftar
    ever(searchQuery, (_) => filterSelesaiList());
    // Dengarkan perubahan pada selesaiList untuk memperbarui filteredSelesaiList
    ever(selesaiList, (_) => filterSelesaiList());
  }

  // Fungsi untuk menambahkan permohonan selesai
  void addSelesai(Map<String, String> permohonan) {
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
        final id = permohonan['id']?.toLowerCase() ?? '';
        final nama = permohonan['nama']?.toLowerCase() ?? '';
        final match = id.contains(query) || nama.contains(query);
        print('Permohonan: $nama, No. AMS: $id, Match: $match');
        return match;
      }).toList());
    }
    print('Filtered list: ${filteredSelesaiList.length} items');
  }
}