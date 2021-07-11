part of 'blog_bloc.dart';

@immutable
abstract class BlogState {}

class BlogInitial extends BlogState {}

class BlogStateLoading extends BlogState {}

class BlogStateSuccess extends BlogState {
  final Map<String, dynamic> data;

  BlogStateSuccess(this.data);
}

class BlogStateError extends BlogState {
  final Map<String, dynamic> errors;

  BlogStateError(this.errors);
}
