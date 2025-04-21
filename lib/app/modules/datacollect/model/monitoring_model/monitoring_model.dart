import 'dart:convert';

import 'billboard_detail.dart';
import 'user.dart';

class MonitoringModel {
  String? uuid;
  num? latitude;
  num? longitude;
  String? billboard;
  String? front;
  String? left;
  String? right;
  String? close;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  BillboardDetail? billboardDetail;

  MonitoringModel({
    this.uuid,
    this.latitude,
    this.longitude,
    this.billboard,
    this.front,
    this.left,
    this.right,
    this.close,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.billboardDetail,
  });

  @override
  String toString() {
    return 'MonitoringModel(uuid: $uuid, latitude: $latitude, longitude: $longitude billboard: $billboard, front: $front, left: $left, right: $right, close: $close, comment: $comment, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, billboardDetail: $billboardDetail)';
  }

  factory MonitoringModel.fromMap(Map<String, dynamic> data) {
    return MonitoringModel(
      uuid: data['uuid'] as String?,
      latitude: data['latitude'] as num?,
      longitude: data['longitude'] as num?,
      billboard: data['billboard'] as String?,
      front: data['front'] as String?,
      left: data['left'] as String?,
      right: data['right'] as String?,
      close: data['close'] as String?,
      comment: data['comment'] as String?,
      createdAt: data['created_at'] == null
          ? null
          : DateTime.parse(data['created_at'] as String),
      updatedAt: data['updated_at'] == null
          ? null
          : DateTime.parse(data['updated_at'] as String),
      user: data['user'] == null
          ? null
          : User.fromMap(data['user'] as Map<String, dynamic>),
      billboardDetail: data['billboard_detail'] == null
          ? null
          : BillboardDetail.fromMap(
              data['billboard_detail'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'uuid': uuid,
        'latitude': latitude,
        'longitude': longitude,
        'billboard': billboard,
        'front': front,
        'left': left,
        'right': right,
        'close': close,
        'comment': comment,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'user': user?.toMap(),
        'billboard_detail': billboardDetail?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MonitoringModel].
  factory MonitoringModel.fromJson(String data) {
    return MonitoringModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MonitoringModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
