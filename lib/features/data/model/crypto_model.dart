import '../../domain/entity/crypto.dart';

class CryptoModel extends Crypto {
  const CryptoModel({
    super.id,
    super.name,
    super.symbol,
    super.price,
    super.priceChangePercentage24h,
    super.image,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
      price: (json['current_price'] as num?)?.toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] as num?)
          ?.toDouble(),
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'symbol': symbol,
      'current_price': price,
      'price_change_percentage_24h': priceChangePercentage24h,
      'image': image,
    };
  }

  @override
  String toString() {
    return '''
CryptoModel(
  id: $id,
  name: $name,
  symbol: $symbol,
  price: $price,
  priceChangePercentage24h: $priceChangePercentage24h,
  image: $image
)
''';
  }

  CryptoModel copyWith({
    String? id,
    String? name,
    String? symbol,
    double? price,
    double? priceChangePercentage24h,
    String? image,
  }) {
    return CryptoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      price: price ?? this.price,
      priceChangePercentage24h:
          priceChangePercentage24h ?? this.priceChangePercentage24h,
      image: image ?? this.image,
    );
  }
}
