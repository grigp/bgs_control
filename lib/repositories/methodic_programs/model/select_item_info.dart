class SelectItemInfo {
  SelectItemInfo({
    required this.nodeType,
    required this.id,
    required this.parent,
    required this.title,
    required this.description,
    required this.methodicId,
  });

  /// Конструктор из json
  factory SelectItemInfo.fromJson(dynamic data) {
    ///Разбор итема в json
    var retval = SelectItemInfo(
      nodeType: data['node_type'],
      id: data['id'],
      parent: data['parent'],
      title: data['title'],
      description: data['description'],
      methodicId:  data['methodic_id'],
    );
    return retval;
  }

  SelectItemNodeType nodeType;
  int id;
  int parent;
  String title;
  String description;
  int methodicId;
}

// Тип узла 0 - узел, 1 - лист, 2 - заголовок
enum SelectItemNodeType {simtNode, simtRun, simtTitle}
// {
//   "tree": [
//     {
//       "node_type": 0, 1, 2,   // Тип узла 0 - узел, 1 - лист, 2 - заголовок
//       "id": ####,             // Уникальный идентификатор - целое число
//       "parent": ####,         // Уникальный идентификатор родителя. -1 - принадлежит корневому списку
//       "title": "Название узла, которое видит пользователь",
//       "description": "Описание узла, ко возможно увидит пользователь",
//       "methodic_id": ####,    // Идентификатор вызываемой методики. Для листового узла
//     },
//   ...
// }
