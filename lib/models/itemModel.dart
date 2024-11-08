class ItemModel {
  final int? id; 
  final String name;
  final int quantity;
  final String status;

  ItemModel({
    this.id,  
    required this.name,
    required this.quantity,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'name': name,
      'quantity': quantity,
      'status': status,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      status: map['status'],
    );
  }
}
