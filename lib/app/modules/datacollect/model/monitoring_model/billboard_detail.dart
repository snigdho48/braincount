import 'dart:convert';

class BillboardDetail {
  int? id;
  String? uuid;
  double? latitude;
  double? longitude;
  String? status;
  String? title;
  String? location;
  String? front;
  String? left;
  String? right;
  String? close;
  String? billboardType;
  DateTime? createdAt;
  DateTime? updatedAt;

  BillboardDetail({
    this.id,
    this.uuid,
    this.latitude,
    this.longitude,
    this.status,
    this.title,
    this.location,
    this.front,
    this.left,
    this.right,
    this.close,
    this.billboardType,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'BillboardDetail(id: $id, uuid: $uuid, latitude: $latitude, longitude: $longitude, status: $status, title: $title, location: $location, front: $front, left: $left, right: $right, close: $close, billboardType: $billboardType, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory BillboardDetail.fromMap(Map<String, dynamic> data) {
    return BillboardDetail(
      id: data['id'] as int?,
      uuid: data['uuid'] as String?,
      latitude: (data['latitude'] as num?)?.toDouble(),
      longitude: (data['longitude'] as num?)?.toDouble(),
      status: data['status'] as String?,
      title: data['title'] as String?,
      location: data['location'] as String?,
      front: data['front'] as String?,
      left: data['left'] as String?,
      right: data['right'] as String?,
      close: data['close'] as String?,
      billboardType: data['billboard_type'] as String?,
      createdAt: data['created_at'] == null
          ? null
          : DateTime.parse(data['created_at'] as String),
      updatedAt: data['updated_at'] == null
          ? null
          : DateTime.parse(data['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'uuid': uuid,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'title': title,
        'location': location,
        'front': front,
        'left': left,
        'right': right,
        'close': close,
        'billboard_type': billboardType,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
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
