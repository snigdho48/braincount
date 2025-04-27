import 'dart:convert';

class BillboardDetail {
  final int? id;
  final String? uuid;
  final double? latitude;
  final double? longitude;
  final String? title;
  final String? location;

  final String? billboardType;
  final dynamic faces;

  const BillboardDetail({
    this.id,
    this.uuid,
    this.latitude,
    this.longitude,
    this.title,
    this.location,
    this.billboardType,
    this.faces,
  });

  @override
  String toString() {
    return 'BillboardDetail(id: $id, uuid: $uuid, latitude: $latitude, longitude: $longitude, title: $title, location: $location, billboardType: $billboardType, faces: $faces)';
  }

  factory BillboardDetail.fromMap(Map<String, dynamic> data) {
    return BillboardDetail(
      id: data['id'] as int?,
      uuid: data['uuid'] as String?,
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      title: data['title'] as String?,
      location: data['location'] as String?,
      billboardType: data['billboard_type'] as String?,
      faces: data['faces'] as dynamic,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'uuid': uuid,
        'latitude': latitude,
        'longitude': longitude,
        'title': title,
        'location': location,
        'billboard_type': billboardType,
        'faces': faces,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [BillboardDetail].
  factory BillboardDetail.fromJson(String data) {
    return BillboardDetail.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [BillboardDetail] to a JSON string.
  String toJson() => json.encode(toMap());
}
