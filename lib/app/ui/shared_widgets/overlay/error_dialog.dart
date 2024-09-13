part of 'overlay.dart';

class _ErrorDialog extends StatelessWidget {
  final String error;
  final Function onPressedOkayButton;

  const _ErrorDialog({
    required this.error,
    required this.onPressedOkayButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // checkmark
        Image.asset(
          "assets/images/error.png",
          height: 72,
          width: 72,
          fit: BoxFit.cover,
        ),
        const SizedBox(height: 30),

        // body
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            error,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        const SizedBox(height: 50),

        // okay button
        ElevatedButton(
            onPressed: () => onPressedOkayButton(), child: const Text("Okay"))
      ],
    );
  }
}
