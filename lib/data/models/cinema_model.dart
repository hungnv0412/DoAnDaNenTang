import '../../domain/entities/cinema.dart';

class CinemaModel extends Cinema {
  CinemaModel({
    required String id,
    required String name,
    required String location,
    required String imageUrl,
  }) : super(
          id: id,
          name: name,
          location: location,
          imageUrl: imageUrl,
        );

  factory CinemaModel.fromJson(Map<String, dynamic> json) {
    return CinemaModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'imageUrl': imageUrl,
    };
  }
}
