
class IncidentsPage extends PlatformPage {
  IncidentsPage() : super(IncidentsListWidget(), "/incidents_list");
}

class IncidentsListWidget extends StatelessWidget {
  late IncidentsCubit _incidentsCubit;

  @override
  Widget build(BuildContext context) {
    _incidentsCubit = IncidentsCubit(getIt.get<IncidentsUseCase>());

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Theme.of(context).colorScheme.mainBackground,
        child: BlocBuilder<IncidentsCubit, IncidentsState>(
            bloc: _incidentsCubit,
            builder: (context, state) {
              return state.when(
                  list: (List<IncidentEntity> list) => listState(context, list),
                  error: (String error) => errorState(context, error),
                  loading: () => loadingState(context));
            }),
      ),
    );
  }

  Widget errorState(BuildContext context, String error) {
    return Container(
      child: Text(error),
    );
  }

  Widget listState(BuildContext context, List<IncidentEntity> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];

        return ListTile(
          leading: Container(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.leadIconListIcon, shape: BoxShape.circle),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                // child: Icon(Icons.local_fire_department_rounded, color: Colors.white),
                child: Icon(Icons.location_pin, color: Colors.white),
              )),
          title: Text(
            "Incidents at <${Format.location(item.latLng.latitude)},${Format.location(item.latLng.longitude)}>",
            style: TextStyle(color: Theme.of(context).colorScheme.titleListText),),
          // subtitle: Text('on ${inactiveTimeFormatter.format(item.createdAt)}, ${item.size} acres'),
          subtitle: Text('on ${inactiveTimeFormatter.format(item.createdAt)}'),
        );
      },
    );
  }

  Widget loadingState(BuildContext context) {
    return Container(
      child: Text("loading"),
    );
  }
}
