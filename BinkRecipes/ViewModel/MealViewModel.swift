//
//  MealViewModel.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Foundation

struct MealViewModel {
    
    public let mealTitle: String
    public let imageURLString: String
    
    public init (meal: Meal) {
        self.mealTitle = meal.strMeal
        self.imageURLString = meal.strMealThumb
    }
}
