class CryptoListingModel {
  final String symbol;
  final String name;
  final double price;
  final double variantionLast24Hours;

  const CryptoListingModel({
    required this.symbol,
    required this.name,
    required this.price,
    required this.variantionLast24Hours,
  });

  factory CryptoListingModel.fromData(Map<String, dynamic> data) {
    final title = data["name"];
    final symbol = data["symbol"];
    final price = data["quote"]["USD"]["price"];
    final variantionLast24Hours = data["quote"]["USD"]["percent_change_24"];

    return CryptoListingModel(
      name: title,
      symbol: symbol,
      price: price,
      variantionLast24Hours: variantionLast24Hours,
    );
  }
}
