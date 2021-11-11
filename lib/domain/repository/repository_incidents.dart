abstract class IncidentsRepository {
  Stream<List<IncidentModel>> incidentsStream();

  Future<void> createIncident(IncidentModel incidentModel, File? file);
}