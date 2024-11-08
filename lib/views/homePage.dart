import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market_list_app/controllers/itemController.dart';
import 'package:market_list_app/services/pdfService.dart';
import 'package:rive/rive.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ItemController itemController = Get.put(ItemController());
    final PdfService pdfService = PdfService();

    itemController.loadItems();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await pdfService.generateShoppingListPdf(itemController.items);
            },
            icon: Icon(
              color: Colors.white,
              Icons.picture_as_pdf,
            ),
          ),
        ],
        backgroundColor: Colors.black,
        title: Text(
          'Market List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (itemController.items.isEmpty) {
          return Center(
            child: SizedBox(
              width: 310,
              height: 310,
              child: RiveAnimation.asset(
                'assets/animations/animation.riv',
                fit: BoxFit.cover,
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: itemController.items.length,
          itemBuilder: (context, index) {
            final item = itemController.items[index];
            return ListTile(
              title: Text(item.name),
              subtitle: Text('Quantidade: ${item.quantity}, Status do item: ${item.status}'),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          _dialogAddItem(context, itemController);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _dialogAddItem(BuildContext context, ItemController itemController) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Adicionar Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Quantidade',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
              ),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                final String name = _nameController.text;
                final int? quantity = int.tryParse(_quantityController.text);
                if (name.isNotEmpty && quantity != null) {
                  itemController.addItem(name, quantity);
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Adicionar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
