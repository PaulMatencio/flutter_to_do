
class ToDoDashboard {
  final int areDone;
  final int areNotDone;
  final List<Collection> collections;

  const ToDoDashboard({required this.areDone, required this.areNotDone, required this.collections});

  factory ToDoDashboard.empty() {
    return ToDoDashboard(
      collections: [],
      areDone: 0,
      areNotDone: 0,
    );
  }
}

class Collection   {
  final int isDone;
  final int isNotDone;
  final String title;
  final int colorIndex;

  const Collection({required this.title, required this.colorIndex,required this.isDone, required this.isNotDone});

  Collection copyWith({int? isDone, int? isNotDone, String? title, int ?colorIndex}) {
    return Collection(
        isDone: isDone ?? this.isDone, isNotDone: isNotDone ?? this.isNotDone, title: title ?? this.title,
    colorIndex:colorIndex?? this.colorIndex );
  }

}

