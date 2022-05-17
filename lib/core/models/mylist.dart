class MyList {
  int id;
  String title;
  

MyList({
  this.id,
  this.title,
 });

  String toString() {
    return '{id: $id, title: $title}';
  }
}