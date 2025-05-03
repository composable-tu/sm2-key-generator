//
// Copyright (c) 2025 LuminaPJ
// SM2 Key Generator is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//          http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.
//

import 'package:flutter/material.dart';

import '../src/rust/api/sm2_key_generator.dart';
import '../src/rust/frb_generated.dart';

class KeyGeneratorState with ChangeNotifier {
  String? _publicKey;
  String? _privateKey;
  bool _isLoading = false;
  bool _isRustInit = false;
  String? _error;

  String? get publicKey => _publicKey;
  String? get privateKey => _privateKey;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> generateKeys() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (!_isRustInit) {
        await RustLib.init();
        _isRustInit = true;
      }
      var (pubKey, privKey) = await genSm2Key();
      _publicKey = pubKey;
      _privateKey = privKey;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearKeys() {
    _publicKey = null;
    _privateKey = null;
    _error = null;
    notifyListeners();
  }
}
