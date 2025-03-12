import 'package:flutter/material.dart';

class PermohonanBaruScreen extends StatefulWidget {
  const PermohonanBaruScreen({super.key});
  @override
  PermohonanBaruScreenState createState() => PermohonanBaruScreenState();
}

class PermohonanBaruScreenState extends State<PermohonanBaruScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedApplicationType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Permohonan Baru',
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
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              style: TextStyle(color: Colors.white), // Set text color to white
              decoration: InputDecoration(
                labelText: 'Nama',
                labelStyle: TextStyle(
                  color: Colors.white,
                ), // Set label color to white
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ), // Set border color to white
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ), // Set focused border color to white
                ),
              ),
            ),
            TextField(
              controller: _phoneController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nomor HP',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _addressController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Alamat',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Tanggal Permohonan',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
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
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Jenis Permohonan',
                labelStyle: TextStyle(color: Colors.white),
                hintText: 'Pilih Jenis Permohonan',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
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
              controller: TextEditingController(
                text: _selectedApplicationType ?? '',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _notesController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Catatan',
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
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
