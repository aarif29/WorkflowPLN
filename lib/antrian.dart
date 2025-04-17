import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/antrian_controller.dart';
import '../controller/selesai_controller.dart';

class AntrianScreen extends StatelessWidget {
  const AntrianScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AntrianController());
    Get.put(SelesaiController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Antrian Permohonan'),
        backgroundColor: Colors.black87,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        color: Colors.black87,
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => _buildQueueCard(
                  'Antrian Survey',
                  controller.surveyQueue,
                  'survey',
                  controller,
                ),
              ),
              Obx(
                () => _buildQueueCard(
                  'Antrian RAB',
                  controller.rabQueue,
                  'rab',
                  controller,
                ),
              ),
              Obx(
                () => _buildQueueCard(
                  'Antrian AMS',
                  controller.amsQueue,
                  'ams',
                  controller,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQueueCard(
    String title,
    RxList<Map<String, dynamic>> queue,
    String queueType,
    AntrianController controller,
  ) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: _getQueueColor(queueType),
                    offset: const Offset(1.0, 1.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            queue.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Text(
                        'Tidak ada data',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: queue.length,
                    itemBuilder: (context, index) {
                      final permohonan = queue[index];
                      return _buildListItem(
                        context,
                        permohonan,
                        index,
                        queueType,
                        controller,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    Map<String, dynamic> permohonan,
    int index,
    String queueType,
    AntrianController controller,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: _getQueueColor(queueType), width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getQueueColor(queueType),
          child: Text(
            '${index + 1}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          permohonan['name']?.toString() ?? 'No Name',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (permohonan['dateSurvey'] != null)
              _buildSubtitleText(
                'Survey: ${DateFormat('d MMMM y', 'id').format(DateTime.parse(permohonan['dateSurvey'].toString()))}',
                queueType,
              ),
            if (permohonan['rabCompletionDate'] != null && queueType == 'ams')
              _buildSubtitleText(
                'Selesai RAB: ${DateFormat('d MMMM y', 'id').format(DateTime.parse(permohonan['rabCompletionDate'].toString()))}',
                queueType,
              ),
            if (permohonan['keterangan'] != null &&
                (permohonan['keterangan']?.toString() ?? '').isNotEmpty &&
                queueType == 'ams')
              _buildSubtitleText(
                'Catatan RAB: ${permohonan['keterangan']}',
                queueType,
              ),
          ],
        ),
        onTap: () => _showDetailDialog(
          context,
          permohonan,
          index,
          queueType,
          controller,
        ),
      ),
    );
  }

  Widget _buildSubtitleText(String text, String queueType) {
    return Padding(
      padding: const EdgeInsets.only(top: 1.0, bottom: 1.0),
      child: Text(
        text,
        style: TextStyle(color: _getQueueColor(queueType), fontSize: 12),
      ),
    );
  }

  void _showDetailDialog(
    BuildContext context,
    Map<String, dynamic> permohonan,
    int index,
    String queueType,
    AntrianController controller,
  ) {
    final name = RxString(permohonan['name']?.toString() ?? '');
    final phone = RxString(permohonan['phone']?.toString() ?? '');
    final address = RxString(permohonan['address']?.toString() ?? '');
    final applicationType = RxString(permohonan['applicationType']?.toString() ?? '');
    final notes = RxString(permohonan['notes']?.toString() ?? '');
    final dateSurvey = RxString(permohonan['dateSurvey']?.toString() ?? '');
    final keterangan = RxString(permohonan['keterangan']?.toString() ?? '');
    final rabCompletionDate = RxString(permohonan['rabCompletionDate']?.toString() ?? '');
    final noAms = RxString('');

    final nameController = TextEditingController(text: name.value);
    final phoneController = TextEditingController(text: phone.value);
    final addressController = TextEditingController(text: address.value);
    final applicationTypeController = TextEditingController(
      text: applicationType.value,
    );
    final notesController = TextEditingController(text: notes.value);
    final keteranganController = TextEditingController(text: keterangan.value);
    final noAmsController = TextEditingController();

    final selectedDate = Rx<DateTime?>(null);
    final selectedRabCompletionDate = Rx<DateTime?>(null);

    nameController.addListener(() {
      name.value = nameController.text;
    });
    phoneController.addListener(() {
      phone.value = phoneController.text;
    });
    addressController.addListener(() {
      address.value = addressController.text;
    });
    applicationTypeController.addListener(() {
      applicationType.value = applicationTypeController.text;
    });
    notesController.addListener(() {
      notes.value = notesController.text;
    });
    keteranganController.addListener(() {
      keterangan.value = keteranganController.text;
    });
    noAmsController.addListener(() {
      noAms.value = noAmsController.text;
    });

    Get.dialog(
      Obx(
        () => Dialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: _getQueueColor(queueType), width: 2.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detail Permohonan',
                    style: TextStyle(
                      color: _getQueueColor(queueType),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('Nama', name, nameController),
                  _buildTextField('Nomor HP', phone, phoneController),
                  _buildTextField('Alamat', address, addressController),
                  _buildTextField(
                    'Jenis Permohonan',
                    applicationType,
                    applicationTypeController,
                  ),
                  _buildTextField('Catatan', notes, notesController),
                  if (queueType == 'survey') ...[
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (context, child) => Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Colors.blueAccent,
                                onPrimary: Colors.white,
                                surface: Colors.black,
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (pickedDate != null) {
                          selectedDate.value = pickedDate;
                          dateSurvey.value = pickedDate.toString();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: const Text(
                        'Set Tanggal Survey',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (selectedDate.value != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Tanggal Survey: ${DateFormat('d MMMM y', 'id').format(selectedDate.value!)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionButton(
                          'Simpan',
                          Colors.green,
                          () => _updateAndClose(controller, index, queueType, {
                            'name': name.value,
                            'phone': phone.value,
                            'address': address.value,
                            'applicationType': applicationType.value,
                            'notes': notes.value,
                            'dateSurvey': dateSurvey.value,
                            'keterangan': keterangan.value,
                          }),
                        ),
                        _buildActionButton(
                          'Hapus',
                          Colors.red,
                          () => _showDeleteConfirmation(
                            context,
                            controller,
                            index,
                            queueType,
                          ),
                        ),
                      ],
                    ),
                    if (dateSurvey.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: _buildActionButton(
                          'Selesai Survey',
                          Colors.orange,
                          () {
                            _updateAndClose(controller, index, queueType, {
                              'name': name.value,
                              'phone': phone.value,
                              'address': address.value,
                              'applicationType': applicationType.value,
                              'notes': notes.value,
                              'dateSurvey': dateSurvey.value,
                              'keterangan': keterangan.value,
                            });
                            controller.moveToRabQueue(index);
                            Get.snackbar(
                              'Sukses',
                              'Permohonan dipindahkan ke Antrian RAB',
                              backgroundColor: Colors.orange,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 2),
                              titleText: const Text(
                                'Sukses',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              messageText: const Text(
                                'Permohonan dipindahkan ke Antrian RAB',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          },
                          fullWidth: true,
                        ),
                      ),
                  ],
                  if (queueType == 'rab') ...[
                    const SizedBox(height: 8),
                    TextField(
                      controller: keteranganController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: 'Keterangan RAB',
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: _getQueueColor(queueType),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          builder: (context, child) => Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Colors.orangeAccent,
                                onPrimary: Colors.white,
                                surface: Colors.black,
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (pickedDate != null) {
                          selectedRabCompletionDate.value = pickedDate;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                      ),
                      child: const Text(
                        'Tanggal selesai RAB',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    if (selectedRabCompletionDate.value != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Tanggal Selesai: ${DateFormat('d MMMM y', 'id').format(selectedRabCompletionDate.value!)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionButton(
                          'Simpan',
                          Colors.green,
                          () => _updateAndClose(controller, index, queueType, {
                            'name': name.value,
                            'phone': phone.value,
                            'address': address.value,
                            'applicationType': applicationType.value,
                            'notes': notes.value,
                            'dateSurvey': dateSurvey.value,
                            'keterangan': keterangan.value,
                          }),
                        ),
                        _buildActionButton(
                          'Hapus',
                          Colors.red,
                          () => _showDeleteConfirmation(
                            context,
                            controller,
                            index,
                            queueType,
                          ),
                        ),
                      ],
                    ),
                    if (selectedRabCompletionDate.value != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: _buildActionButton(
                          'Selesai RAB',
                          Colors.green,
                          () {
                            _updateAndClose(controller, index, queueType, {
                              'name': name.value,
                              'phone': phone.value,
                              'address': address.value,
                              'applicationType': applicationType.value,
                              'notes': notes.value,
                              'dateSurvey': dateSurvey.value,
                              'keterangan': keterangan.value,
                              'status': 'completed',
                              'rabCompletionDate':
                                  selectedRabCompletionDate.value.toString(),
                            });
                            controller.moveToAmsQueue(index);
                            Get.snackbar(
                              'Sukses',
                              'Permohonan dipindahkan ke Antrian AMS',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 2),
                              titleText: const Text(
                                'Sukses',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              messageText: const Text(
                                'Permohonan dipindahkan ke Antrian AMS',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          },
                          fullWidth: true,
                        ),
                      ),
                  ],
                  if (queueType == 'ams') ...[
                    if (rabCompletionDate.value.isNotEmpty)
                      _buildInfoContainer(
                        Icons.calendar_today,
                        'Selesai RAB: ${DateFormat('d MMMM y', 'id').format(DateTime.parse(rabCompletionDate.value))}',
                        queueType,
                      ),
                    if (keterangan.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            border: Border.all(
                              color: _getQueueColor(queueType),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.note_alt,
                                    color: _getQueueColor(queueType),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Catatan RAB:',
                                    style: TextStyle(
                                      color: _getQueueColor(queueType),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                keterangan.value,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: noAmsController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'No. AMS',
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: _getQueueColor(queueType),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: _buildActionButton(
                        'Hapus',
                        Colors.red,
                        () => _showDeleteConfirmation(
                          context,
                          controller,
                          index,
                          queueType,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                    if (noAms.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: _buildActionButton(
                          'Selesaikan Permohonan',
                          Colors.green,
                          () {
                            final selesaiData = {
                              'id': noAms.value,
                              'nama': name.value,
                              'phone': phone.value,
                              'address': address.value,
                              'applicationType': applicationType.value,
                              'notes': notes.value,
                              'dateSurvey': dateSurvey.value,
                              'keterangan': keterangan.value,
                              'rabCompletionDate': rabCompletionDate.value,
                              'tanggal': DateFormat(
                                'yyyy-MM-dd',
                              ).format(DateTime.now()),
                              'status': 'Selesai',
                            };
                            Get.find<SelesaiController>().addSelesai(
                              selesaiData,
                            );
                            controller.deleteFromQueue(index, queueType);
                            Get.back();
                            Get.snackbar(
                              'Sukses',
                              'Permohonan telah selesai',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                              duration: const Duration(seconds: 2),
                              titleText: const Text(
                                'Sukses',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              messageText: const Text(
                                'Permohonan telah selesai',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            );
                          },
                          fullWidth: true,
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    AntrianController controller,
    int index,
    String queueType,
  ) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text(
          'Konfirmasi Hapus',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus permohonan ini?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Tidak',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteFromQueue(index, queueType);
              Get.back();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.snackbar(
                  '',
                  '',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                  titleText: const Text(
                    'Sukses',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  messageText: const Text(
                    'Permohonan berhasil dihapus',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                );
              });
            },
            child: const Text('Ya', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    RxString value,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    Color color,
    VoidCallback onPressed, {
    bool fullWidth = false,
    EdgeInsets? padding,
  }) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: padding,
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildInfoContainer(IconData icon, String text, String queueType) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.black54,
        border: Border.all(color: _getQueueColor(queueType), width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: _getQueueColor(queueType), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: _getQueueColor(queueType),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateAndClose(
    AntrianController controller,
    int index,
    String queueType,
    Map<String, dynamic> data,
  ) {
    controller.updatePermohonan(index, data, queueType);
    Get.back();
  }

  Color _getQueueColor(String queueType) {
    switch (queueType) {
      case 'survey':
        return Colors.blueAccent;
      case 'rab':
        return Colors.orangeAccent;
      case 'ams':
        return Colors.greenAccent;
      default:
        return Colors.white;
    }
  }
}