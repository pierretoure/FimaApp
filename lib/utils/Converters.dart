import 'package:FimaApp/modals/Meal.dart';
import 'package:FimaApp/modals/ShoplistItem.dart';
import 'package:flutter/material.dart';

class MealConverter {
    static Meal parse(String meal) {
        return meal == 'LUNCH' 
        ? Meal.LUNCH
        : Meal.DINNER;
    }

    static String parseToString(Meal meal) {
        return meal.toString().split('.').last;
    }

    static String translateFR(Meal meal) {
        String translatedMeal;
        switch (meal) {
            case Meal.LUNCH:
                translatedMeal = 'midi';
                break;
            case Meal.DINNER:
                translatedMeal = 'soir';
                break;
            default:
                translatedMeal = '???';
                break;
        }
        return translatedMeal;
    }
}

class ShoplistItemConverter {
    static ShoplistItem parseAirtableRecord(dynamic record) => 
        ShoplistItem.fromJson({'id': record['id'], ...record['fields']});
}

class UserColorConverter {
    static String parseToString(String userColor) => userColor.replaceFirst(new RegExp(r'#'), '');
    static Color parse(String userColor) => Color(int.parse('0xff${parseToString(userColor)}'));
}