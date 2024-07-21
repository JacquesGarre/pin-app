class Pin {
  const Pin(this.id, this.title, this.latitude, this.longitude);

  final int id;
  final String title;
  final double? latitude;
  final double? longitude;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory Pin.fromJson(Map<String, dynamic> json) {
    return Pin(
      json['id'],
      json['title'],
      json['latitude'],
      json['longitude'],
    );
  }
}
