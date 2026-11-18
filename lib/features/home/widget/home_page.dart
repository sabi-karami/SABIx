import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hiddify/core/app_info/app_info_provider.dart';
import 'package:hiddify/core/localization/translations.dart';
import 'package:hiddify/core/model/constants.dart';
import 'package:hiddify/core/router/bottom_sheets/bottom_sheets_notifier.dart';
import 'package:hiddify/features/home/widget/connection_button.dart';
import 'package:hiddify/features/home/widget/local_proxy_hint.dart';
import 'package:hiddify/features/profile/notifier/active_profile_notifier.dart';
import 'package:hiddify/features/profile/widget/profile_tile.dart';
import 'package:hiddify/features/proxy/active/active_proxy_card.dart';
import 'package:hiddify/features/proxy/active/active_proxy_delay_indicator.dart';
import 'package:hiddify/gen/assets.gen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final t = ref.watch(translationsProvider).requireValue;
    // final hasAnyProfile = ref.watch(hasAnyProfileProvider);
    final activeProfile = ref.watch(activeProfileProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            SizedBox.square(
              dimension: 34,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: dark ? const Color(0xFF171C38) : const Color(0xFF23184A),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Center(child: Assets.images.logo.svg(height: 26, width: 26)),
              ),
            ),
            const Gap(10),
            Flexible(
              child: Text(
                Constants.appName,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 2),
              ),
            ),
          ],
        ),
        actions: [
          Semantics(
            key: const ValueKey("profile_add_button"),
            label: t.pages.profiles.add,
            child: IconButton(
              tooltip: t.pages.profiles.add,
              icon: Icon(Icons.add_rounded, color: colors.primary),
              onPressed: () => ref.read(bottomSheetsNotifierProvider.notifier).showAddProfile(),
            ),
          ),
          const Gap(8),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Positioned.fill(
            child: IgnorePointer(child: RepaintBoundary(child: _SabixBackdrop())),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 600, // Set the maximum width here
                  ),
                  // The page does not move under the finger: no bounce (iOS) or stretch (Android) when it
                  // fits the screen. It still scrolls, without them, when it does not (a small screen or a
                  // large font).
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
                    child: CustomScrollView(
                      physics: const ClampingScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            children: [
                              const Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [ConnectionButton(), ActiveProxyDelayIndicator()],
                                  ),
                                ),
                              ),
                              if (activeProfile case AsyncData(value: final profile?))
                                ProfileTile(
                                  profile: profile,
                                  isMain: true,
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                ),
                              const ActiveProxyFooter(),
                              const Gap(32),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (ref.watch(hasAnyProfileProvider).value ?? false)
                Positioned(
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // tabs of either height stand on the bottom edge
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // in proxy mode, a smaller tab beside this one on how to point apps at the proxy
                      const Flexible(child: LocalProxyHint()),
                      Material(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          onTap: () => ref.read(bottomSheetsNotifierProvider.notifier).showQuickSettings(),
                          child: Container(
                            height: 32,
                            padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(t.pages.home.quickSettings),
                                const Gap(4),
                                const Icon(Icons.arrow_drop_up_rounded, size: 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SabixBackdrop extends StatelessWidget {
  const _SabixBackdrop();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(-.16, -.22),
          radius: .92,
          colors: [
            dark ? const Color(0xFF32315C) : const Color(0xFFEDE9FF),
            dark ? const Color(0xFF161C35) : const Color(0xFFF4F1FC),
            theme.scaffoldBackgroundColor,
          ],
          stops: const [0, .45, 1],
        ),
      ),
      child: CustomPaint(painter: _SabixChart(dark: dark)),
    );
  }
}

/// Static navigation marks; this layer does not participate in taps or button animation.
class _SabixChart extends CustomPainter {
  const _SabixChart({required this.dark});
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final horizon = Offset(size.width * .5, size.height * .4);
    final span = size.shortestSide;
    final brush = Paint()
      ..color = dark ? const Color(0x239DB1E9) : const Color(0x1F514581)
      ..style = PaintingStyle.stroke
      ..strokeWidth = .8;
    canvas.save();
    canvas.translate(horizon.dx, horizon.dy);
    canvas.rotate(-.34);
    for (final scale in const [.64, .85, 1.08]) {
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: span * scale, height: span * scale * .44), brush);
    }
    final point = Paint()..color = dark ? const Color(0x8F5EEAD4) : const Color(0x7D0F766E);
    canvas.drawCircle(Offset(span * .36, -span * .098), 2.5, point);
    canvas.drawCircle(Offset(-span * .27, span * .078), 1.5, point);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SabixChart oldDelegate) => oldDelegate.dark != dark;
}

class AppVersionLabel extends HookConsumerWidget {
  const AppVersionLabel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider).requireValue;
    final theme = Theme.of(context);

    final version = ref.watch(appInfoProvider).requireValue.presentVersion;
    if (version.isBlank) return const SizedBox();

    return Semantics(
      label: t.common.version,
      button: false,
      child: Container(
        decoration: BoxDecoration(color: theme.colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        child: Text(
          version,
          textDirection: TextDirection.ltr,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSecondaryContainer),
        ),
      ),
    );
  }
}
