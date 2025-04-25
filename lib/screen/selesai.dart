import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/selesai_controller.dart';
import 'package:intl/intl.dart';

class SelesaiScreen extends StatelessWidget {
  SelesaiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selesaiController = Get.find<SelesaiController>();
    // Controller untuk TextField pencarian
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Permohonan Selesai',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            shadows: [
              Shadow(
                color: Colors.blue,
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0,
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          // TextField untuk pencarian
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Cari permohonan (No. AMS, nama)...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.white54),
                suffixIcon: Obx(() => selesaiController.searchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          searchController.clear();
                          selesaiController.searchQuery.value = '';
                        },
                      )
                    : const SizedBox.shrink()),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.white54),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: Colors.greenAccent),
                ),
              ),
              onChanged: (value) {
                selesaiController.searchQuery.value = value;
              },
            ),
          ),
          // Daftar permohonan yang sudah difilter
          Expanded(
            child: Obx(() => selesaiController.filteredSelesaiList.isEmpty
                ? const Center(
                    child: Text(
                      'Tidak ada permohonan yang cocok',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: selesaiController.filteredSelesaiList.length,
                    itemBuilder: (context, index) {
                      final permohonan = selesaiController.filteredSelesaiList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        color: Colors.grey[850],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          side: const BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.check_circle, color: Colors.green),
                          title: Text(
                            permohonan['nama']?.toString() ?? '',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            'No. AMS: ${permohonan['id']?.toString() ?? ''}',
                            style: TextStyle(color: Colors.grey[300]),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                permohonan['status']?.toString() ?? '',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.info_outline, color: Colors.white),
                                onPressed: () => _showDetailDialog(context, permohonan),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, Map<String, dynamic> permohonan) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Colors.greenAccent, width: 2.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Permohonan Selesai',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildReadOnlyField('No. AMS', permohonan['id']?.toString() ?? ''),
                _buildReadOnlyField('Nama', permohonan['nama']?.toString() ?? ''),
                _buildReadOnlyField('Nomor HP', permohonan['phone']?.toString() ?? ''),
                _buildReadOnlyField('Alamat', permohonan['address']?.toString() ?? ''),
                _buildReadOnlyField('Jenis Permohonan', permohonan['applicationType']?.toString() ?? ''),
                _buildReadOnlyField('Catatan', permohonan['notes']?.toString() ?? ''),
                if (permohonan['dateSurvey'] != null && (permohonan['dateSurvey']?.toString() ?? '').isNotEmpty)
                  _buildReadOnlyField(
                    'Tanggal Survey',
                    DateFormat('d MMMM y', 'id').format(DateTime.parse(permohonan['dateSurvey']!.toString())),
                  ),
                if (permohonan['rabCompletionDate'] != null && (permohonan['rabCompletionDate']?.toString() ?? '').isNotEmpty)
                  _buildReadOnlyField(
                    'Tanggal Selesai RAB',
                    DateFormat('d MMMM y', 'id').format(DateTime.parse(permohonan['rabCompletionDate']!.toString())),
                  ),
                if (permohonan['keterangan'] != null && (permohonan['keterangan']?.toString() ?? '').isNotEmpty)
                  _buildReadOnlyField(
                    'Catatan RAB',
                    permohonan['keterangan']?.toString() ?? '',
                  ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Tutup', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border.all(color: Colors.white54),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Text(
              value.isEmpty ? 'Tidak ada data' : value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}