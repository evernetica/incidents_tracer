class MainInformationParser
    extends RouteInformationParser<MainState> {
  @override
  Future<MainState> parseRouteInformation(
      RouteInformation routeInformation) async {
    return MainState.union();
  }

  @override
  RouteInformation restoreRouteInformation(MainState path) {
    return RouteInformation(location: "/");
  }
}