class Location {
  int locationId;
  String locationCode, locationName;

  Location({this.locationId, this.locationCode, this.locationName});

  @override
  String toString() {
    return 'Location{locationId: $locationId, locationCode: $locationCode, locationName: $locationName}';
  }
}
