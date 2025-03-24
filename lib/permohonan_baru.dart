import 'package:flutter/material.dart';

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
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _applicationTypeController =
      TextEditingController();

  DateTime? _selectedDate;
  String? _selectedApplicationType;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
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
                    color: Colors.white, // Warna outline putih
                    width: 2.0, // Ketebalan outline
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
          const SizedBox(height: 12.0), // Spasi setelah Tanggal Permohonan
          _buildApplicationTypeField(),
          const SizedBox(height: 12.0), // Spasi setelah Jenis Permohonan
          _buildTextField(_notesController, 'Catatan'),
          const SizedBox(height: 16.0), // Spasi setelah Catatan
          ElevatedButton(
            onPressed: _saveData,
            child: const Text('SIMPAN DATA'),
          ),
          const SizedBox(height: 16.0), // Spasi setelah Tombol Simpan
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
          borderSide: BorderSide(
            color: Colors.white,
          ), // Outline putih saat tidak fokus
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ), // Outline putih saat fokus
        ),
      ),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          builder: (context, child) {
                            return Theme(
                              data: ThemeData.dark(),
                              child: child!,
                            );
                          },
        );
        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
            _dateController.text =
                "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
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
        borderSide: BorderSide(color: Colors.blueAccent), // Warna biru saat fokus
      ),
    ),
    onTap: () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.black87, // Tema gelap
          title: const Text(
            'Pilih Jenis Permohonan',
            style: TextStyle(color: Colors.white), // Warna teks putih
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Pasang Baru', 'Perubahan Daya', 'PFK', 'Lainnya']
                .map(
                  (type) => ListTile(
                    title: Text(
                      type,
                      style: const TextStyle(color: Colors.white), // Warna teks putih
                    ),
                    onTap: () {
                      setState(() {
                        _selectedApplicationType = type;
                        _applicationTypeController.text = type;
                      });
                      Navigator.pop(context);
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
    final newPermohonan = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'date': _dateController.text,
      'applicationType': _applicationTypeController.text,
      'notes': _notesController.text,
    };

    widget.onPermohonanAdded(newPermohonan);

    _clearControllers();
    _showSuccessMessage();
    Navigator.pop(context);
  }

  void _clearControllers() {
    _nameController.clear();
    _phoneController.clear();
    _addressController.clear();
    _dateController.text = 'Belum dipilih';
    _applicationTypeController.text = 'Belum dipilih';
    _notesController.clear();
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Data berhasil disimpan!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}