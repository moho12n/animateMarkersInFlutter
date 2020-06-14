class MarkersModel {
  int id;
  String name;
  String description;
  String latitude;
  String longitude;
  String image;
  MarkersModel(
      this.id,
      this.name,
      this.description,
      this.latitude,
      this.longitude,
      this.image);

// you can use this model with your backend as well :  

/*  factory MarkersModel.fromJson(Map<String, dynamic> json) => MarkersModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      image: json["image"]);
*/
}
