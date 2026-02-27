abstract class Crypto {
  final String? id;
  final String? name;
  final String? symbol;
  final double? price;
  final double? priceChangePercentage24h;
  final String? image;

  const Crypto({
    this.id,
    this.name,
    this.symbol,
    this.price,
    this.priceChangePercentage24h,
    this.image,
  });
}
