import 'package:flutter/material.dart';
class CategoryIcon extends StatelessWidget {
  final String iconName;
  final Color color;
  final double size;

  const CategoryIcon({
    Key? key,
    required this.iconName,
    required this.color,
    this.size = 24.0,
  }) : super(key: key);

  static const Map<String, IconData> _iconMap = {
    'utensils': Icons.restaurant_outlined,
    'car': Icons.directions_car_outlined,
    'shopping-bag': Icons.shopping_bag_outlined,
    'receipt': Icons.receipt_outlined,
    'music': Icons.music_note_outlined,
    'heart-pulse': Icons.favorite_outline,
    'trending-up': Icons.trending_up,
    'graduation-cap': Icons.school_outlined,
    'gift': Icons.card_giftcard_outlined,
    'sparkles': Icons.auto_awesome_outlined,
    'home': Icons.home_outlined,
    'more-horizontal': Icons.more_horiz,
    'plus': Icons.add,
    'pencil': Icons.edit_outlined,
    'trash-2': Icons.delete_outline,
    'coffee': Icons.coffee_outlined,
    'bus': Icons.directions_bus_outlined,
    'train': Icons.train_outlined,
    'plane': Icons.flight_outlined,
    'shirt': Icons.checkroom_outlined,
    'smartphone': Icons.smartphone_outlined,
    'wifi': Icons.wifi,
    'zap': Icons.bolt,
    'book-open': Icons.menu_book_outlined,
    'dumbbell': Icons.fitness_center,
    'pill': Icons.medication_outlined,
    'palette': Icons.palette_outlined,
    'camera': Icons.camera_alt_outlined,
    'gamepad-2': Icons.sports_esports_outlined,
    'baby': Icons.child_care,
    'dog': Icons.pets,
    'umbrella': Icons.umbrella_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final IconData iconData = _iconMap[iconName] ?? Icons.circle_outlined;
    return Container(
      width: size * 2,
      height: size * 2,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          iconData,
          color: color,
          size: size,
        ),
      ),
    );
  }
}
