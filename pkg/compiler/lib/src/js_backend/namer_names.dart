// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'namer.dart';

abstract class _NamerName extends js_ast.Name {
  int get _kind;

  @override
  _NamerName withSourceInformation(
    js_ast.JavaScriptNodeSourceInformation? newSourceInformation,
  ) {
    if (sourceInformation == newSourceInformation) return this;
    final name = this; // Variable needed for type promotion in next line.
    final underlying = name is _NameReference ? name._target : this;
    return _NameReference(underlying, newSourceInformation);
  }

  int _compareSameKind(covariant _NamerName name);

  @override
  String toString() {
    if (debugMode) {
      return 'Name($key)';
    }
    throw UnsupportedError("Cannot convert a name to a string");
  }
}

enum _NamerNameKinds { stringBacked, getter, setter, async, compound, token }

/// An arbitrary but stable sorting comparison method.
int compareNames(js_ast.Name aName, js_ast.Name bName) {
  _NamerName dereference(js_ast.Name name) {
    if (name is ModularName) return dereference(name.value);
    if (name is _NameReference) return dereference(name._target);
    if (name is _NamerName) return name;
    throw UnsupportedError('Cannot find underlying _NamerName: $name');
  }

  _NamerName a = dereference(aName);
  _NamerName b = dereference(bName);

  int aKind = a._kind;
  int bKind = b._kind;
  if (bKind != aKind) return bKind - aKind;
  return a._compareSameKind(b);
}

class StringBackedName extends _NamerName {
  @override
  final String name;
  @override
  int get _kind => _NamerNameKinds.stringBacked.index;

  StringBackedName(this.name);

  @override
  String get key => name;

  @override
  bool operator ==(Object other) {
    if (other is _NameReference) return this == other._target;
    if (identical(this, other)) return true;
    return other is StringBackedName && name == other.name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  int _compareSameKind(StringBackedName other) {
    return name.compareTo(other.name);
  }
}

abstract class _PrefixedName extends _NamerName implements js_ast.AstContainer {
  final js_ast.Name prefix;
  final js_ast.Name base;
  @override
  int get _kind;

  @override
  Iterable<js_ast.Node> get containedNodes => [prefix, base];

  _PrefixedName(this.prefix, this.base);

  @override
  String get name => prefix.name + base.name;

  @override
  String get key => prefix.key + base.key;

  @override
  bool operator ==(Object other) {
    if (other is _NameReference) return this == other._target;
    if (identical(this, other)) return true;
    return other is _PrefixedName &&
        base == other.base &&
        prefix == other.prefix;
  }

  @override
  int get hashCode => base.hashCode * 13 + prefix.hashCode;

  @override
  bool get isFinalized => prefix.isFinalized && base.isFinalized;

  @override
  int _compareSameKind(_PrefixedName other) {
    int result = compareNames(prefix, other.prefix);
    if (result == 0) {
      result = compareNames(base, other.base);
    }
    return result;
  }
}

class GetterName extends _PrefixedName {
  @override
  int get _kind => _NamerNameKinds.getter.index;

  GetterName(super.prefix, super.base);
}

class SetterName extends _PrefixedName {
  @override
  int get _kind => _NamerNameKinds.setter.index;

  SetterName(super.prefix, super.base);
}

class AsyncName extends _PrefixedName {
  @override
  int get _kind => _NamerNameKinds.async.index;

  AsyncName(super.prefix, super.base);

  @override
  bool get allowRename => true;
}

class CompoundName extends _NamerName implements js_ast.AstContainer {
  final List<_NamerName> _parts;
  @override
  int get _kind => _NamerNameKinds.compound.index;
  int _cachedHashCode = -1;

  @override
  Iterable<js_ast.Node> get containedNodes => _parts;

  CompoundName(this._parts);

  @override
  bool get isFinalized => _parts.every((name) => name.isFinalized);

  @override
  late final String name = _parts.map((js_ast.Name name) => name.name).join();

  @override
  String get key => _parts.map((_NamerName name) => name.key).join();

  @override
  bool operator ==(Object other) {
    if (other is _NameReference) return this == other._target;
    if (identical(this, other)) return true;
    if (other is CompoundName) {
      if (other._parts.length != _parts.length) return false;
      for (int i = 0; i < _parts.length; ++i) {
        if (_parts[i] != other._parts[i]) return false;
      }
      return true;
    }
    return false;
  }

  @override
  int get hashCode {
    if (_cachedHashCode < 0) {
      _cachedHashCode = 0;
      for (js_ast.Name name in _parts) {
        _cachedHashCode = (_cachedHashCode * 17 + name.hashCode) & 0x7fffffff;
      }
    }
    return _cachedHashCode;
  }

  @override
  int _compareSameKind(CompoundName other) {
    int result = _parts.length.compareTo(other._parts.length);
    for (int pos = 0; result == 0 && pos < _parts.length; pos++) {
      result = compareNames(_parts[pos], other._parts[pos]);
    }
    return result;
  }
}

class TokenName extends _NamerName implements js_ast.ReferenceCountedAstNode {
  @override
  int get _kind => _NamerNameKinds.token.index;
  String? _name;
  @override
  final String key;
  final TokenScope _scope;
  int _rc = 0;

  TokenName(this._scope, this.key);

  @override
  bool get isFinalized => _name != null;

  @override
  String get name => _name!;

  @override
  int _compareSameKind(TokenName other) {
    return key.compareTo(other.key);
  }

  @override
  void markSeen(js_ast.TokenCounter counter) => _rc++;

  @override
  // ignore: hash_and_equals
  bool operator ==(Object other) {
    if (other is _NameReference) return this == other._target;
    if (identical(this, other)) return true;
    return false;
  }

  void finalize() {
    assert(
      !isFinalized,
      failedAt(
        noLocationSpannable,
        "TokenName($key)=$_name has already been finalized.",
      ),
    );
    _name = _scope.getNextName();
  }
}

/// A [_NameReference] behaves like the underlying (target) [_NamerName] but
/// carries its own [JavaScriptNodeSourceInformation].
// TODO(sra): See if this functionality can be moved into js_ast.
class _NameReference extends _NamerName implements js_ast.AstContainer {
  final _NamerName _target;
  final js_ast.JavaScriptNodeSourceInformation? _sourceInformation;

  _NameReference(this._target, this._sourceInformation);

  @override
  js_ast.JavaScriptNodeSourceInformation? get sourceInformation =>
      _sourceInformation;

  @override
  int get _kind => _target._kind;
  @override
  String get key => _target.key;

  @override
  Iterable<js_ast.Node> get containedNodes => [_target];

  @override
  String get name => _target.name;

  @override
  int _compareSameKind(_NameReference other) {
    throw StateError('Should have been dereferenced: $this');
  }

  @override
  bool get isFinalized => _target.isFinalized;

  @override
  bool operator ==(Object other) => _target == other;

  @override
  int get hashCode => _target.hashCode;
}
