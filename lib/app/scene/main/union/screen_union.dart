class UnionPage extends PlatformPage {
  UnionPage() : super(UnionWidget(), "/union");
}

class UnionWidget extends StatefulWidget {
  @override
  State<UnionWidget> createState() => _UnionWidgetState();
}

class _UnionWidgetState extends State<UnionWidget>
    with SingleTickerProviderStateMixin {
  late UnionCubit _unionCubit;

  List<Widget> screens = [MapWidget(), IncidentsListWidget()];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: screens.length);

    _tabController?.addListener(tabListener);
  }

  void tabListener() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();

    _tabController?.removeListener(tabListener);
  }

  @override
  Widget build(BuildContext context) {
    _unionCubit = UnionCubit(
        getIt.get<IncidentsUseCase>(), BlocProvider.of<MainCubit>(context));

    return PlatformScaffold(
      child: Container(
        color: Theme.of(context).colorScheme.appbarBackground,
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [topArea(context), midArea(context), bottomArea(context)],
          ),
          BlocBuilder<UnionCubit, UnionState>(
              bloc: _unionCubit,
              builder: (context, state) {
                return state.when(none: () {
                  return Container();
                }, loading: () {
                  return _loadingState(context);
                });
              }),
        ]),
      ),
    );
  }

  Widget _loadingState(BuildContext context) {
    return _infoContainer(const Padding(
      padding: EdgeInsets.all(64.0),
      child: CircularProgressIndicator(
        strokeWidth: 8.0,
      ),
    ));
  }

  Widget _infoContainer(Widget child) {
    return Align(
      alignment: Alignment.center,
      child: Center(
        child: Container(
            width: double.infinity,
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        child: child),
                  ),
                )))),
      ),
    );
  }

  Widget topArea(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.appbarBackground,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0, 24.0),
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                child: Text(
                  _tabController?.index == 0
                      ? "IncidentTracer"
                      : "List of IncidentsIncidents",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.appbarText,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: _unionCubit.logout,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                    child: Icon(Icons.logout),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Widget midArea(BuildContext context) {
    return Expanded(
      child: Stack(children: [
        Center(
          child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.mainBackground,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(24.0),
                  topLeft: Radius.circular(24.0),
                ),
              ),
              child: TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: screens)),
        ),
        Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(right: 16.0, bottom: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(18),
                  shape: CircleBorder(),
                  primary: Colors.red, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () async {
                  await startCreateRoad();
                },
                // child: Icon(Icons.local_incident_department_rounded),
                child: Icon(Icons.add_location),
              ),
            )),
      ]),
    );
  }

  Widget bottomArea(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.unionBotContainer,
      child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 24.0, 0, 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0, 8.0, 0),
                  child: button("Map", _tabController?.index == 0, () {
                    _tabController?.animateTo(0);
                  }),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 0, 16.0, 0),
                  child: button("List", _tabController?.index == 1, () {
                    _tabController?.animateTo(1);
                  }),
                ),
              )
            ],
          )),
    );
  }

  Widget button(String text, bool isActive, VoidCallback? onPressed) {
    var backgroundColor = isActive
        ? Theme.of(context).colorScheme.activeBotBtn
        : Theme.of(context).colorScheme.nonActiveBotBtn;
    var borderColor = isActive
        ? Theme.of(context).colorScheme.activeBotBorderBtn
        : Theme.of(context).colorScheme.nonActiveBotBorderBtn;

    return TextButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
          child: Text(
            text,
            style: TextStyle(color: Theme.of(context).colorScheme.botBtnText),
          ),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    side: BorderSide(color: borderColor)))));
  }

  Widget mapState(BuildContext context) {
    return screens.first;
  }

  Widget listState(BuildContext context) {
    return screens.last;
  }

  Future startCreateRoad() async {
    Permission checkPermission = Permission.camera;
    await [
      checkPermission,
    ].request().then((Map<Permission, PermissionStatus> permissions) async {
      var permissionStatus = permissions[checkPermission];
      if (permissionStatus == PermissionStatus.granted) {
        final AssetEntity? entity = await CameraPicker.pickFromCamera(context,
            textDelegate: EnglishCameraPickerTextDelegate());
        var file = await entity?.file;

        ///save image and navigate to create
        _unionCubit.add(file);
      } else if (!await checkPermission.isPermanentlyDenied) {
        Log.ERROR("isPermanentlyDenied", "$this");
      } else {
        Log.ERROR("else", "$this");
      }
    });
  }
}
