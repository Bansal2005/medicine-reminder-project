import 'package:flutter/material.dart';
import 'add_medicine_screen.dart';
import 'package:provider/provider.dart';
import '../providers/medicine_provider.dart';



class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Reminder'),
        backgroundColor: Colors.teal,
      ),

      body: Consumer<MedicineProvider>(
  builder: (context, provider, child) {
    if (provider.medicines.isEmpty) {
      return const Center(
        child: Text(
          'No medicines added yet',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: provider.medicines.length,
      itemBuilder: (context, index) {
        final med = provider.medicines[index];
        final time =
            '${med.hour.toString().padLeft(2, '0')}:${med.minute.toString().padLeft(2, '0')}';

        return ListTile(
          title: Text(med.name),
          subtitle: Text('Dose: ${med.dose}'),
          trailing: Text(time),
        );
      },
    );
  },
),


      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
       onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const AddMedicineScreen(),
    ),
  );
},

        child: const Icon(Icons.add),
      ),
    );
  }
}
