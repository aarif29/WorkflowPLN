import 'package:flutter/material.dart';
import "beranda.dart";

class PermohonanBaruScreen extends StatefulWidget {
  const PermohonanBaruScreen({super.key});
  @override
  _PermohonanBaruScreenState createState() => _PermohonanBaruScreenState();
}

class _PermohonanBaruScreenState extends State<PermohonanBaruScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController =
      TextEditingController(); // Define the controller for Catatan
  DateTime? _selectedDate;
  String? _selectedApplicationType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Permohonan Baru',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Nomor HP'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Tanggal Permohonan'),
              readOnly: true,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              controller: TextEditingController(
                text:
                    _selectedDate != null
                        ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                        : '',
              ),
            ),
            TextField(
              readOnly: true,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Pilih Jenis Permohonan'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            <String>[
                              'Pasang Baru',
                              'Perubahan Daya',
                              'PFK',
                              'Lainnya',
                            ].map((String value) {
                              return ListTile(
                                title: Text(value),
                                onTap: () {
                                  setState(() {
                                    _selectedApplicationType = value;
                                  });
                                  Navigator.of(context).pop();
                                },
                              );
                            }).toList(),
                      ),
                    );
                  },
                );
              },
              decoration: InputDecoration(
                labelText: 'Jenis Permohonan',
                hintText: 'Pilih Jenis Permohonan',
              ),
              controller: TextEditingController(
                text: _selectedApplicationType ?? '',
              ),
            ),
            SizedBox(height: 16.0), // Added spacing before the save button
            TextField(
              controller:
                  _notesController, // Use the existing controller for Catatan
              decoration: InputDecoration(labelText: 'Catatan'),
            ),
            ElevatedButton(
              onPressed: () {
                // Show confirmation dialog with entered data
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Data Permohonan'),
                      content: Text(
                        'Nama: ${_nameController.text}\n'
                        'Nomor HP: ${_phoneController.text}\n'
                        'Alamat: ${_addressController.text}\n'
                        'Tanggal Permohonan: ${_selectedDate != null ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}" : "Belum dipilih"}\n'
                        'Jenis Permohonan: ${_selectedApplicationType ?? "Belum dipilih"}\n'
                        'Catatan: ${_notesController.text}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('SAVE DATA'),
            ),
          ],
        ),
      ),
    );
  }
}
