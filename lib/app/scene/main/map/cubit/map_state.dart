@freezed
abstract class MapState with _$MapState {
  const factory MapState.list(List<IncidentEntity> incidents) = MapList;
  const factory MapState.point() = MapPoint;
}