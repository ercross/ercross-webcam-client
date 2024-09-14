part of '../home.dart';

class _PowerSwitchButton extends StatefulWidget {
  final WebRTCConnectionState state;

  final Function() onPressed;

  /// size of [_PowerSwitchButton].
  final double size;

  /// The stroke width of the dashed border.
  final double strokeWidth;

  /// The width of each dash in the dashed border.
  final double dashWidth;

  /// The space between each dash in the dashed border.
  final double dashSpace;

  /// The background color of the switch.
  final Color backgroundColor;

  /// The color of the power icon.
  final Color iconColor;

  /// The label text to display inside the switch.
  final String? label;

  /// The gradient colors for the 'on' state.
  final Gradient onStateGradient;

  /// The gradient colors for the 'off' state.
  final Gradient offStateGradient;

  /// The duration of the toggle animation.
  final Duration animationDuration;

  /// The curve of the toggle animation.
  final Curve animationCurve;

  /// Creates a PowerSwitchButton widget.
  const _PowerSwitchButton({
    required this.size,
    this.strokeWidth = 9.0,
    this.dashWidth = 1.0,
    this.dashSpace = 2.0,
    required this.backgroundColor,
    required this.iconColor,
    required this.onPressed,
    required this.state,
    this.label,
    this.onStateGradient = const LinearGradient(
      colors: [Colors.green, Colors.lightGreen],
    ),
    this.offStateGradient = const LinearGradient(
      colors: [Colors.red, Colors.orange],
    ),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  _PowerSwitchButtonState createState() => _PowerSwitchButtonState();
}

class _PowerSwitchButtonState extends State<_PowerSwitchButton>
    with TickerProviderStateMixin {
  bool isLoading = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    /// Initialize the scale controller and animation for button press effect
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    if (widget.state == WebRTCConnectionState.connecting ||
        widget.state == WebRTCConnectionState.disconnecting) {
      _controller.repeat(reverse: true);
    }
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: widget.animationCurve),
    );

    /// Initialize the rotation controller and animation for loading state
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeOutCirc),
    );
  }

  @override
  Widget build(BuildContext context) {
    final outerCircleSize = widget.size;
    final middleCircleSize = widget.size * 0.8;
    final innerCircleSize = widget.size * 0.6;

    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// Outer circle or square with background color
          Container(
            width: outerCircleSize,
            height: outerCircleSize,
            decoration: BoxDecoration(
                color: widget.backgroundColor, shape: BoxShape.circle),
          ),

          isLoading
              // paint a rotating loading animation of button
              ? RotationTransition(
                  turns: _rotationAnimation,
                  child: CustomPaint(
                    size: Size(middleCircleSize, middleCircleSize),
                    painter: DashedCirclePainter(
                      strokeWidth: widget.strokeWidth,
                      dashWidth: widget.dashWidth,
                      dashSpace: widget.dashSpace,
                      strokeColor:
                          widget.state == WebRTCConnectionState.connected
                              ? widget.onStateGradient.colors[0]
                              : widget.offStateGradient.colors[0],
                    ),
                  ),
                )

              // paint a static button
              : CustomPaint(
                  size: Size(middleCircleSize, middleCircleSize),
                  painter: DashedCirclePainter(
                    strokeWidth: widget.strokeWidth,
                    dashWidth: widget.dashWidth,
                    dashSpace: widget.dashSpace,
                    strokeColor: widget.state == WebRTCConnectionState.connected
                        ? widget.onStateGradient.colors[0]
                        : widget.offStateGradient.colors[0],
                  ),
                ),

          /// Inner circle or square with icon and label
          ScaleTransition(
            scale: _scaleAnimation,
            child: AnimatedContainer(
              duration: widget.animationDuration,
              width: innerCircleSize,
              height: innerCircleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: widget.state == WebRTCConnectionState.connected
                    ? widget.onStateGradient
                    : widget.offStateGradient,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.power_settings_new,
                      size: innerCircleSize * 0.5,
                      color: widget.iconColor,
                    ),
                    if (widget.label != null)
                      Text(
                        widget.label!,
                        style: TextStyle(
                          color: widget.iconColor,
                          fontSize: innerCircleSize * 0.1,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}
