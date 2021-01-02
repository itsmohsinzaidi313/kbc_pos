class Location {
  final int locationId;
  final String locationCode, locationName;

  const Location({this.locationId, this.locationCode, this.locationName});

  @override
  String toString() {
    return 'Location{locationId: $locationId, locationCode: $locationCode, locationName: $locationName}';
  }
}
