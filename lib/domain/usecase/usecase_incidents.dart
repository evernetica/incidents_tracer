class IncidentsUseCase {
  final IncidentsRepository _incidentsRepository;
  final AccountRepository _accountRepository;

  IncidentsUseCase(this._incidentsRepository, this._accountRepository);

  List<IncidentEntity> _list = List.empty(growable: true);

  File? tempFile = null;
  LatLng? location = null;

  Future<void> createIncident(
      String describe, String category,   String size) async {


    if(location== null ) throw Exception();

    //temporary with '/4'
    LatLng l = LatLng(location!.latitude + Random().nextDouble()/4,  location!.longitude + Random().nextDouble()/4);

    return  _incidentsRepository.createFire(IncidentModel(
        id: "",
        createdAt: DateTime.now(),
        createdBy: (await _accountRepository.getUser()).data!.uuid,
        fileUrl: "",
        latLng: LatLngModel(
            lat: l.latitude, lng: l.longitude),
        size: size,
        category: category,
        describe: describe), tempFile);
  }

  Future<List<FireEntity>> getIncidents() async {
    return _list;
  }

  StreamController<List<IncidentEntity>> incidents = StreamController.broadcast(sync: true);
  StreamSubscription? _subscription = null;

  Future<void> checkUpdate() async {
    _subscription ??= _incidentsRepository.incidentsStream().listen((event) {
      _list = event.map((f) => FireEntity.fromModel(f)).toList();
      incidents.add(_list);
    });
  }

  Future<void> updateLocation(LatLng latLng) async {
    location = latLng;
  }

  void saveTempImage(File? file) {
    tempFile = file;
  }
}
