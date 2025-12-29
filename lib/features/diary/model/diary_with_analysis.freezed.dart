// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary_with_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DiaryWithAnalysis {

@JsonKey(name: 'post_id', includeToJson: false) String? get postId;@JsonKey(name: 'user_id', includeToJson: false) String? get userId; DateTime get date; String get title; String get description; String? get sentiment; List<String>? get emotion; String? get summary;
/// Create a copy of DiaryWithAnalysis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryWithAnalysisCopyWith<DiaryWithAnalysis> get copyWith => _$DiaryWithAnalysisCopyWithImpl<DiaryWithAnalysis>(this as DiaryWithAnalysis, _$identity);

  /// Serializes this DiaryWithAnalysis to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiaryWithAnalysis&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.sentiment, sentiment) || other.sentiment == sentiment)&&const DeepCollectionEquality().equals(other.emotion, emotion)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postId,userId,date,title,description,sentiment,const DeepCollectionEquality().hash(emotion),summary);

@override
String toString() {
  return 'DiaryWithAnalysis(postId: $postId, userId: $userId, date: $date, title: $title, description: $description, sentiment: $sentiment, emotion: $emotion, summary: $summary)';
}


}

/// @nodoc
abstract mixin class $DiaryWithAnalysisCopyWith<$Res>  {
  factory $DiaryWithAnalysisCopyWith(DiaryWithAnalysis value, $Res Function(DiaryWithAnalysis) _then) = _$DiaryWithAnalysisCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'post_id', includeToJson: false) String? postId,@JsonKey(name: 'user_id', includeToJson: false) String? userId, DateTime date, String title, String description, String? sentiment, List<String>? emotion, String? summary
});




}
/// @nodoc
class _$DiaryWithAnalysisCopyWithImpl<$Res>
    implements $DiaryWithAnalysisCopyWith<$Res> {
  _$DiaryWithAnalysisCopyWithImpl(this._self, this._then);

  final DiaryWithAnalysis _self;
  final $Res Function(DiaryWithAnalysis) _then;

/// Create a copy of DiaryWithAnalysis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? postId = freezed,Object? userId = freezed,Object? date = null,Object? title = null,Object? description = null,Object? sentiment = freezed,Object? emotion = freezed,Object? summary = freezed,}) {
  return _then(_self.copyWith(
postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sentiment: freezed == sentiment ? _self.sentiment : sentiment // ignore: cast_nullable_to_non_nullable
as String?,emotion: freezed == emotion ? _self.emotion : emotion // ignore: cast_nullable_to_non_nullable
as List<String>?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiaryWithAnalysis].
extension DiaryWithAnalysisPatterns on DiaryWithAnalysis {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiaryWithAnalysis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiaryWithAnalysis() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiaryWithAnalysis value)  $default,){
final _that = this;
switch (_that) {
case _DiaryWithAnalysis():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiaryWithAnalysis value)?  $default,){
final _that = this;
switch (_that) {
case _DiaryWithAnalysis() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'post_id', includeToJson: false)  String? postId, @JsonKey(name: 'user_id', includeToJson: false)  String? userId,  DateTime date,  String title,  String description,  String? sentiment,  List<String>? emotion,  String? summary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiaryWithAnalysis() when $default != null:
return $default(_that.postId,_that.userId,_that.date,_that.title,_that.description,_that.sentiment,_that.emotion,_that.summary);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'post_id', includeToJson: false)  String? postId, @JsonKey(name: 'user_id', includeToJson: false)  String? userId,  DateTime date,  String title,  String description,  String? sentiment,  List<String>? emotion,  String? summary)  $default,) {final _that = this;
switch (_that) {
case _DiaryWithAnalysis():
return $default(_that.postId,_that.userId,_that.date,_that.title,_that.description,_that.sentiment,_that.emotion,_that.summary);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'post_id', includeToJson: false)  String? postId, @JsonKey(name: 'user_id', includeToJson: false)  String? userId,  DateTime date,  String title,  String description,  String? sentiment,  List<String>? emotion,  String? summary)?  $default,) {final _that = this;
switch (_that) {
case _DiaryWithAnalysis() when $default != null:
return $default(_that.postId,_that.userId,_that.date,_that.title,_that.description,_that.sentiment,_that.emotion,_that.summary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiaryWithAnalysis implements DiaryWithAnalysis {
  const _DiaryWithAnalysis({@JsonKey(name: 'post_id', includeToJson: false) this.postId, @JsonKey(name: 'user_id', includeToJson: false) this.userId, required this.date, required this.title, required this.description, this.sentiment, final  List<String>? emotion, this.summary}): _emotion = emotion;
  factory _DiaryWithAnalysis.fromJson(Map<String, dynamic> json) => _$DiaryWithAnalysisFromJson(json);

@override@JsonKey(name: 'post_id', includeToJson: false) final  String? postId;
@override@JsonKey(name: 'user_id', includeToJson: false) final  String? userId;
@override final  DateTime date;
@override final  String title;
@override final  String description;
@override final  String? sentiment;
 final  List<String>? _emotion;
@override List<String>? get emotion {
  final value = _emotion;
  if (value == null) return null;
  if (_emotion is EqualUnmodifiableListView) return _emotion;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? summary;

/// Create a copy of DiaryWithAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryWithAnalysisCopyWith<_DiaryWithAnalysis> get copyWith => __$DiaryWithAnalysisCopyWithImpl<_DiaryWithAnalysis>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryWithAnalysisToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiaryWithAnalysis&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.date, date) || other.date == date)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.sentiment, sentiment) || other.sentiment == sentiment)&&const DeepCollectionEquality().equals(other._emotion, _emotion)&&(identical(other.summary, summary) || other.summary == summary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postId,userId,date,title,description,sentiment,const DeepCollectionEquality().hash(_emotion),summary);

@override
String toString() {
  return 'DiaryWithAnalysis(postId: $postId, userId: $userId, date: $date, title: $title, description: $description, sentiment: $sentiment, emotion: $emotion, summary: $summary)';
}


}

/// @nodoc
abstract mixin class _$DiaryWithAnalysisCopyWith<$Res> implements $DiaryWithAnalysisCopyWith<$Res> {
  factory _$DiaryWithAnalysisCopyWith(_DiaryWithAnalysis value, $Res Function(_DiaryWithAnalysis) _then) = __$DiaryWithAnalysisCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'post_id', includeToJson: false) String? postId,@JsonKey(name: 'user_id', includeToJson: false) String? userId, DateTime date, String title, String description, String? sentiment, List<String>? emotion, String? summary
});




}
/// @nodoc
class __$DiaryWithAnalysisCopyWithImpl<$Res>
    implements _$DiaryWithAnalysisCopyWith<$Res> {
  __$DiaryWithAnalysisCopyWithImpl(this._self, this._then);

  final _DiaryWithAnalysis _self;
  final $Res Function(_DiaryWithAnalysis) _then;

/// Create a copy of DiaryWithAnalysis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? postId = freezed,Object? userId = freezed,Object? date = null,Object? title = null,Object? description = null,Object? sentiment = freezed,Object? emotion = freezed,Object? summary = freezed,}) {
  return _then(_DiaryWithAnalysis(
postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,sentiment: freezed == sentiment ? _self.sentiment : sentiment // ignore: cast_nullable_to_non_nullable
as String?,emotion: freezed == emotion ? _self._emotion : emotion // ignore: cast_nullable_to_non_nullable
as List<String>?,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
