import 'package:FimaApp/widgets/FimaButtons/FimaButtons.dart';
import 'package:FimaApp/widgets/MeasureSize/MeasureSize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FimaBottomSheet extends HookWidget {
    const FimaBottomSheet({
        Key key,
        @required this.title,
        @required this.content,
        this.actions,
        this.cancelButtonTitle = 'Annuler',
        this.validButtonTitle = 'Valider',
        this.onValidButtonPressed,
        this.onValidButtonPressedAsync,
        this.onCancelButtonPressed,
        this.onCancelButtonPressedAsync,
    }) : super(key: key);

    final String title;
    final Widget content;
    final List<Widget> actions;
    final String cancelButtonTitle;
    final String validButtonTitle;
    final void Function() onValidButtonPressed;
    final Future<void> Function() onValidButtonPressedAsync;
    final void Function() onCancelButtonPressed;
    final Future<void> Function() onCancelButtonPressedAsync;

    @override
    Widget build(BuildContext context) {
        final isValidatingController = useState<bool>(false);
        final contentHeightController = useState<double>(double.maxFinite);
        
        return Container(
            child: Column(
                children: [
                    buildTitle(title),
                    MeasureSize(
                        child: content,
                        onChange: (size) => contentHeightController.value = size.height,
                    ),
                    buildActions(
                        context: context, 
                        actions: actions, 
                        isValidatingController: isValidatingController,
                    )],
                crossAxisAlignment: CrossAxisAlignment.start,
            ),
            height: 140 + contentHeightController.value,// 340,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
        );
    }

    Widget buildTitle(String title) {
        return Padding(
            child: Text(
                title,
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.grey[700],
                ),
            ),
            padding: const EdgeInsets.all(16),
        );
    }

    Widget buildActions({
        @required BuildContext context, 
        @required List<Widget> actions, 
        @required ValueNotifier<bool> isValidatingController
    }) {
        return Container(
            child: Row(
                children: [
                    isValidatingController.value 
                        ? Container()
                        : FimaFlatButton(
                            title: 'Annuler',
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                    isValidatingController.value
                        ? CircularProgressIndicator()
                        : FimaFlatButton(
                            title: 'Sauvegarder',
                            isActive: true,
                            onPressed: () async {
                                isValidatingController.value = true;
                                if (onValidButtonPressed != null ) 
                                    onValidButtonPressed();
                                if (onValidButtonPressedAsync != null ) 
                                    await onValidButtonPressedAsync();
                                Navigator.of(context).pop();
                            },
                        ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
            ),
            height: 70,
            padding: EdgeInsets.all(16),
        );
    }
}
