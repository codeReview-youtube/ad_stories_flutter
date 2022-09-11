import 'dart:convert';
import 'package:ad_stories/source.dart';

class Product {
  late int id;
  late String title;
  late double price;
  late String description;
  late String image;
  late String category;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.image,
    required this.category,
  });

  factory Product.fromJson(String source) {
    final parsed = jsonDecode(source);
    final id = parsed["id"] as int;
    final title = parsed["title"] as String;
    final price = parsed["price"] as double;
    final description = parsed["description"] as String;
    final image = parsed["image"] as String;
    final category = parsed["category"] as String;
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      image: image,
      category: category,
    );
  }
}

class ProductGroup {
  late String id;
  late List<Product> products;
  late String cover;
  ProductGroup({
    required this.id,
    required this.products,
    required this.cover,
  });

  factory ProductGroup.fromJson(String source) {
    final parsed = jsonDecode(source);
    final id = parsed["id"] as String;
    final cover = parsed["cover"] as String;
    final products = parsed["products"] as List<Product>;
    return ProductGroup(id: id, products: products, cover:cover);
  }
}

final formattedSource = jsonDecode(source).toList();
