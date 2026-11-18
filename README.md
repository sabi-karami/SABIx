<div align="center">

# SABIx

**Freedom, quietly. — آزادی، بی‌صدا.**

A beautiful, ad-free, open-source VPN / anti-censorship client for Android.

</div>

## ✨ Features
- One-tap connection with built-in free **WARP** and **Psiphon** profiles — no server or configuration needed
- Supports VLESS, VMess, Trojan, Reality, Shadowsocks, Hysteria2, TUIC, WireGuard, SSH and more (powered by sing-box)
- All subscription formats (sing-box, V2Ray links, Clash / Clash Meta) with auto-update
- Automatic fastest-server selection
- **No ads.** This Android build has no Sentry destination configured. VPN endpoints and optional online features may have their own privacy policies.
- Dark "deep space" theme with the SABIx violet/aqua palette

## 📥 Download
Android releases are built and signed in GitHub Actions; every release links to the exact source revision. The APK is not an official Hiddify release. Runtime connectivity depends on the selected profile and network.
Get the latest APK from the [Releases page](https://github.com/sabi-karami/SABIx/releases).

## 🙏 Credits & License
SABIx is a customized fork of the excellent [Hiddify app](https://github.com/hiddify/hiddify-app),
built on [sing-box](https://github.com/SagerNet/sing-box) and [Xray-core](https://github.com/XTLS/Xray-core).
Huge thanks to the Hiddify team and contributors.

Licensed under the **Hiddify Extended GPLv3** — see [LICENSE.md](LICENSE.md).
This project is non-commercial, contains no ads, and all source changes are published here as required by the license.

### Changes from upstream (Hiddify)
- Rebranded to **SABIx**: new name, launcher icon, splash screen, in-app logo and color theme (violet `#8B5CF6` / aqua `#22D3EE` on deep-space `#0C0F22`)
- New application id `com.sabix.app` (installs alongside the original app)
- In-app links (GitHub, releases, issues, update checker) point to this repository
- No functional/core changes — connection engine and protocols are untouched upstream code
