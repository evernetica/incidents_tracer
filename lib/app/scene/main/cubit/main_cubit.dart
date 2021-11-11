class MainCubit extends Cubit<MainState> {
  AuthUseCase _authUseCase;
  AppCubit _appCubit;
  MainCubit(this._authUseCase, this._appCubit) : super(MainState.union());

  logout() async {
    _authUseCase.logout().then((value) async {
      await _appCubit.isLogin();
    },onError: (error)  async{
      await _authUseCase.getStatus().then((value) {
        if (value == AuthStatus.authenticated) _appCubit.emit(AppState.loggedIn());
        else _appCubit.emit(AppState.loggedOut());
      });
    });
  }

  void navigateToUnion() {
    emit(MainState.union());
  }

  void navigateToCreate() {
    emit(MainState.create());
  }
}
