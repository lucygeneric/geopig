abstract class BaseModel {
  String id;
  factory BaseModel.fromMap(Map<String, dynamic> map) {
    throw "Not implemented";
  }
  Map<String, dynamic> toMap();
}
