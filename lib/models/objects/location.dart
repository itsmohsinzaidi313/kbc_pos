import 'dart:convert';

class Location {

  static final String locId = 'Id';
  static final String locCode = 'Code';
  static final String locName = 'Name';

  final String locationId;
  final String locationCode, locationName;

  const Location({this.locationId, this.locationCode, this.locationName});

  factory Location.fromJson(Map<String, dynamic> map) =>
    Location(
      locationId: map[locId],
      locationName: map[locName],
      locationCode: map[locCode]
    );

  @override
  String toString() {
    return 'Location{locationId: $locationId, locationCode: $locationCode, locationName: $locationName}';
  }
}

List<Location> locationListFromJson(String str) => List<Location>.from(json.decode(str)['Data'].map((x) => Location.fromJson(x)));
