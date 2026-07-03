import 'package:flutter/material.dart';

/// Centralized responsive breakpoints for phones, tablets, foldables & desktop.
class Breakpoints {
  Breakpoints._();

  static const double mobile = 600;
  static const double tablet = 1024;

  /// Max width for primary reading/form content on large screens.
  static const double contentMaxWidth = 640;

  /// Max width for wide dashboard-style content (grids, charts).
  static const double wideMaxWidth = 960;
}

extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < Breakpoints.mobile;
  bool get isTablet =>
      screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.tablet;
  bool get isDesktop => screenWidth >= Breakpoints.tablet;

  /// Horizontal page padding that scales with screen size.
  double get pagePadding => isMobile ? 20.0 : (isTablet ? 32.0 : 40.0);
}

/// Constrains content to a readable max width and centers it on large
/// screens, while remaining edge-to-edge on phones. Keeps phone-first
/// layouts from stretching across desktop viewports.
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = Breakpoints.contentMaxWidth,
    this.padding,
  });

  /// Wide variant for dashboard-style screens (charts, grids).
  const ResponsiveCenter.wide({
    super.key,
    required this.child,
    this.padding,
  }) : maxWidth = Breakpoints.wideMaxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null ? Padding(padding: padding!, child: child) : child,
      ),
    );
  }
}

/// SliverToBoxAdapter-free responsive wrapper for scroll views: use as the
/// `child` of a ListView/SingleChildScrollView body.
class ResponsiveScrollBody extends StatelessWidget {
  final List<Widget> children;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;

  const ResponsiveScrollBody({
    super.key,
    required this.children,
    this.maxWidth = Breakpoints.contentMaxWidth,
    this.padding,
    this.physics,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      physics: physics ?? const BouncingScrollPhysics(),
      padding: padding ??
          EdgeInsets.symmetric(horizontal: context.pagePadding, vertical: 8),
      child: ResponsiveCenter(
        maxWidth: maxWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}
