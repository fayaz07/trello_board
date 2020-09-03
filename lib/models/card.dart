class TCardModel {
  String id;
  String task;
  String columnId;
  int views;
  int likes;

  TCardModel({this.id, this.task, this.columnId, this.views, this.likes}) {
    assert(id != null);
    assert(columnId != null);
    if (this.task == null) this.task = "Card ${this.id}";
  }
}
