class CLocation{
  double lat;
  double long;
  CLocation(this.lat,this.long);

  set setLat(double lat){this.lat=lat;}
  set setLong(double long){this.long=long;}
  double get getLat => lat;
  double get getLong => long;

  Map<String, dynamic> toMap() => {
        "lat": lat,
        "long": long
      };
}