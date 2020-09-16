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
    public var ingredients: String = "Ingredients: \n\n"
    public let youTubeID: String
    public let category: String
    
    
    init(recipe: Recipe) {
        self.title = recipe.strMeal.uppercased()
        self.instructions = recipe.strInstructions + "\n\nCheck out the tutorial video below..."
        self.category = recipe.strArea + " / " + recipe.strCategory
        self.youTubeID = String(recipe.strYoutube?.dropFirst(32) ?? "")
        
        if let url = URL(string: recipe.strMealThumb) {
            if let imgData = try? Data(contentsOf: url) {
                if let img = UIImage(data: imgData) {
                    self.image = img
                }
            }
        }
        
        if let ingredient = recipe.strIngredient1 {
            if let measure = recipe.strMeasure1 {
                self.ingredients.append("- " + measure + " " + ingredient + "\n")
            }
        }

        if let ingredient = recipe.strIngredient2 {
            if let measure = recipe.strMeasure2 {
                if ingredient != "" {
                    self.ingredients.append("- " + measure + " " + ingredient + "\n")
                }
            }
        }
        
        if let ingredient = recipe.strIngredient3 {
            if let measure = recipe.strMeasure3 {
                if ingredient != "" {
                    self.ingredients.append("- " + measure + " " + ingredient + "\n")
                }
            }
        }
        
        if let ingredient = recipe.strIngredient4 {
            if let measure = recipe.strMeasure4 {
                if ingredient != "" {
                    self.ingredients.append("- " + measure + " " + ingredient + "\n")
                }
            }
        }

        if let ingredient = recipe.strIngredient5 {
            if let measure = recipe.strMeasure5 {
                if ingredient != "" {
                    self.ingredients.append("- " + measure + " " + ingredient + "\n")
                }
            }
        }
        
        if let ingredient = recipe.strIngredient6 {
            if let measure = recipe.strMeasure6 {
                if ingredient != "" {
                    self.ingredients.append("- " + measure + " " + ingredient + "\n")
                }
            }
        }

        if let ingredient = recipe.strIngredient7 {
            if let measure = recipe.strMeasure7 {
                if ingredient != "" {
                    self.ingredients.append("- " + measure + " " + ingredient + "\n")
                }
            }
        }

        if let ingredient = recipe.strIngredient8 {
            if let measure = recipe.strMeasure8 {
                if ingredient != "" {
                    self.ingredients.append("- " + measure + " " + ingredient + "\n")
                }
            }
        }
        
        if let ingredient = recipe.strIngredient9 {
            if let measure = recipe.strMeasure9 {
                if ingredient != "" {
                    self.ingredients.append("- " + measure + " " + ingredient + "\n")
                }
            }
        }
        
        if let ingredient = recipe.strIngredient10 {
            if let measure = recipe.strMeasure10 {
                if ingredient != "" {
                    self.ingredients.append("- " + measure + " " + ingredient + "\n")
                }
            }
        }
    }
    
    
    init(coreDataRecipe: CoreDataRecipe) {
        self.title = coreDataRecipe.title ?? ""
        self.instructions = String(coreDataRecipe.instructions?.dropLast(39) ?? "")
        self.category = coreDataRecipe.category ?? ""
        self.youTubeID = coreDataRecipe.youTubeID ?? ""
        self.ingredients = coreDataRecipe.ingredients ?? ""
        
        if let imgData = coreDataRecipe.image {
            if let img = UIImage(data: imgData) {
                self.image = img
            }
        }
        
    }
    
}
