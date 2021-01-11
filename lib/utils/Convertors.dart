import 'package:FimaApp/modals/Meal.dart';

class MealConvertor {
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