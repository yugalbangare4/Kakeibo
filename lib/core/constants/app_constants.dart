class AppConstants {
  static const Map<String, String> currencySymbols = {
    'INR': '₹',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
  };

  static const String defaultCurrency = 'INR';

  static const List<Map<String, dynamic>> defaultCategories = [
    {
      'name': 'Food & Dining',
      'iconName': 'utensils',
      'colorIndex': 0,
    },
    {
      'name': 'Transport',
      'iconName': 'bus',
      'colorIndex': 1,
    },
    {
      'name': 'Shopping',
      'iconName': 'shopping-bag',
      'colorIndex': 2,
    },
    {
      'name': 'Bills & Utilities',
      'iconName': 'receipt',
      'colorIndex': 3,
    },
    {
      'name': 'Entertainment',
      'iconName': 'gamepad-2',
      'colorIndex': 4,
    },
    {
      'name': 'Health & Fitness',
      'iconName': 'heart-pulse',
      'colorIndex': 5,
    },
    {
      'name': 'Investments',
      'iconName': 'trending-up',
      'colorIndex': 6,
    },
    {
      'name': 'Education',
      'iconName': 'graduation-cap',
      'colorIndex': 7,
    },
    {
      'name': 'Gifts & Donations',
      'iconName': 'gift',
      'colorIndex': 8,
    },
    {
      'name': 'Personal Care',
      'iconName': 'sparkles',
      'colorIndex': 9,
    },
    {
      'name': 'Home',
      'iconName': 'home',
      'colorIndex': 10,
    },
    {
      'name': 'Others',
      'iconName': 'more-horizontal',
      'colorIndex': 11,
    },
  ];
}
