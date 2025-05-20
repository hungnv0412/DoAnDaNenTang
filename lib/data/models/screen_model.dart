class ScreenModel {
  final String id;
  final String cinemaId;
  final String name;


  ScreenModel({
    required this.id,
    required this.cinemaId,
    required this.name,
  });
  factory ScreenModel.fromJson(Map<String, dynamic> json) {
    return ScreenModel(
      id: json['id'] as String,
      cinemaId: json['cinemaId'] as String,
      name: json['name'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cinemaId': cinemaId,
      'name': name,
    };
  }
}