class TColumnModel {
  String id;
  String title;

  TColumnModel({this.id, this.title}) {
    assert(id != null);
    if (this.title == null) this.title = "Column ${this.id}";
  }
}
