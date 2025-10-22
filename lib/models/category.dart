class Category {
  final int id;
  final String name;
  final String description;
  final List<Category> children;

  Category({
    required this.id,
    required this.name,
    required this.description,
    required this.children,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final mainId = json['id'] as int;
    
    return Category(
      id: mainId,
      name: json['name'] as String,
      description: json['description'] as String,
      children: (json['children'] as List<dynamic>?)
              ?.asMap()
              .entries
              .map((entry) {
                final index = entry.key;
                final child = entry.value;
                
                // children이 문자열 배열인 경우
                if (child is String) {
                  return Category(
                    id: mainId * 1000 + index + 1, // 메인 카테고리 ID 기반 서브카테고리 ID
                    name: child,
                    description: child,
                    children: [],
                  );
                }
                // children이 객체 배열인 경우
                else if (child is Map<String, dynamic>) {
                  return Category.fromJson(child);
                }
                // 예외 처리
                else {
                  return Category(
                    id: mainId * 1000 + index + 1,
                    name: child.toString(),
                    description: child.toString(),
                    children: [],
                  );
                }
              })
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'children': children.map((child) => child.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description, children: ${children.length})';
  }
}