//
//  MealViewModel.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Foundation
import UIKit

struct MealViewModel {
    
    // MARK: - Instance Properties

    public let mealTitle: String
    public let imageURLString: String
    public let id: String
    public var image: UIImage?
    
    
    // MARK: - Initializers

    public init (meal: Meal) {
        self.mealTitle = meal.strMeal
        self.imageURLString = meal.strMealThumb
        self.id = meal.idMeal
    }
}

extension MealViewModel {
    init(recipe: CoreDataRecipe) {
        mealTitle = recipe.title ?? ""
        imageURLString = ""
        id = recipe.id ?? ""
        
        if let coreDataImg = recipe.image {
            if let img = UIImage(data: coreDataImg) {
                self.image = img
            }
        }
    }
}
