//
//  RecipeViewModel.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import UIKit

struct RecipeViewModel {
    
    public let title: String
    public let instructions: String
    public var image: UIImage?
    public let ingredients: String
    public let youTubeID: String
    
    
    init(recipe: Recipe) {
        self.title = recipe.strMeal
        self.instructions = recipe.strInstructions
        
        if let url = URL(string: recipe.strMealThumb) {
            if let imgData = try? Data(contentsOf: url) {
                if let img = UIImage(data: imgData) {
                    self.image = img
                }
            }
        }
        
        self.youTubeID = String(recipe.strYouTube?.dropFirst(32) ?? "")
        
        self.ingredients = recipe.strIngredient1!
    }
    
}
