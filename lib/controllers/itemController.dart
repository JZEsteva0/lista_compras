import 'package:get/get.dart';
import 'package:market_list_app/db/databaseHelper.dart';
import 'package:market_list_app/models/itemModel.dart';

class ItemController extends GetxController {
  var items = <ItemModel>[].obs;

  
  Future<void> loadItems() async {
    final dbItems = await DatabaseHelper.instance.getItems(status: 'Não Comprado');
    items.value = dbItems;
  }

  Future<void> addItem(String name, int quantity) async {
    final newItem = ItemModel(
      name: name,
      quantity: quantity,
      status: 'Não Comprado',
    );
    await DatabaseHelper.instance.insertItem(newItem);
    items.add(newItem); 
  }
}
