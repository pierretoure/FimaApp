import 'dart:convert';

import 'package:FimaApp/modals/Meal.dart';
import 'package:FimaApp/modals/ShoplistItem.dart';

class MealConverter {
    static Meal parse(String meal) {
        return meal == 'LUNCH' 
        ? Meal.LUNCH
        : Meal.DINNER;
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
