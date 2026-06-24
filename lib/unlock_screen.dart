import 'package:flutter/material.dart';
import 'second_screen.dart';

/// A screen that demonstrates a constrained [Draggable] widget.
///
/// The user drags a circular handle along a horizontal track. Dragging is
/// constrained to the X axis using [Draggable.axis]. When the handle is
/// dragged far enough to the right (over the [DragTarget] at the end of
/// the track), the app navigates to [SecondScreen].
class UnlockScreen extends StatefulWidget {
  const UnlockScreen({super.key});

  @override
  State<UnlockScreen> createState() => _UnlockScreenState();
}

class _UnlockScreenState extends State<UnlockScreen> {
  /// Becomes true once the handle has been dropped on the target,
  /// used to play a brief "unlocked" confirmation before navigating.
  bool _isUnlocked = false;

  void _handleUnlock() {
    if (_isUnlocked) return;
    setState(() => _isUnlocked = true);

    // Small delay so the user sees the unlocked state before the
    // navigation transition starts.
    Future.delayed(const Duration(milliseconds: 350), () {
      if (!mounted) return;
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const SecondScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF101418),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 56,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Drag to Unlock',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Slide the handle to the right edge\nto continue to the next screen.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white60,
                  ),
                ),
                const SizedBox(height: 48),
                _SlideToUnlockTrack(
                  isUnlocked: _isUnlocked,
                  onUnlocked: _handleUnlock,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The visual track containing the draggable handle and the drop target.
///
/// This widget owns the layout math (track width, handle size) so that the
/// drag axis and target hit-testing stay correctly aligned regardless of
/// screen size.
class _SlideToUnlockTrack extends StatelessWidget {
  const _SlideToUnlockTrack({
    required this.isUnlocked,
    required this.onUnlocked,
  });

  final bool isUnlocked;
  final VoidCallback onUnlocked;

  static const double trackHeight = 64;
  static const double handleSize = 56;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: trackHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final trackWidth = constraints.maxWidth;

          return Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Background track.
              Container(
                width: trackWidth,
                height: trackHeight,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B2128),
                  borderRadius: BorderRadius.circular(trackHeight / 2),
                  border: Border.all(color: Colors.white12),
                ),
                alignment: Alignment.center,
                child: Text(
                  isUnlocked ? 'Unlocked!' : 'Slide to unlock',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.35),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              // The drop target lives at the right edge of the track. Its
              // width roughly matches the handle so a drop only counts once
              // the handle has travelled (almost) the full track length.
              Positioned(
                right: 0,
                child: DragTarget<String>(
                  onWillAcceptWithDetails: (_) => !isUnlocked,
                  onAcceptWithDetails: (_) => onUnlocked(),
                  builder: (context, candidateData, rejectedData) {
                    final isHovering = candidateData.isNotEmpty;
                    return Container(
                      width: handleSize + 16,
                      height: trackHeight,
                      alignment: Alignment.center,
                      child: Container(
                        width: handleSize - 8,
                        height: handleSize - 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isHovering
                              ? Colors.greenAccent.withOpacity(0.25)
                              : Colors.transparent,
                          border: Border.all(
                            color: isHovering
                                ? Colors.greenAccent
                                : Colors.white24,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.chevron_right,
                          color: isHovering ? Colors.greenAccent : Colors.white24,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // The draggable handle, constrained to the horizontal axis.
              // Feedback is the visual shown under the user's finger while
              // dragging; childWhenDragging hides the original in place.
              if (!isUnlocked)
                Draggable<String>(
                  data: 'unlock_handle',
                  axis: Axis.horizontal,
                  feedback: _Handle(dragging: true),
                  childWhenDragging: const SizedBox(
                    width: handleSize,
                    height: handleSize,
                  ),
                  child: const _Handle(dragging: false),
                )
              else
                const Positioned(
                  left: 0,
                  child: _Handle(dragging: false, unlocked: true),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// The circular handle the user drags. Rendered both as the resting
/// widget in the track and as the [Draggable.feedback] that follows
/// the user's finger.
class _Handle extends StatelessWidget {
  const _Handle({required this.dragging, this.unlocked = false});

  final bool dragging;
  final bool unlocked;

  static const double size = _SlideToUnlockTrack.handleSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: unlocked ? Colors.greenAccent : const Color(0xFF4F7CFF),
          boxShadow: [
            BoxShadow(
              color: (unlocked ? Colors.greenAccent : const Color(0xFF4F7CFF))
                  .withOpacity(dragging ? 0.5 : 0.3),
              blurRadius: dragging ? 16 : 8,
              spreadRadius: dragging ? 2 : 0,
            ),
          ],
        ),
        child: Icon(
          unlocked ? Icons.lock_open : Icons.drag_handle,
          color: Colors.white,
        ),
      ),
    );
  }
}
