import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/medicine.dart';
import '../providers/medicine_provider.dart';
import '../services/notification_service.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController doseController = TextEditingController();

  TimeOfDay? selectedTime;

  void pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  void saveMedicine() {
    if (nameController.text.isEmpty ||
        doseController.text.isEmpty ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // 1️⃣ Create Medicine object
    final medicine = Medicine(
      name: nameController.text,
      dose: doseController.text,
      hour: selectedTime!.hour,
      minute: selectedTime!.minute,
    );

    // 2️⃣ Save to Provider
    Provider.of<MedicineProvider>(context, listen: false)
        .addMedicine(medicine);

    // 3️⃣ Schedule Notification
    final now = DateTime.now();
    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    NotificationService.scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: 'Medicine Reminder',
      body: 'Time to take ${nameController.text}',
      scheduledTime: scheduledTime,
    );

    // 4️⃣ Go back
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Medicine Name',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: doseController,
              decoration: const InputDecoration(
                labelText: 'Dose',
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedTime == null
                        ? 'No time selected'
                        : 'Time: ${selectedTime!.format(context)}',
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: pickTime,
                  child: const Text('Pick Time'),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                onPressed: saveMedicine,
                child: const Text('Save Medicine'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
