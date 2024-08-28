// Usage: mixin EntityConvertible<I, O> { ... }
mixin EntityConvertible<I, O> {
  O toEntity();
  I fromEntity(O model) => throw UnimplementedError();
}