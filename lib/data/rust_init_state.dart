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

import '../src/rust/frb_generated.dart';

/// Rust 原生库初始化状态类
/// @param _isRustInitialized 是否已经初始化 rust 库
class RustInitState with ChangeNotifier {
  bool _isRustInitialized = false;
  String? _error;

  String? get error => _error;
  bool get isRustInitialized => _isRustInitialized;

  Future<void> initRust() async {
    _error = null;
    notifyListeners();

    try {
      if (!_isRustInitialized) {
        await RustLib.init();
        _isRustInitialized = true;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      notifyListeners();
    }
  }
}
