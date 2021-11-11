import 'package:equatable/equatable.dart';

@immutable
class IncidentModel extends Equatable {
  String id;
  String createdBy;
  final String describe;
  final String category;
  final String size;
  final DateTime createdAt;
  final LatLngModel latLng;
  String fileUrl;

  FireModel(
      {required this.id,
      required this.createdAt,
      required this.createdBy,
      required this.latLng,
      required this.describe,
      required this.category,
      required this.size,
      required this.fileUrl
      });

  @override
  List<Object?> get props => [];

  factory IncidentModel.fromMapDataSnapshot(Map map) {
    return IncidentModel(
        id: map[FirebaseDb.incident_key_id],
        latLng:
            LatLngModel.fromMapDataSnapshot(map[FirebaseDb.incident_key_lat_lng]),
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            map[FirebaseDb.incident_key_createdAt]),
        createdBy: map[FirebaseDb.incident_key_createdBy],
        size:  map[FirebaseDb.incident_key_size],
        category: map[FirebaseDb.incident_key_category],
        describe: map[FirebaseDb.incident_key_describe],
        fileUrl: map[FirebaseDb.incident_key_fileUrl]??"");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data[FirebaseDb.incident_key_id] = id;
    data[FirebaseDb.incident_key_lat_lng] = latLng.toJson();
    data[FirebaseDb.incident_key_createdAt] = ServerValue.timestamp;
    data[FirebaseDb.incident_key_createdBy] = createdBy;

    data[FirebaseDb.incident_key_size] = "$size";
    data[FirebaseDb.incident_key_category] = category;
    data[FirebaseDb.incident_key_describe] = describe;
    data[FirebaseDb.incident_key_fileUrl] = fileUrl;
    return data;
  }
}

List<IncidentModel> incidentModelListFromDataSnapshot(DataSnapshot dataSnapshot) {
  var value = dataSnapshot.value;
  if (value == null) return List.empty();
  final Iterable iterable = value.values;
  return List<IncidentModel>.from(
      iterable.map((map) => IncidentModel.fromMapDataSnapshot(map)));
}
