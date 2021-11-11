class DomainModule {
  DomainModule(GetIt _getIt) {
    _getIt.registerSingletonWithDependencies<AuthUseCase>(() {
      return AuthUseCase(
          _getIt.get<AuthRepository>(), _getIt.get<AccountRepository>());
    }, dependsOn: [AuthRepository, AccountRepository]);

    _getIt.registerSingletonWithDependencies<IncidentsUseCase>(() {
      return IncidentsUseCase(_getIt.get<IncidentsRepository>(), _getIt.get<AccountRepository>());
    }, dependsOn: [IncidentsRepository, AccountRepository]);
  }
}