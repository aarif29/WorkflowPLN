import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import package intl

class AntrianScreen extends StatefulWidget {
  final List<Map<String, String?>> permohonanList;

  const AntrianScreen({super.key, required this.permohonanList});

  @override
  State<AntrianScreen> createState() => _AntrianScreenState();
}

class _AntrianScreenState extends State<AntrianScreen> {
  void _updatePermohonan(int index, Map<String, String?> updatedPermohonan) {
    setState(() {
      widget.permohonanList[index] = updatedPermohonan;
    });
  }

  void _deletePermohonan(int index) {
    setState(() {
      widget.permohonanList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Antrian Survey',
          style: TextStyle(
            color: Colors.white, // Change title color to white
            fontSize: 24.0, // Increase font size
            shadows: [
              Shadow(
                color: Colors.blue, // Add blue shadow
                offset: Offset(2.0, 2.0), // Shadow offset
                blurRadius: 4.0, // Shadow blur radius
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black87, // Make the AppBar background black
        iconTheme: IconThemeData(
          color: Colors.white,
        ), // Change back button color to white
        elevation: 0, // Remove shadow
      ),
      body: Container(
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: widget.permohonanList.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada data untuk ditampilkan',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  itemCount: widget.permohonanList.length,
                  itemBuilder: (context, index) {
                    final permohonan = widget.permohonanList[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2.0),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Card(
                        color: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        margin: const EdgeInsets.all(1.0),
                        child: ListTile(
                          leading: Text(
                            '${index + 1}.',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                          title: Text(
                            permohonan['name'] ?? 'No Name',
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: permohonan['dateSurvey'] != null
                              ? Text(
                                  'Survey: ${DateFormat('d MMMM y', 'id').format(DateTime.parse(permohonan['dateSurvey']!))}',
                                  style: const TextStyle(
                                      color: Colors.cyanAccent, fontSize: 14),
                                )
                              : null,
                          onTap: () => _showDetailDialog(context, permohonan, index),
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
    int index,
  ) {
    DateTime? selectedDate;

    final _formKey = GlobalKey<FormState>();
    String? name = permohonan['name'];
    String? phone = permohonan['phone'];
    String? address = permohonan['address'];
    String? date = permohonan['date'];
    String? applicationType = permohonan['applicationType'];
    String? notes = permohonan['notes'];
    String? dateSurvey = permohonan['dateSurvey'];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: Colors.black87,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: _formKey,
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
                      TextFormField(
                        initialValue: name,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Nama',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => name = value,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Nomor HP',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => phone = value,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: address,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Alamat',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => address = value,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: date,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Tanggal Permohonan',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => date = value,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: applicationType,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Jenis Permohonan',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => applicationType = value,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: notes,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Catatan',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => notes = value,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: const ColorScheme.dark(
                                        primary: Color.fromARGB(255, 0, 204, 255),
                                        onPrimary: Colors.white,
                                        surface: Colors.black,
                                        onSurface: Colors.white,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  selectedDate = pickedDate;
                                  dateSurvey = pickedDate.toString();
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Survey', style: TextStyle(color: Colors.white)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _updatePermohonan(index, {
                                'name': name,
                                'phone': phone,
                                'address': address,
                                'date': date,
                                'applicationType': applicationType,
                                'notes': notes,
                                'dateSurvey': dateSurvey,
                              });
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showDeleteConfirmation(context, index);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      if (selectedDate != null) ...[
                        const SizedBox(height: 8),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _updatePermohonan(index, {
                                'name': name,
                                'phone': phone,
                                'address': address,
                                'date': date,
                                'applicationType': applicationType,
                                'notes': notes,
                                'dateSurvey': dateSurvey,
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Center(
                                    child: Text(
                                      'Permohonan telah didelegasikan',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: const Text('Delegasikan', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            'Konfirmasi Penghapusan',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Apakah Anda yakin ingin menghapus permohonan ini?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _deletePermohonan(index);
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Tutup dialog detail permohonan
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
