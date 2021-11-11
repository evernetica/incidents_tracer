@freezed
abstract class UnionState  with _$UnionState{
  const factory UnionState.loading() = UnionLoading;
  const factory UnionState.none() = UnionNone;
}