class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final String brand;
  final String sku;
  final double weight;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final String returnPolicy;
  final List<String> tags;
  final List<String> images;
  final String thumbnail;
  int quantity;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.returnPolicy,
    required this.tags,
    required this.images,
    required this.thumbnail,
    this.quantity = 1,
  });

  double get discountedPrice {
    return price * (1 - discountPercentage / 100);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] ?? 0,  // Default value for null
    title: json['title'] ?? 'Unknown Product',
    description: json['description'] ?? 'No description available',
    category: json['category'] ?? 'Unknown Category',
    price: (json['price'] ?? 0).toDouble(),
    discountPercentage: (json['discountPercentage'] ?? 0).toDouble(),
    rating: (json['rating'] ?? 0).toDouble(),
    stock: json['stock'] ?? 0,
    brand: json['brand'] ?? 'No Brand',
    sku: json['sku'] ?? 'Unknown SKU',
    weight: (json['weight'] ?? 0).toDouble(),
    warrantyInformation: json['warrantyInformation'] ?? 'No Warranty Info',
    shippingInformation: json['shippingInformation'] ?? 'No Shipping Info',
    availabilityStatus: json['availabilityStatus'] ?? 'Unknown',
    returnPolicy: json['returnPolicy'] ?? 'No Return Policy',
    tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    thumbnail: json['thumbnail'] ?? 'https://via.placeholder.com/150',
  );
}


  // Copy method to update quantity
  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      title: title,
      description: description,
      category: category,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      brand: brand,
      sku: sku,
      weight: weight,
      warrantyInformation: warrantyInformation,
      shippingInformation: shippingInformation,
      availabilityStatus: availabilityStatus,
      returnPolicy: returnPolicy,
      tags: tags,
      images: images,
      thumbnail: thumbnail,
      quantity: quantity ?? this.quantity,
    );
  }
}
