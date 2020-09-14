//
//  RecipeViewModel.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Foundation

struct RecipeViewModel {
    
    public let title: String
    public let instructions: String
    public let imageURLString: String
    
    
    init(recipe: Recipe) {
        self.title = recipe.strMeal
        self.instructions = recipe.strInstructions
        self.imageURLString = recipe.strMealThumb
    }
    
}
