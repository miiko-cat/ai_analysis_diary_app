// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'diary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Diary {

@JsonKey(name: 'post_id', includeToJson: false) String? get postId; DateTime get date; String get title; String get description;@JsonKey(name: 'user_id') String get userId;@JsonKey(name: 'updated_date', includeToJson: false) DateTime? get updatedDate;
/// Create a copy of Diary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiaryCopyWith<Diary> get copyWith => _$DiaryCopyWithImpl<Diary>(this as Diary, _$identity);

  /// Serializes this Diary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Diary&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.date, date) || other.date == date)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.updatedDate, updatedDate) || other.updatedDate == updatedDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postId,date,title,description,userId,updatedDate);

@override
String toString() {
  return 'Diary(postId: $postId, date: $date, title: $title, description: $description, userId: $userId, updatedDate: $updatedDate)';
}


}

/// @nodoc
abstract mixin class $DiaryCopyWith<$Res>  {
  factory $DiaryCopyWith(Diary value, $Res Function(Diary) _then) = _$DiaryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'post_id', includeToJson: false) String? postId, DateTime date, String title, String description,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'updated_date', includeToJson: false) DateTime? updatedDate
});




}
/// @nodoc
class _$DiaryCopyWithImpl<$Res>
    implements $DiaryCopyWith<$Res> {
  _$DiaryCopyWithImpl(this._self, this._then);

  final Diary _self;
  final $Res Function(Diary) _then;

/// Create a copy of Diary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? postId = freezed,Object? date = null,Object? title = null,Object? description = null,Object? userId = null,Object? updatedDate = freezed,}) {
  return _then(_self.copyWith(
postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,updatedDate: freezed == updatedDate ? _self.updatedDate : updatedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Diary].
extension DiaryPatterns on Diary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Diary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Diary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Diary value)  $default,){
final _that = this;
switch (_that) {
case _Diary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Diary value)?  $default,){
final _that = this;
switch (_that) {
case _Diary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'post_id', includeToJson: false)  String? postId,  DateTime date,  String title,  String description, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'updated_date', includeToJson: false)  DateTime? updatedDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Diary() when $default != null:
return $default(_that.postId,_that.date,_that.title,_that.description,_that.userId,_that.updatedDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'post_id', includeToJson: false)  String? postId,  DateTime date,  String title,  String description, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'updated_date', includeToJson: false)  DateTime? updatedDate)  $default,) {final _that = this;
switch (_that) {
case _Diary():
return $default(_that.postId,_that.date,_that.title,_that.description,_that.userId,_that.updatedDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'post_id', includeToJson: false)  String? postId,  DateTime date,  String title,  String description, @JsonKey(name: 'user_id')  String userId, @JsonKey(name: 'updated_date', includeToJson: false)  DateTime? updatedDate)?  $default,) {final _that = this;
switch (_that) {
case _Diary() when $default != null:
return $default(_that.postId,_that.date,_that.title,_that.description,_that.userId,_that.updatedDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Diary implements Diary {
  const _Diary({@JsonKey(name: 'post_id', includeToJson: false) this.postId, required this.date, required this.title, required this.description, @JsonKey(name: 'user_id') required this.userId, @JsonKey(name: 'updated_date', includeToJson: false) this.updatedDate});
  factory _Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);

@override@JsonKey(name: 'post_id', includeToJson: false) final  String? postId;
@override final  DateTime date;
@override final  String title;
@override final  String description;
@override@JsonKey(name: 'user_id') final  String userId;
@override@JsonKey(name: 'updated_date', includeToJson: false) final  DateTime? updatedDate;

/// Create a copy of Diary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiaryCopyWith<_Diary> get copyWith => __$DiaryCopyWithImpl<_Diary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Diary&&(identical(other.postId, postId) || other.postId == postId)&&(identical(other.date, date) || other.date == date)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.updatedDate, updatedDate) || other.updatedDate == updatedDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,postId,date,title,description,userId,updatedDate);

@override
String toString() {
  return 'Diary(postId: $postId, date: $date, title: $title, description: $description, userId: $userId, updatedDate: $updatedDate)';
}


}

/// @nodoc
abstract mixin class _$DiaryCopyWith<$Res> implements $DiaryCopyWith<$Res> {
  factory _$DiaryCopyWith(_Diary value, $Res Function(_Diary) _then) = __$DiaryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'post_id', includeToJson: false) String? postId, DateTime date, String title, String description,@JsonKey(name: 'user_id') String userId,@JsonKey(name: 'updated_date', includeToJson: false) DateTime? updatedDate
});




}
/// @nodoc
class __$DiaryCopyWithImpl<$Res>
    implements _$DiaryCopyWith<$Res> {
  __$DiaryCopyWithImpl(this._self, this._then);

  final _Diary _self;
  final $Res Function(_Diary) _then;

/// Create a copy of Diary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? postId = freezed,Object? date = null,Object? title = null,Object? description = null,Object? userId = null,Object? updatedDate = freezed,}) {
  return _then(_Diary(
postId: freezed == postId ? _self.postId : postId // ignore: cast_nullable_to_non_nullable
as String?,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,updatedDate: freezed == updatedDate ? _self.updatedDate : updatedDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
