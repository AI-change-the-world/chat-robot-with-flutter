import 'package:string_similarity/string_similarity.dart';

main(List<String> args) {
  final comparison = 'healed'.similarityTo(
      'sealed'); // or StringSimilarity.compareTwoStrings('healed', 'sealed')
  print(comparison); // → 0.8
}
