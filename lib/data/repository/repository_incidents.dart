class IncidentsRepositoryImpl extends IncidentsRepository {
  final FirebaseDatabase _firebaseDatabase;
  final FirebaseStorage _firebaseStorage;

  IncidentsRepositoryImpl(this._firebaseDatabase, this._firebaseStorage);

  @override
  Stream<List<IncidentModel>> incidentsStream() {
    return _firebaseDatabase
        .reference()
        .child(FirebaseDb.reference_incidents)
        .onValue
        .map((event) => incidentModelListFromDataSnapshot(event.snapshot))
        .asBroadcastStream();
  }

  @override
  Future<void> createIncident(IncidentModel incidentModel, File? file) async {
    String imageUlr = "";
    if (file != null) {
      var fileRef = await _firebaseStorage
          .ref()
          .child(
              '${FirebaseDb.reference_storage_uploads}/${file.lastModifiedSync()}')
          .putFile(file);
      imageUlr = await fileRef.ref.getDownloadURL();
    }

    var newReference = _firebaseDatabase.reference().child(FirebaseDb.reference_incidents).push();

    fireModel.id = newReference.key;
    fireModel.fileUrl = imageUlr;

    return _firebaseDatabase
        .reference()
        .child(FirebaseDb.reference_incidents)
        .child(newReference.key)
        .set(incidentModel.toJson());
  }
}
