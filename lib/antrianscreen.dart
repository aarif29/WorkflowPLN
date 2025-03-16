import 'package:flutter/material.dart';

class AntrianScreen extends StatelessWidget {
  final List<Map<String, String?>> permohonanList;

  const AntrianScreen({super.key, required this.permohonanList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              permohonanList.isEmpty
                  ? Center(
                    child: Text(
                      'Belum ada data untuk ditampilkan',
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  )
                  : ListView.builder(
                    itemCount: permohonanList.length,
                    itemBuilder: (context, index) {
                      final permohonan = permohonanList[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 4.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ), // Rounded circular outline
                        ),
                        child: Card(
                          color: Colors.grey[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              18.0,
                            ), // Slightly smaller than container
                          ),
                          margin: EdgeInsets.all(
                            1.0,
                          ), // Small margin to show the outline
                          child: ListTile(
                            leading: Text(
                              '${index + 1}.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                            title: Text(
                              permohonan['name'] ?? 'No Name',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () => _showDetailDialog(context, permohonan),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }

  void _showDetailDialog(
    BuildContext context,
    Map<String, String?> permohonan,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.black87,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detail Permohonan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._buildDetailItems(permohonan),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  List<Widget> _buildDetailItems(Map<String, String?> permohonan) {
    return [
          'Nama: ${permohonan['name']}',
          'Nomor HP: ${permohonan['phone']}',
          'Alamat: ${permohonan['address']}',
          'Tanggal: ${permohonan['date']}',
          'Jenis: ${permohonan['applicationType']}',
          'Catatan: ${permohonan['notes']}',
        ]
        .map(
          (text) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        )
        .toList();
  }
}
