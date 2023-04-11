class CustomMarker {
  String? id;
  double lat;
  double lng;
  int? upVotes;
  String name;
  String description;
  String uid;
  List<String>? imagePaths;

  CustomMarker(
      {this.id = '',
      this.lat = 90,
      this.lng = 90,
      this.upVotes = 0,
      this.name = '',
      this.description = '',
      this.uid = '',
      this.imagePaths});

  CustomMarker copyWith(
      {String? id,
      int? upVotes,
      double? lat,
      double? lng,
      String? name,
      String? description,
      String? uid,
      List<String>? imagePaths}) {
    return CustomMarker(
      id: id ?? this.id,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      upVotes: upVotes ?? this.upVotes,
      name: name ?? this.name,
      description: description ?? this.description,
      uid: uid ?? this.uid,
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }
}
