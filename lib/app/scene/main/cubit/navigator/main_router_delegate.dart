import 'package:firecom/app/scene/main/create/screen_create.dart';
import 'package:firecom/app/scene/main/cubit/mai

class MainRouterDelegate extends RouterDelegate<MainState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MainState> {
  final GlobalKey<NavigatorState> navigatorKey;

  MainState _currentState = MainState.union();

  MainRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  MainState get currentConfiguration => _currentState;

  List<Page<dynamic>> _getPages() {
    List<Page<dynamic>> pages = [UnionPage()]; //default

    _currentState.when( union: () {  }, create: () {
      pages.add(CreatePage());
    });

    return pages;
  }

  late MainCubit _cubit;

  @override
  Widget build(BuildContext context) {
    _cubit = BlocProvider.of<MainCubit>(context);
    return BlocListener(
      bloc: _cubit,
      listener: (BuildContext context, MainState state) {
        _currentState = state;
        notifyListeners();
      },
      child: Navigator(
        pages: _getPages(),
        onPopPage:(route, result) => _onPopPage.call(route, result, _cubit),
      ),
    );
  }

  @override
  Future<bool> popRoute(){
    //android
    if (_cubit.state == MainState.union()) {
      return Future.value(false);
    }
    _cubit.state.when(union: () {  }, create: () {
      _cubit.navigateToUnion();
    });

    return Future.value(true);
  }

  bool _onPopPage(Route route, dynamic result, MainCubit cubit) {
    //ios
    if (!route.didPop(result) || cubit.state == MainState.union()) {
      return false;
    }
    cubit.state
        .when(union: () {  }, create: () {
      _cubit.navigateToUnion();
    });
    popRoute();
    return true;
  }

  @override
  Future<void> setNewRoutePath(MainState configuration) async {
    _currentState = configuration;
    notifyListeners();
  }
}
