class Product {
  final String id;
  String name;
  String description;
  double price;
  int stockQuantity;
  String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      stockQuantity: json['stockQuantity'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'stockQuantity': stockQuantity,
      'category': category,
    };
  }
}
