class TColumnModel {
  String id;
  String title;

  TColumnModel({this.id, this.title}) {
    if (this.title == null) this.title = "Column";
  }

  factory TColumnModel.fromJSON(Map<String, dynamic> data) {
    return TColumnModel(
      id: data["id"],
      title: data["title"],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      // "id": this.id,
      "title": this.title};
  }
}
