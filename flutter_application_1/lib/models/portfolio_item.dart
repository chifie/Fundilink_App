/// A piece of work a fundi showcases in their portfolio.
class PortfolioItem {
  final String id;
  final String fundiId;
  final String title;
  final String description;
  final String imageUrl;

  const PortfolioItem({
    required this.id,
    required this.fundiId,
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}
