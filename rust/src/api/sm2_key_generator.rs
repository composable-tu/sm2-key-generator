/**
 * Copyright (c) 2025 LuminaPJ
 * SM2 Key Generator is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan PSL v2.
 * You may obtain a copy of Mulan PSL v2 at:
 *          http://license.coscl.org.cn/MulanPSL2
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
 * EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
 * MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 * See the Mulan PSL v2 for more details.
 */

use base64::engine::general_purpose::STANDARD as Base64Engine;
use base64::engine::Engine as _;

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

pub fn gen_sm2_key() -> (String, String) {
    use libsm::sm2::signature::SigCtx;
    let ctx = SigCtx::new();
    let (pk, sk) = ctx.new_keypair().unwrap();
    let mut pubkey_bytes = [0u8; 65];
    pubkey_bytes[0] = 0x04;
    pubkey_bytes[1..33].copy_from_slice(&pk.x.to_bytes());
    pubkey_bytes[33..65].copy_from_slice(&pk.y.to_bytes());
    let prikey_bytes = sk.to_bytes_be();
    let pubkey_base64 = Base64Engine.encode(&pubkey_bytes);
    let prikey_base64 = Base64Engine.encode(&prikey_bytes);
    (pubkey_base64, prikey_base64)
}