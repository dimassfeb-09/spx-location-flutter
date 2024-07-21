class SellerLocation {
  final int id;
  final String sellerName;
  final String address;
  final double latitude;
  final double longitude;
  final String gmaps;
  final String createdAt;
  final String updatedAt;

  SellerLocation({
    required this.id,
    required this.sellerName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.gmaps,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create an instance from JSON
  factory SellerLocation.fromJson(Map<String, dynamic> json) {
    return SellerLocation(
      id: json['id'],
      sellerName: json['seller_name'],
      address: json['address'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      gmaps: json['gmaps'],
      createdAt: json['time_operation']['created_at'],
      updatedAt: json['time_operation']['updated_at'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seller_name': sellerName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'gmaps': gmaps,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // Static method to create a list of SellerLocation from a JSON array
  static List<SellerLocation> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SellerLocation.fromJson(json)).toList();
  }
}
