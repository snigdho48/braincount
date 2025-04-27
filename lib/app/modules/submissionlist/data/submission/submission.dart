import 'dart:convert';

import 'package:braincount/app/modules/datacollect/model/monitoring_model/billboard_detail.dart';

class Submission {
  final String? uuid;
  final num? latitude;
  final num? longitude;
  final List<dynamic>? status;
  final String? billboard;
  final String? front;
  final String? left;
  final String? right;
  final String? close;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final BillboardDetail? billboardDetail;

  final List<dynamic>? extraImagesList;
  final String? approvalStatus;
  final String? rejectReason;

  const Submission({
    this.uuid,
    this.latitude,
    this.longitude,
    this.status,
    this.billboard,
    this.front,
    this.left,
    this.right,
    this.close,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.billboardDetail,
    this.extraImagesList,
    this.approvalStatus,
    this.rejectReason,
  });

  @override
  String toString() {
    return 'Submission(uuid: $uuid, latitude: $latitude, longitude: $longitude,billboardDetail:$billboardDetail status: $status, billboard: $billboard, front: $front, left: $left, right: $right, close: $close, comment: $comment, createdAt: $createdAt, updatedAt: $updatedAt, extraImagesList: $extraImagesList, approvalStatus: $approvalStatus, rejectReason: $rejectReason)';
  }

  factory Submission.fromMap(Map<String, dynamic> data) => Submission(
        uuid: data['uuid'] as String?,
        latitude: data['latitude'] as num?,
        longitude: data['longitude'] as num?,
        status: data['status'] as List<dynamic>?,
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
        extraImagesList: data['extra_images_list'] as List<dynamic>?,
        approvalStatus: data['approval_status'] as String?,
        rejectReason: data['reject_reason'] as String?,
        billboardDetail: data['billboard_detail'] == null
            ? null
            : BillboardDetail.fromMap(
                data['billboard_detail'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'uuid': uuid,
        'latitude': latitude,
        'longitude': longitude,
        'status': status,
        'billboard': billboard,
        'front': front,
        'left': left,
        'right': right,
        'close': close,
        'comment': comment,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'extra_images_list': extraImagesList,
        'approval_status': approvalStatus,
        'reject_reason': rejectReason,
        'billboard_detail': billboardDetail?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Submission].
  factory Submission.fromJson(String data) {
    return Submission.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Submission] to a JSON string.
  String toJson() => json.encode(toMap());
}
