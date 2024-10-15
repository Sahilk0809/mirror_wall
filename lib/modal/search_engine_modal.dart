class SearchEngineModal {
  late String name, url, logo;

  SearchEngineModal({
    required this.name,
    required this.url,
    required this.logo,
  });

  factory SearchEngineModal.fromMap(Map m1) {
    return SearchEngineModal(
      name: m1['name'],
      url: m1['url'],
      logo: m1['logo'],
    );
  }
}
