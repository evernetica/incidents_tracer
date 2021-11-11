
class MainPage extends PlatformPage {
  MainPage() : super(MainWidget(), "/main");
}

class MainWidget extends StatelessWidget {
  final MainInformationParser informationParser = MainInformationParser();
  final RouterDelegate<MainState> mainRouterDelegate = MainRouterDelegate();

  @override
  Widget build(BuildContext context) {
    var mainCubit = MainCubit(getIt.get<AuthUseCase>(), BlocProvider.of<AppCubit>(context) );

    return BlocProvider.value(
      value: mainCubit,
      child: BlocBuilder(
        bloc: mainCubit,
        builder: (BuildContext context, _) {
          if (Platform.isIOS) {
            return CupertinoApp.router(
              theme: CupertinoThemeData(brightness: Brightness.light),
              localizationsDelegates: [
                DefaultMaterialLocalizations.delegate,
              ],
              routeInformationParser: informationParser,
              routerDelegate: mainRouterDelegate,
              backButtonDispatcher: RootBackButtonDispatcher(),
              debugShowCheckedModeBanner: false,
            );
          }
          return MaterialApp.router(
            routeInformationParser: informationParser,
            routerDelegate: mainRouterDelegate,
            debugShowCheckedModeBanner: false,
            backButtonDispatcher: RootBackButtonDispatcher(),
          );
        },
      ),
    );
  }
}