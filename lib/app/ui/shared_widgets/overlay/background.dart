part of 'overlay.dart';

class _OverlayBackground extends StatelessWidget {
  final Widget child;
  final bool absorbPointer;
  const _OverlayBackground({required this.absorbPointer, required this.child});

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: absorbPointer,
      child: Material(
        color: Colors.black12,
        elevation: 8,
        child: Center(child: child),
      ),
    );
  }
}

class _OverlayDialogShape extends StatelessWidget {
  final Widget child;
  const _OverlayDialogShape({required this.child});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Center(
      child: IntrinsicHeight(
        child: Container(
          width: width,
          margin: EdgeInsets.symmetric(horizontal: width * 0.1),
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(17, 20, 17, 12),
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color:
                  Color.fromARGB(255, 240, 244, 248), // Slightly white shadow
              blurRadius: 5.0,
              spreadRadius: 1.0,
              offset: Offset(-1, 1), // changes position of shadow
            ),
          ], color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: child,
        ),
      ),
    );
  }
}
