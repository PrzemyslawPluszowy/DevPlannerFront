// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_content_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatLinkResponse {

 String get url; String? get host; bool get isHttps; bool get isInternal; bool get previewAllowed;
/// Create a copy of ChatLinkResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatLinkResponseCopyWith<ChatLinkResponse> get copyWith => _$ChatLinkResponseCopyWithImpl<ChatLinkResponse>(this as ChatLinkResponse, _$identity);

  /// Serializes this ChatLinkResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatLinkResponse&&(identical(other.url, url) || other.url == url)&&(identical(other.host, host) || other.host == host)&&(identical(other.isHttps, isHttps) || other.isHttps == isHttps)&&(identical(other.isInternal, isInternal) || other.isInternal == isInternal)&&(identical(other.previewAllowed, previewAllowed) || other.previewAllowed == previewAllowed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,host,isHttps,isInternal,previewAllowed);

@override
String toString() {
  return 'ChatLinkResponse(url: $url, host: $host, isHttps: $isHttps, isInternal: $isInternal, previewAllowed: $previewAllowed)';
}


}

/// @nodoc
abstract mixin class $ChatLinkResponseCopyWith<$Res>  {
  factory $ChatLinkResponseCopyWith(ChatLinkResponse value, $Res Function(ChatLinkResponse) _then) = _$ChatLinkResponseCopyWithImpl;
@useResult
$Res call({
 String url, String? host, bool isHttps, bool isInternal, bool previewAllowed
});




}
/// @nodoc
class _$ChatLinkResponseCopyWithImpl<$Res>
    implements $ChatLinkResponseCopyWith<$Res> {
  _$ChatLinkResponseCopyWithImpl(this._self, this._then);

  final ChatLinkResponse _self;
  final $Res Function(ChatLinkResponse) _then;

/// Create a copy of ChatLinkResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? host = freezed,Object? isHttps = null,Object? isInternal = null,Object? previewAllowed = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,isHttps: null == isHttps ? _self.isHttps : isHttps // ignore: cast_nullable_to_non_nullable
as bool,isInternal: null == isInternal ? _self.isInternal : isInternal // ignore: cast_nullable_to_non_nullable
as bool,previewAllowed: null == previewAllowed ? _self.previewAllowed : previewAllowed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatLinkResponse].
extension ChatLinkResponsePatterns on ChatLinkResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatLinkResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatLinkResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatLinkResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatLinkResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatLinkResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatLinkResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url,  String? host,  bool isHttps,  bool isInternal,  bool previewAllowed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatLinkResponse() when $default != null:
return $default(_that.url,_that.host,_that.isHttps,_that.isInternal,_that.previewAllowed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url,  String? host,  bool isHttps,  bool isInternal,  bool previewAllowed)  $default,) {final _that = this;
switch (_that) {
case _ChatLinkResponse():
return $default(_that.url,_that.host,_that.isHttps,_that.isInternal,_that.previewAllowed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url,  String? host,  bool isHttps,  bool isInternal,  bool previewAllowed)?  $default,) {final _that = this;
switch (_that) {
case _ChatLinkResponse() when $default != null:
return $default(_that.url,_that.host,_that.isHttps,_that.isInternal,_that.previewAllowed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatLinkResponse implements ChatLinkResponse {
  const _ChatLinkResponse({required this.url, this.host, required this.isHttps, required this.isInternal, required this.previewAllowed});
  factory _ChatLinkResponse.fromJson(Map<String, dynamic> json) => _$ChatLinkResponseFromJson(json);

@override final  String url;
@override final  String? host;
@override final  bool isHttps;
@override final  bool isInternal;
@override final  bool previewAllowed;

/// Create a copy of ChatLinkResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatLinkResponseCopyWith<_ChatLinkResponse> get copyWith => __$ChatLinkResponseCopyWithImpl<_ChatLinkResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatLinkResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatLinkResponse&&(identical(other.url, url) || other.url == url)&&(identical(other.host, host) || other.host == host)&&(identical(other.isHttps, isHttps) || other.isHttps == isHttps)&&(identical(other.isInternal, isInternal) || other.isInternal == isInternal)&&(identical(other.previewAllowed, previewAllowed) || other.previewAllowed == previewAllowed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,host,isHttps,isInternal,previewAllowed);

@override
String toString() {
  return 'ChatLinkResponse(url: $url, host: $host, isHttps: $isHttps, isInternal: $isInternal, previewAllowed: $previewAllowed)';
}


}

/// @nodoc
abstract mixin class _$ChatLinkResponseCopyWith<$Res> implements $ChatLinkResponseCopyWith<$Res> {
  factory _$ChatLinkResponseCopyWith(_ChatLinkResponse value, $Res Function(_ChatLinkResponse) _then) = __$ChatLinkResponseCopyWithImpl;
@override @useResult
$Res call({
 String url, String? host, bool isHttps, bool isInternal, bool previewAllowed
});




}
/// @nodoc
class __$ChatLinkResponseCopyWithImpl<$Res>
    implements _$ChatLinkResponseCopyWith<$Res> {
  __$ChatLinkResponseCopyWithImpl(this._self, this._then);

  final _ChatLinkResponse _self;
  final $Res Function(_ChatLinkResponse) _then;

/// Create a copy of ChatLinkResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? host = freezed,Object? isHttps = null,Object? isInternal = null,Object? previewAllowed = null,}) {
  return _then(_ChatLinkResponse(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,isHttps: null == isHttps ? _self.isHttps : isHttps // ignore: cast_nullable_to_non_nullable
as bool,isInternal: null == isInternal ? _self.isInternal : isInternal // ignore: cast_nullable_to_non_nullable
as bool,previewAllowed: null == previewAllowed ? _self.previewAllowed : previewAllowed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChatLinkPreviewResponse {

 String get finalUrl; String? get title; String? get description; String? get contentType; DateTime get fetchedAtUtc;
/// Create a copy of ChatLinkPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatLinkPreviewResponseCopyWith<ChatLinkPreviewResponse> get copyWith => _$ChatLinkPreviewResponseCopyWithImpl<ChatLinkPreviewResponse>(this as ChatLinkPreviewResponse, _$identity);

  /// Serializes this ChatLinkPreviewResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatLinkPreviewResponse&&(identical(other.finalUrl, finalUrl) || other.finalUrl == finalUrl)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.fetchedAtUtc, fetchedAtUtc) || other.fetchedAtUtc == fetchedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,finalUrl,title,description,contentType,fetchedAtUtc);

@override
String toString() {
  return 'ChatLinkPreviewResponse(finalUrl: $finalUrl, title: $title, description: $description, contentType: $contentType, fetchedAtUtc: $fetchedAtUtc)';
}


}

/// @nodoc
abstract mixin class $ChatLinkPreviewResponseCopyWith<$Res>  {
  factory $ChatLinkPreviewResponseCopyWith(ChatLinkPreviewResponse value, $Res Function(ChatLinkPreviewResponse) _then) = _$ChatLinkPreviewResponseCopyWithImpl;
@useResult
$Res call({
 String finalUrl, String? title, String? description, String? contentType, DateTime fetchedAtUtc
});




}
/// @nodoc
class _$ChatLinkPreviewResponseCopyWithImpl<$Res>
    implements $ChatLinkPreviewResponseCopyWith<$Res> {
  _$ChatLinkPreviewResponseCopyWithImpl(this._self, this._then);

  final ChatLinkPreviewResponse _self;
  final $Res Function(ChatLinkPreviewResponse) _then;

/// Create a copy of ChatLinkPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? finalUrl = null,Object? title = freezed,Object? description = freezed,Object? contentType = freezed,Object? fetchedAtUtc = null,}) {
  return _then(_self.copyWith(
finalUrl: null == finalUrl ? _self.finalUrl : finalUrl // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,fetchedAtUtc: null == fetchedAtUtc ? _self.fetchedAtUtc : fetchedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatLinkPreviewResponse].
extension ChatLinkPreviewResponsePatterns on ChatLinkPreviewResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatLinkPreviewResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatLinkPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatLinkPreviewResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatLinkPreviewResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatLinkPreviewResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatLinkPreviewResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String finalUrl,  String? title,  String? description,  String? contentType,  DateTime fetchedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatLinkPreviewResponse() when $default != null:
return $default(_that.finalUrl,_that.title,_that.description,_that.contentType,_that.fetchedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String finalUrl,  String? title,  String? description,  String? contentType,  DateTime fetchedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ChatLinkPreviewResponse():
return $default(_that.finalUrl,_that.title,_that.description,_that.contentType,_that.fetchedAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String finalUrl,  String? title,  String? description,  String? contentType,  DateTime fetchedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ChatLinkPreviewResponse() when $default != null:
return $default(_that.finalUrl,_that.title,_that.description,_that.contentType,_that.fetchedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatLinkPreviewResponse implements ChatLinkPreviewResponse {
  const _ChatLinkPreviewResponse({required this.finalUrl, this.title, this.description, this.contentType, required this.fetchedAtUtc});
  factory _ChatLinkPreviewResponse.fromJson(Map<String, dynamic> json) => _$ChatLinkPreviewResponseFromJson(json);

@override final  String finalUrl;
@override final  String? title;
@override final  String? description;
@override final  String? contentType;
@override final  DateTime fetchedAtUtc;

/// Create a copy of ChatLinkPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatLinkPreviewResponseCopyWith<_ChatLinkPreviewResponse> get copyWith => __$ChatLinkPreviewResponseCopyWithImpl<_ChatLinkPreviewResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatLinkPreviewResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatLinkPreviewResponse&&(identical(other.finalUrl, finalUrl) || other.finalUrl == finalUrl)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.fetchedAtUtc, fetchedAtUtc) || other.fetchedAtUtc == fetchedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,finalUrl,title,description,contentType,fetchedAtUtc);

@override
String toString() {
  return 'ChatLinkPreviewResponse(finalUrl: $finalUrl, title: $title, description: $description, contentType: $contentType, fetchedAtUtc: $fetchedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ChatLinkPreviewResponseCopyWith<$Res> implements $ChatLinkPreviewResponseCopyWith<$Res> {
  factory _$ChatLinkPreviewResponseCopyWith(_ChatLinkPreviewResponse value, $Res Function(_ChatLinkPreviewResponse) _then) = __$ChatLinkPreviewResponseCopyWithImpl;
@override @useResult
$Res call({
 String finalUrl, String? title, String? description, String? contentType, DateTime fetchedAtUtc
});




}
/// @nodoc
class __$ChatLinkPreviewResponseCopyWithImpl<$Res>
    implements _$ChatLinkPreviewResponseCopyWith<$Res> {
  __$ChatLinkPreviewResponseCopyWithImpl(this._self, this._then);

  final _ChatLinkPreviewResponse _self;
  final $Res Function(_ChatLinkPreviewResponse) _then;

/// Create a copy of ChatLinkPreviewResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? finalUrl = null,Object? title = freezed,Object? description = freezed,Object? contentType = freezed,Object? fetchedAtUtc = null,}) {
  return _then(_ChatLinkPreviewResponse(
finalUrl: null == finalUrl ? _self.finalUrl : finalUrl // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,fetchedAtUtc: null == fetchedAtUtc ? _self.fetchedAtUtc : fetchedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ChatSnippetPayload {

 String get text; String get format; bool get force;
/// Create a copy of ChatSnippetPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSnippetPayloadCopyWith<ChatSnippetPayload> get copyWith => _$ChatSnippetPayloadCopyWithImpl<ChatSnippetPayload>(this as ChatSnippetPayload, _$identity);

  /// Serializes this ChatSnippetPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSnippetPayload&&(identical(other.text, text) || other.text == text)&&(identical(other.format, format) || other.format == format)&&(identical(other.force, force) || other.force == force));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,format,force);

@override
String toString() {
  return 'ChatSnippetPayload(text: $text, format: $format, force: $force)';
}


}

/// @nodoc
abstract mixin class $ChatSnippetPayloadCopyWith<$Res>  {
  factory $ChatSnippetPayloadCopyWith(ChatSnippetPayload value, $Res Function(ChatSnippetPayload) _then) = _$ChatSnippetPayloadCopyWithImpl;
@useResult
$Res call({
 String text, String format, bool force
});




}
/// @nodoc
class _$ChatSnippetPayloadCopyWithImpl<$Res>
    implements $ChatSnippetPayloadCopyWith<$Res> {
  _$ChatSnippetPayloadCopyWithImpl(this._self, this._then);

  final ChatSnippetPayload _self;
  final $Res Function(ChatSnippetPayload) _then;

/// Create a copy of ChatSnippetPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? format = null,Object? force = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,force: null == force ? _self.force : force // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatSnippetPayload].
extension ChatSnippetPayloadPatterns on ChatSnippetPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatSnippetPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatSnippetPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatSnippetPayload value)  $default,){
final _that = this;
switch (_that) {
case _ChatSnippetPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatSnippetPayload value)?  $default,){
final _that = this;
switch (_that) {
case _ChatSnippetPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  String format,  bool force)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatSnippetPayload() when $default != null:
return $default(_that.text,_that.format,_that.force);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  String format,  bool force)  $default,) {final _that = this;
switch (_that) {
case _ChatSnippetPayload():
return $default(_that.text,_that.format,_that.force);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  String format,  bool force)?  $default,) {final _that = this;
switch (_that) {
case _ChatSnippetPayload() when $default != null:
return $default(_that.text,_that.format,_that.force);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatSnippetPayload implements ChatSnippetPayload {
  const _ChatSnippetPayload({required this.text, this.format = 'PlainText', this.force = false});
  factory _ChatSnippetPayload.fromJson(Map<String, dynamic> json) => _$ChatSnippetPayloadFromJson(json);

@override final  String text;
@override@JsonKey() final  String format;
@override@JsonKey() final  bool force;

/// Create a copy of ChatSnippetPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatSnippetPayloadCopyWith<_ChatSnippetPayload> get copyWith => __$ChatSnippetPayloadCopyWithImpl<_ChatSnippetPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatSnippetPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatSnippetPayload&&(identical(other.text, text) || other.text == text)&&(identical(other.format, format) || other.format == format)&&(identical(other.force, force) || other.force == force));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,format,force);

@override
String toString() {
  return 'ChatSnippetPayload(text: $text, format: $format, force: $force)';
}


}

/// @nodoc
abstract mixin class _$ChatSnippetPayloadCopyWith<$Res> implements $ChatSnippetPayloadCopyWith<$Res> {
  factory _$ChatSnippetPayloadCopyWith(_ChatSnippetPayload value, $Res Function(_ChatSnippetPayload) _then) = __$ChatSnippetPayloadCopyWithImpl;
@override @useResult
$Res call({
 String text, String format, bool force
});




}
/// @nodoc
class __$ChatSnippetPayloadCopyWithImpl<$Res>
    implements _$ChatSnippetPayloadCopyWith<$Res> {
  __$ChatSnippetPayloadCopyWithImpl(this._self, this._then);

  final _ChatSnippetPayload _self;
  final $Res Function(_ChatSnippetPayload) _then;

/// Create a copy of ChatSnippetPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? format = null,Object? force = null,}) {
  return _then(_ChatSnippetPayload(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,force: null == force ? _self.force : force // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChatSnippetResponse {

 bool get isSnippet; int get originalLength; String? get suggestedFileName; String? get mimeType; String? get content; bool get isTruncated;
/// Create a copy of ChatSnippetResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSnippetResponseCopyWith<ChatSnippetResponse> get copyWith => _$ChatSnippetResponseCopyWithImpl<ChatSnippetResponse>(this as ChatSnippetResponse, _$identity);

  /// Serializes this ChatSnippetResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSnippetResponse&&(identical(other.isSnippet, isSnippet) || other.isSnippet == isSnippet)&&(identical(other.originalLength, originalLength) || other.originalLength == originalLength)&&(identical(other.suggestedFileName, suggestedFileName) || other.suggestedFileName == suggestedFileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.content, content) || other.content == content)&&(identical(other.isTruncated, isTruncated) || other.isTruncated == isTruncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isSnippet,originalLength,suggestedFileName,mimeType,content,isTruncated);

@override
String toString() {
  return 'ChatSnippetResponse(isSnippet: $isSnippet, originalLength: $originalLength, suggestedFileName: $suggestedFileName, mimeType: $mimeType, content: $content, isTruncated: $isTruncated)';
}


}

/// @nodoc
abstract mixin class $ChatSnippetResponseCopyWith<$Res>  {
  factory $ChatSnippetResponseCopyWith(ChatSnippetResponse value, $Res Function(ChatSnippetResponse) _then) = _$ChatSnippetResponseCopyWithImpl;
@useResult
$Res call({
 bool isSnippet, int originalLength, String? suggestedFileName, String? mimeType, String? content, bool isTruncated
});




}
/// @nodoc
class _$ChatSnippetResponseCopyWithImpl<$Res>
    implements $ChatSnippetResponseCopyWith<$Res> {
  _$ChatSnippetResponseCopyWithImpl(this._self, this._then);

  final ChatSnippetResponse _self;
  final $Res Function(ChatSnippetResponse) _then;

/// Create a copy of ChatSnippetResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSnippet = null,Object? originalLength = null,Object? suggestedFileName = freezed,Object? mimeType = freezed,Object? content = freezed,Object? isTruncated = null,}) {
  return _then(_self.copyWith(
isSnippet: null == isSnippet ? _self.isSnippet : isSnippet // ignore: cast_nullable_to_non_nullable
as bool,originalLength: null == originalLength ? _self.originalLength : originalLength // ignore: cast_nullable_to_non_nullable
as int,suggestedFileName: freezed == suggestedFileName ? _self.suggestedFileName : suggestedFileName // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,isTruncated: null == isTruncated ? _self.isTruncated : isTruncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatSnippetResponse].
extension ChatSnippetResponsePatterns on ChatSnippetResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatSnippetResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatSnippetResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatSnippetResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatSnippetResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatSnippetResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatSnippetResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSnippet,  int originalLength,  String? suggestedFileName,  String? mimeType,  String? content,  bool isTruncated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatSnippetResponse() when $default != null:
return $default(_that.isSnippet,_that.originalLength,_that.suggestedFileName,_that.mimeType,_that.content,_that.isTruncated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSnippet,  int originalLength,  String? suggestedFileName,  String? mimeType,  String? content,  bool isTruncated)  $default,) {final _that = this;
switch (_that) {
case _ChatSnippetResponse():
return $default(_that.isSnippet,_that.originalLength,_that.suggestedFileName,_that.mimeType,_that.content,_that.isTruncated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSnippet,  int originalLength,  String? suggestedFileName,  String? mimeType,  String? content,  bool isTruncated)?  $default,) {final _that = this;
switch (_that) {
case _ChatSnippetResponse() when $default != null:
return $default(_that.isSnippet,_that.originalLength,_that.suggestedFileName,_that.mimeType,_that.content,_that.isTruncated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatSnippetResponse implements ChatSnippetResponse {
  const _ChatSnippetResponse({required this.isSnippet, required this.originalLength, this.suggestedFileName, this.mimeType, this.content, required this.isTruncated});
  factory _ChatSnippetResponse.fromJson(Map<String, dynamic> json) => _$ChatSnippetResponseFromJson(json);

@override final  bool isSnippet;
@override final  int originalLength;
@override final  String? suggestedFileName;
@override final  String? mimeType;
@override final  String? content;
@override final  bool isTruncated;

/// Create a copy of ChatSnippetResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatSnippetResponseCopyWith<_ChatSnippetResponse> get copyWith => __$ChatSnippetResponseCopyWithImpl<_ChatSnippetResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatSnippetResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatSnippetResponse&&(identical(other.isSnippet, isSnippet) || other.isSnippet == isSnippet)&&(identical(other.originalLength, originalLength) || other.originalLength == originalLength)&&(identical(other.suggestedFileName, suggestedFileName) || other.suggestedFileName == suggestedFileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.content, content) || other.content == content)&&(identical(other.isTruncated, isTruncated) || other.isTruncated == isTruncated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isSnippet,originalLength,suggestedFileName,mimeType,content,isTruncated);

@override
String toString() {
  return 'ChatSnippetResponse(isSnippet: $isSnippet, originalLength: $originalLength, suggestedFileName: $suggestedFileName, mimeType: $mimeType, content: $content, isTruncated: $isTruncated)';
}


}

/// @nodoc
abstract mixin class _$ChatSnippetResponseCopyWith<$Res> implements $ChatSnippetResponseCopyWith<$Res> {
  factory _$ChatSnippetResponseCopyWith(_ChatSnippetResponse value, $Res Function(_ChatSnippetResponse) _then) = __$ChatSnippetResponseCopyWithImpl;
@override @useResult
$Res call({
 bool isSnippet, int originalLength, String? suggestedFileName, String? mimeType, String? content, bool isTruncated
});




}
/// @nodoc
class __$ChatSnippetResponseCopyWithImpl<$Res>
    implements _$ChatSnippetResponseCopyWith<$Res> {
  __$ChatSnippetResponseCopyWithImpl(this._self, this._then);

  final _ChatSnippetResponse _self;
  final $Res Function(_ChatSnippetResponse) _then;

/// Create a copy of ChatSnippetResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSnippet = null,Object? originalLength = null,Object? suggestedFileName = freezed,Object? mimeType = freezed,Object? content = freezed,Object? isTruncated = null,}) {
  return _then(_ChatSnippetResponse(
isSnippet: null == isSnippet ? _self.isSnippet : isSnippet // ignore: cast_nullable_to_non_nullable
as bool,originalLength: null == originalLength ? _self.originalLength : originalLength // ignore: cast_nullable_to_non_nullable
as int,suggestedFileName: freezed == suggestedFileName ? _self.suggestedFileName : suggestedFileName // ignore: cast_nullable_to_non_nullable
as String?,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,isTruncated: null == isTruncated ? _self.isTruncated : isTruncated // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChatSnippetAttachmentResponse {

 ChatAttachmentResponse get attachment; String get fileName; int get fileSizeBytes; StorageScanStatus get scanStatus;
/// Create a copy of ChatSnippetAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatSnippetAttachmentResponseCopyWith<ChatSnippetAttachmentResponse> get copyWith => _$ChatSnippetAttachmentResponseCopyWithImpl<ChatSnippetAttachmentResponse>(this as ChatSnippetAttachmentResponse, _$identity);

  /// Serializes this ChatSnippetAttachmentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatSnippetAttachmentResponse&&(identical(other.attachment, attachment) || other.attachment == attachment)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.scanStatus, scanStatus) || other.scanStatus == scanStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attachment,fileName,fileSizeBytes,scanStatus);

@override
String toString() {
  return 'ChatSnippetAttachmentResponse(attachment: $attachment, fileName: $fileName, fileSizeBytes: $fileSizeBytes, scanStatus: $scanStatus)';
}


}

/// @nodoc
abstract mixin class $ChatSnippetAttachmentResponseCopyWith<$Res>  {
  factory $ChatSnippetAttachmentResponseCopyWith(ChatSnippetAttachmentResponse value, $Res Function(ChatSnippetAttachmentResponse) _then) = _$ChatSnippetAttachmentResponseCopyWithImpl;
@useResult
$Res call({
 ChatAttachmentResponse attachment, String fileName, int fileSizeBytes, StorageScanStatus scanStatus
});


$ChatAttachmentResponseCopyWith<$Res> get attachment;

}
/// @nodoc
class _$ChatSnippetAttachmentResponseCopyWithImpl<$Res>
    implements $ChatSnippetAttachmentResponseCopyWith<$Res> {
  _$ChatSnippetAttachmentResponseCopyWithImpl(this._self, this._then);

  final ChatSnippetAttachmentResponse _self;
  final $Res Function(ChatSnippetAttachmentResponse) _then;

/// Create a copy of ChatSnippetAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attachment = null,Object? fileName = null,Object? fileSizeBytes = null,Object? scanStatus = null,}) {
  return _then(_self.copyWith(
attachment: null == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as ChatAttachmentResponse,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,scanStatus: null == scanStatus ? _self.scanStatus : scanStatus // ignore: cast_nullable_to_non_nullable
as StorageScanStatus,
  ));
}
/// Create a copy of ChatSnippetAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatAttachmentResponseCopyWith<$Res> get attachment {
  
  return $ChatAttachmentResponseCopyWith<$Res>(_self.attachment, (value) {
    return _then(_self.copyWith(attachment: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatSnippetAttachmentResponse].
extension ChatSnippetAttachmentResponsePatterns on ChatSnippetAttachmentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatSnippetAttachmentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatSnippetAttachmentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatSnippetAttachmentResponse value)  $default,){
final _that = this;
switch (_that) {
case _ChatSnippetAttachmentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatSnippetAttachmentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ChatSnippetAttachmentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ChatAttachmentResponse attachment,  String fileName,  int fileSizeBytes,  StorageScanStatus scanStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatSnippetAttachmentResponse() when $default != null:
return $default(_that.attachment,_that.fileName,_that.fileSizeBytes,_that.scanStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ChatAttachmentResponse attachment,  String fileName,  int fileSizeBytes,  StorageScanStatus scanStatus)  $default,) {final _that = this;
switch (_that) {
case _ChatSnippetAttachmentResponse():
return $default(_that.attachment,_that.fileName,_that.fileSizeBytes,_that.scanStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ChatAttachmentResponse attachment,  String fileName,  int fileSizeBytes,  StorageScanStatus scanStatus)?  $default,) {final _that = this;
switch (_that) {
case _ChatSnippetAttachmentResponse() when $default != null:
return $default(_that.attachment,_that.fileName,_that.fileSizeBytes,_that.scanStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatSnippetAttachmentResponse implements ChatSnippetAttachmentResponse {
  const _ChatSnippetAttachmentResponse({required this.attachment, required this.fileName, required this.fileSizeBytes, required this.scanStatus});
  factory _ChatSnippetAttachmentResponse.fromJson(Map<String, dynamic> json) => _$ChatSnippetAttachmentResponseFromJson(json);

@override final  ChatAttachmentResponse attachment;
@override final  String fileName;
@override final  int fileSizeBytes;
@override final  StorageScanStatus scanStatus;

/// Create a copy of ChatSnippetAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatSnippetAttachmentResponseCopyWith<_ChatSnippetAttachmentResponse> get copyWith => __$ChatSnippetAttachmentResponseCopyWithImpl<_ChatSnippetAttachmentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatSnippetAttachmentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatSnippetAttachmentResponse&&(identical(other.attachment, attachment) || other.attachment == attachment)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.fileSizeBytes, fileSizeBytes) || other.fileSizeBytes == fileSizeBytes)&&(identical(other.scanStatus, scanStatus) || other.scanStatus == scanStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,attachment,fileName,fileSizeBytes,scanStatus);

@override
String toString() {
  return 'ChatSnippetAttachmentResponse(attachment: $attachment, fileName: $fileName, fileSizeBytes: $fileSizeBytes, scanStatus: $scanStatus)';
}


}

/// @nodoc
abstract mixin class _$ChatSnippetAttachmentResponseCopyWith<$Res> implements $ChatSnippetAttachmentResponseCopyWith<$Res> {
  factory _$ChatSnippetAttachmentResponseCopyWith(_ChatSnippetAttachmentResponse value, $Res Function(_ChatSnippetAttachmentResponse) _then) = __$ChatSnippetAttachmentResponseCopyWithImpl;
@override @useResult
$Res call({
 ChatAttachmentResponse attachment, String fileName, int fileSizeBytes, StorageScanStatus scanStatus
});


@override $ChatAttachmentResponseCopyWith<$Res> get attachment;

}
/// @nodoc
class __$ChatSnippetAttachmentResponseCopyWithImpl<$Res>
    implements _$ChatSnippetAttachmentResponseCopyWith<$Res> {
  __$ChatSnippetAttachmentResponseCopyWithImpl(this._self, this._then);

  final _ChatSnippetAttachmentResponse _self;
  final $Res Function(_ChatSnippetAttachmentResponse) _then;

/// Create a copy of ChatSnippetAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attachment = null,Object? fileName = null,Object? fileSizeBytes = null,Object? scanStatus = null,}) {
  return _then(_ChatSnippetAttachmentResponse(
attachment: null == attachment ? _self.attachment : attachment // ignore: cast_nullable_to_non_nullable
as ChatAttachmentResponse,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,scanStatus: null == scanStatus ? _self.scanStatus : scanStatus // ignore: cast_nullable_to_non_nullable
as StorageScanStatus,
  ));
}

/// Create a copy of ChatSnippetAttachmentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatAttachmentResponseCopyWith<$Res> get attachment {
  
  return $ChatAttachmentResponseCopyWith<$Res>(_self.attachment, (value) {
    return _then(_self.copyWith(attachment: value));
  });
}
}

// dart format on
