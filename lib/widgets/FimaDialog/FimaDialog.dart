import 'package:FimaApp/widgets/FimaButtons/FimaButtons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FimaDialog extends HookWidget {
    const FimaDialog({
        this.title,
        this.content,
        this.onValidButtonPressed,
        this.onValidButtonPressedAsync,
        this.onCancelButtonPressed,
        this.onCancelButtonPressedAsync,
        this.cancelButtonTitle = 'Annuler',
        this.validButtonTitle = 'Valider',
    });

    final String title;
    final Widget content;
    final String cancelButtonTitle;
    final String validButtonTitle;
    final void Function() onValidButtonPressed;
    final Future<void> Function() onValidButtonPressedAsync;
    final void Function() onCancelButtonPressed;
    final Future<void> Function() onCancelButtonPressedAsync;

    @override
    Widget build(BuildContext context) {
        final isValidatingController = useState<bool>(false);

        return AlertDialog(
            title: Text(
                title,
                style: TextStyle(
                    color: Colors.grey[700]
                ),
            ),
            content: content,
            actions: [
                isValidatingController.value 
                ? Container()
                : FimaFlatButton(
                    title: cancelButtonTitle,
                    onPressed: () async {
                        if(onCancelButtonPressed != null) onCancelButtonPressed();
                        if(onCancelButtonPressedAsync != null) await onCancelButtonPressedAsync();
                        Navigator.of(context).pop();
                    },
                ),
                isValidatingController.value
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                )
                : FimaFlatButton(
                    title: validButtonTitle,
                    isActive: true,
                    onPressed: () async {
                        isValidatingController.value = true;
                        if(onValidButtonPressed != null) onValidButtonPressed();
                        if(onValidButtonPressedAsync != null) {
                            await onValidButtonPressedAsync();
                        }
                        Navigator.of(context).pop();
                    },
                ),
            ],
            
        );
    }
}