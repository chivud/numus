class Currency {
  final String displayName;
  final String symbol;

  Currency(this.displayName, this.symbol);

  Currency.fromJson(Map<String, dynamic> json)
      : displayName = json['displayName'],
        symbol = json['symbol'];
}
