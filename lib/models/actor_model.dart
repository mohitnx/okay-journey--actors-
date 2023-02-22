class Actor {
  String name;
  String image;

  Actor({required this.name, required this.image});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }

  Actor.fromMap(Map<String, dynamic> item)
      : name = item['name'] ?? '',
        image = item['image'];
}
