class MapCubit extends Cubit<MapState> {

  final IncidentsUseCase _incidentsUseCase;

  MapCubit(this._incidentsUseCase) : super(MapState.list(List.empty())){
    _streamController = _incidentsUseCase.incidents;
    checkUpdate();
  }

  StreamController<List<IncidentEntity>>? _streamController = null;

  void load() async {
    _incidentsUseCase.getIncidents().then((value) {
      _streamController?.add(value);
    }, onError: (error) {

    });
  }

  void checkUpdate() async {
    _incidentsUseCase.checkUpdate().then((value) {
      load();
    });
  }

  Stream<List<IncidentEntity>>? incidents() {
    return _streamController?.stream;
  }

  void updateLocation(LatLng latLng) {
    _incidentsUseCase.updateLocation(latLng);
  }

}
