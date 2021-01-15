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
                : FlatButton(
                    child: Text(
                        cancelButtonTitle,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 18,
                        ),
                    ),
                    onPressed: () async {
                        if(onCancelButtonPressed != null) onCancelButtonPressed();
                        if(onCancelButtonPressedAsync != null) await onCancelButtonPressedAsync();
                        Navigator.of(context).pop();
                    },
                ),
                isValidatingController.value
                ? CircularProgressIndicator()
                : FlatButton(
                    child: Text(
                        validButtonTitle,
                        style: TextStyle(
                            fontSize: 18,
                        ),
                    ),
                    onPressed: () async {
                        if(onValidButtonPressed != null) onValidButtonPressed();
                        if(onValidButtonPressedAsync != null) {
                            isValidatingController.value = true;
                            await onValidButtonPressedAsync();
                        }
                        Navigator.of(context).pop();
                    },
                ),
            ],
            
        );
    }
}