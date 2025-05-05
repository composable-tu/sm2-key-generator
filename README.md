# China's ShangMi SM2 Key Pair Generator

中国商密 SM2 密钥对随机生成器

## 使用须知

该项目暂仅支持 Windows 10+ x64 端和 Linux Desktop x64 端运行，其中 Linux 端需要 GLib 版本 ≥ 2.80.0。

由于需要初始化原生库，首次生成密钥对的等候时间会稍长。

默认情况下由此程序生成的 SM2 密钥对中，公钥为 65 字节，私钥为 32 字节，RAW 未压缩格式，经过 Base64 编码为字符串。

该项目隶属于琳琅问，用于为琳琅问服务端部署者提供 SM2 密钥对生成服务。

## 开发须知

该项目为 Flutter + Rust 混合开发项目，Flutter 部分承载整体应用框架，Rust 部分承载 SM2 密钥对生成逻辑与基于已知 SM2 私钥推导出公钥逻辑。

如需对该项目进行开发，需在本地配置 Flutter 和 Rust 开发环境。敬请参阅：

- [Flutter 开发环境配置文档](https://docs.flutter.dev/get-started/install)（对于中国大陆网络环境，请前往[此文档](https://docs.flutter.cn/get-started/install)）
- [Rust 与 Cargo 开发环境配置文档](https://www.rust-lang.org/zh-CN/tools/install)

此外，根据您所运行的桌面平台，您可能还需要安装对应平台的依赖库。您可以在 Flutter 开发环境安装完毕后，在项目根目录运行 `flutter doctor` 以查看详情。

配置完成后，运行以下命令以启动项目：

```shell
cargo install flutter_rust_bridge_codegen
```

```shell
flutter pub get
```

```shell
flutter_rust_bridge_codegen generate
```

```shell
flutter run
```

由于 Rust 代码经过 [Flutter/Dart <-> Rust 绑定生成器](https://cjycode.com/flutter_rust_bridge/)生成绑定代码，因此在每次改动 Rust 代码之后，请运行以下命令以重新生成绑定代码：

```shell
flutter_rust_bridge_codegen generate
```
