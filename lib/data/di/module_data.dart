class DataModule {
  DataModule(GetIt _getIt) {
    var fb = FirebaseDatabase.instance;
    var fs = FirebaseStorage.instance;
    var fa = FirebaseAuth.instance;

    _getIt.registerSingletonAsync<RepositoryPreferences>(() async {
      var a = await  SharedPreferences.getInstance();
      return RepositoryPreferencesImpl(a );
    });

    _getIt.registerSingletonWithDependencies<AccountRepository>(
        () => AccountRepositoryImpl(_getIt.get<RepositoryPreferences>()),
        dependsOn: [RepositoryPreferences]);

    _getIt.registerSingletonAsync<AuthRepository>(() async {
      return AuthRepositoryImpl(fa);
    });

    _getIt.registerSingletonAsync<IncidentsRepository>(() async {
      return IncidentsRepositoryImpl(fb, fs);
    });
  }
}
