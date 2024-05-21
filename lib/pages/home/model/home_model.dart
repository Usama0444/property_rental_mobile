class HomeModel {
  final String image;
  final String title;
  final double price;
  final int noBedroom;
  final int available;

  HomeModel({
    required this.image,
    required this.title,
    required this.price,
    required this.noBedroom,
    required this.available,
  });
}

class AgentProfileModel {
  final String image;
  final String name;
  final String description;

  AgentProfileModel({
    required this.image,
    required this.name,
    required this.description,
  });
}
