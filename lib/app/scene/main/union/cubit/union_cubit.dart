
class UnionCubit extends Cubit<UnionState> {
  final IncidentsUseCase _incidentsUseCase;
  final MainCubit _mainCubit;

  UnionCubit(this._incidentsUseCase, this._mainCubit) : super(UnionState.none()) {
    _incidentsUseCase.checkUpdate();
  }

  void add(File? file) {
    _incidentsUseCase.saveTempIncidentImage(file);
    _mainCubit.navigateToCreate();
  }

  void logout() {
    emit(UnionState.loading());
    _mainCubit.logout();
  }
}
