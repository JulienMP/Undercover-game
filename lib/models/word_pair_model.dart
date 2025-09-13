class WordPair {
  final String civilianWord;
  final String undercoverWord;

  const WordPair({
    required this.civilianWord,
    required this.undercoverWord,
  });
}

class WordPairs {
  static const List<WordPair> wordPairs = [
    WordPair(civilianWord: "Apple", undercoverWord: "Orange"),
    WordPair(civilianWord: "Cat", undercoverWord: "Dog"),
    WordPair(civilianWord: "Coffee", undercoverWord: "Tea"),
    WordPair(civilianWord: "Book", undercoverWord: "Magazine"),
    WordPair(civilianWord: "Car", undercoverWord: "Truck"),
    WordPair(civilianWord: "Pizza", undercoverWord: "Burger"),
    WordPair(civilianWord: "Phone", undercoverWord: "Tablet"),
    WordPair(civilianWord: "Ocean", undercoverWord: "Lake"),
    WordPair(civilianWord: "Mountain", undercoverWord: "Hill"),
    WordPair(civilianWord: "Winter", undercoverWord: "Autumn"),
    WordPair(civilianWord: "Doctor", undercoverWord: "Nurse"),
    WordPair(civilianWord: "Teacher", undercoverWord: "Professor"),
    WordPair(civilianWord: "Basketball", undercoverWord: "Football"),
    WordPair(civilianWord: "Guitar", undercoverWord: "Piano"),
    WordPair(civilianWord: "Airplane", undercoverWord: "Helicopter"),
    WordPair(civilianWord: "Chocolate", undercoverWord: "Vanilla"),
    WordPair(civilianWord: "Lion", undercoverWord: "Tiger"),
    WordPair(civilianWord: "Rose", undercoverWord: "Tulip"),
    WordPair(civilianWord: "Beach", undercoverWord: "Desert"),
    WordPair(civilianWord: "Breakfast", undercoverWord: "Dinner"),
    WordPair(civilianWord: "Bicycle", undercoverWord: "Motorcycle"),
    WordPair(civilianWord: "Painting", undercoverWord: "Drawing"),
    WordPair(civilianWord: "Hotel", undercoverWord: "Motel"),
    WordPair(civilianWord: "Laptop", undercoverWord: "Desktop"),
    WordPair(civilianWord: "Swimming", undercoverWord: "Diving"),
  ];

  static WordPair getRandomWordPair() {
    final shuffledList = List<WordPair>.from(wordPairs);
    shuffledList.shuffle();
    return shuffledList.first;
  }
}