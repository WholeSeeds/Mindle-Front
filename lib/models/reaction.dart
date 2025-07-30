class Reaction {
  final int reactionCount;
  final bool reacted;

  Reaction({required this.reactionCount, required this.reacted});

  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      reactionCount: json['reactionCount'],
      reacted: json['reacted'],
    );
  }
}
