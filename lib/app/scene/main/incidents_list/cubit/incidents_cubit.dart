class IncidentsCubit extends Cubit<IncidentsState> {
  final IncidentsUseCase _IncidentsUseCase;
  StreamSubscription? _streamSubscription = null;

  IncidentsCubit(this._IncidentsUseCase) : super(IncidentsState.loading()) {
    init();
  }

  void init() async {
    _IncidentsUseCase.getIncidents().then((value) {
      emit(IncidentsState.list(value));
    },onError: (error) {
      emit(IncidentsState.error("$error"));
    });
    _streamSubscription ??= _IncidentsUseCase.Incidents.stream.listen((event) {
      emit(IncidentsState.list(event));
    });

  }
}
