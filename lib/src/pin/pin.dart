class Pin {
  const Pin(this.id, this.title);

  final int id;
  final String title;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
  };

  factory Pin.fromJson(Map<String, dynamic> json) {
    return Pin(
      json['id'],
      json['title'],
    );
  }
}
