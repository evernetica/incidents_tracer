import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'incidents_state.freezed.dart';

@freezed
abstract class IncidentsState with _$IncidentsState {
  const factory IncidentsState.list(List<IncidentEntity> list) = IncidentsList;

  const factory IncidentsState.error(String error) = IncidentsError;
  const factory IncidentsState.loading() = IncidentsLoading;
}