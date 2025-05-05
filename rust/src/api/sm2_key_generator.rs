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
use num_bigint::BigUint;

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

/// 生成 SM2 密钥对，返回 Base64 编码的公钥和私钥。
///
/// 返回值：
/// - 第一个元素为公钥的 Base64 编码字符串（包含 0x04 前缀的 65 字节未压缩格式）
/// - 第二个元素为私钥的 Base64 编码字符串（32 字节大端格式）
pub fn gen_sm2_key() -> (String, String) {
    use libsm::sm2::signature::SigCtx;
    let ctx = SigCtx::new();
    let (pk, sk) = match ctx.new_keypair() {
        Ok(keys) => keys,
        Err(e) => return ("error".to_string(), e.to_string()),
    };
    let pubkey_bytes = match ctx.serialize_pubkey(&pk, false){
        Ok(pk) => pk,
        Err(e) => return ("error".to_string(), e.to_string()),
    };
    let prikey_bytes = match ctx.serialize_seckey(&sk){
        Ok(sk) => sk,
        Err(e) => return ("error".to_string(), e.to_string()),
    };
    let pubkey_base64 = Base64Engine.encode(&pubkey_bytes);
    let prikey_base64 = Base64Engine.encode(&prikey_bytes);
    (pubkey_base64, prikey_base64)
}

/// 根据私钥生成 SM2 公钥，返回 Base64 编码的公钥
pub fn sm2_pk_from_sk(sk_base64: String) -> String {
    use libsm::sm2::signature::SigCtx;
    let ctx = SigCtx::new();
    let sk_bytes = match Base64Engine.decode(&sk_base64) {
        Ok(sk) => sk,
        Err(e) => return e.to_string(),
    };
    if sk_bytes.len() != 32 {
        return "私钥长度不等于 32 字节".to_string();
    }
    let sk = match ctx.load_seckey(&sk_bytes){
        Ok(sk) => sk,
        Err(e) => return e.to_string(),
    };
    let pk = match ctx.pk_from_sk(&sk) {
        Ok(pk) => pk,
        Err(e) => return e.to_string(),
    };
    let pubkey_bytes = match ctx.serialize_pubkey(&pk, false){
        Ok(pk) => pk,
        Err(e) => return e.to_string(),
    };
    Base64Engine.encode(&pubkey_bytes)
}
