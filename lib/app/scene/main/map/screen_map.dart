class MapPage extends PlatformPage {
  MapPage() : super(MapWidget(), "/map");
}

UniqueKey _key = UniqueKey();

class MapWidget extends StatefulWidget {

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with AutomaticKeepAliveClientMixin{
  late MapCubit _mapCubit;

  MapboxMapController? controller;
  StreamSubscription? _streamSubscription = null;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    _mapCubit = MapCubit(getIt.get<IncidentsUseCase>());
    return BlocBuilder<MapCubit, MapState>(
        bloc: _mapCubit,
        builder: (context, state) {
          var w = mapState();
          state.when(list: (list) {}, point: () {});
          return w;
        });
  }

  Widget mapState() {
    return MapboxMap(
      key: _key,
      initialCameraPosition:
          CameraPosition(target: LatLng(0.0, 0.0), zoom: 5.0),
      accessToken:
          "pk.eyJ1IjoiaWx5YS13IiwiYSI6ImNrdXBsZTRpaTE5NnUzMXAxMGx2eHRmbHAifQ.PydGB1ZXsEjhqlV9ma-xfw",
      myLocationEnabled: true,
      onMapCreated: _onMapCreated,
      onUserLocationUpdated: _onUserLocationUpdated,
      minMaxZoomPreference: MinMaxZoomPreference(1.0, 13.0),
    );
  }

  void _onMapCreated(MapboxMapController controller) {
    this.controller = controller;

    this.controller?.onSymbolTapped.add(_onSymbolTapped);

    _streamSubscription ??= _mapCubit.incidents()?.listen((l) {
        addPins(l, this.controller);
      });
  }

  void addPins(List<IncidentEntity> list, MapboxMapController? controller) {
    controller?.onSymbolTapped.add(_onSymbolTapped);
    controller?.symbols.clear();
    controller?.addSymbols(list
        .map((e) => SymbolOptions(
              geometry: e.latLng,
              iconImage: 'assets/images/marker.png',
            ))
        .toList());
  }

  bool _isFirstCenteredCameraPosition = false;

  void _onUserLocationUpdated(UserLocation location) async {
    if (!_isFirstCenteredCameraPosition) {
      await controller
          ?.animateCamera(CameraUpdate.newLatLngZoom(location.position, 10.0));
      _isFirstCenteredCameraPosition = true;
    }
    _mapCubit.updateLocation(location.position);
  }

  void _onSymbolTapped(Symbol symbol) {
    Log.DEBUG("_onSymbolTapped: $symbol", "$this");
  }
}
