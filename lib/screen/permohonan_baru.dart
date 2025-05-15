import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class PermohonanBaruScreen extends StatefulWidget {
  final Function(Map<String, String?>) onPermohonanAdded;
  final VoidCallback onNavigateToAntrian;

  const PermohonanBaruScreen({
    super.key,
    required this.onPermohonanAdded,
    required this.onNavigateToAntrian,
  });

  @override
  _PermohonanBaruScreenState createState() => _PermohonanBaruScreenState();
}

class _PermohonanBaruScreenState extends State<PermohonanBaruScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _applicationTypeController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedApplicationType;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dateController.dispose();
    _applicationTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
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
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        color: Colors.black87,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: _buildButton(
                  label: 'Tambah Data',
                  onPressed: _showInputForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 80.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[850],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showInputForm() {
    // Pastikan state bersih sebelum menampilkan form
    _clearControllers(); // Membersihkan controller setiap kali form dibuka
    _selectedDate = null;
    _selectedApplicationType = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black87,
      builder: (context) => _buildInputForm(),
    );
  }

  Widget _buildInputForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16.0,
        right: 16.0,
        top: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(_nameController, 'Nama'),
          _buildTextField(_phoneController, 'Nomor HP', TextInputType.phone),
          _buildTextField(_addressController, 'Alamat'),
          _buildDateField(),
          const SizedBox(height: 12.0),
          _buildApplicationTypeField(),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _saveData,
            child: const Text('SIMPAN DATA'),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.black87,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return TextField(
      controller: _dateController,
      style: const TextStyle(color: Colors.white),
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Tanggal Permohonan',
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.black87,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(), // Gunakan tanggal terpilih atau sekarang
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          builder: (context, child) {
            return Theme(
              data: ThemeData.dark(), // Atau sesuaikan tema date picker Anda
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
            _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
    );
  }

  Widget _buildApplicationTypeField() {
    return TextField(
      controller: _applicationTypeController,
      style: const TextStyle(color: Colors.white),
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Jenis Permohonan',
        labelStyle: const TextStyle(color: Colors.white),
        hintText: 'Pilih Jenis Permohonan',
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.black87,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.black87,
            title: const Text(
              'Pilih Jenis Permohonan',
              style: TextStyle(color: Colors.white),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['Pasang Baru', 'Perubahan Daya', 'PFK', 'Lainnya']
                  .map(
                    (type) => ListTile(
                      title: Text(
                        type,
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedApplicationType = type;
                          _applicationTypeController.text = type;
                        });
                        Navigator.pop(context); // Tutup dialog pilih jenis
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }

 void _saveData() {
  // Validasi input
  if (_nameController.text.isEmpty) {
    _showErrorSnackbar('Nama tidak boleh kosong');
    return;
  }

  if (_applicationTypeController.text.isEmpty) {
    _showErrorSnackbar('Jenis permohonan tidak boleh kosong');
    return;
  }

  final newPermohonan = {
    'name': _nameController.text,
    'phone': _phoneController.text,
    'address': _addressController.text,
    'dateSurvey': _dateController.text,
    'applicationType': _applicationTypeController.text,
    'notes': '',
  };

  try {
    widget.onPermohonanAdded(newPermohonan);
    Navigator.pop(context);     
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onNavigateToAntrian();
      }
    });

  } catch (e) {
    _showErrorSnackbar('Gagal menambahkan permohonan: ${e.toString()}');
  }
}

void _showErrorSnackbar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
    ),
  );
}

void _showSuccessSnackbar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 2),
    ),
  );
}

  void _clearControllers() {
    _nameController.clear();
    _phoneController.clear();
    _addressController.clear();
    _dateController.clear();
    _applicationTypeController.clear();
    // Reset juga variabel state yang menampung nilai terpilih
    // Ini penting agar saat form dibuka lagi, tidak ada nilai sisa
    // setState(() { // Tidak perlu setState jika hanya membersihkan controller
    //   _selectedDate = null;
    //   _selectedApplicationType = null;
    // });
  }
}