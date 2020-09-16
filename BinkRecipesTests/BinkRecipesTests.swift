//
//  BinkRecipesTests.swift
//  BinkRecipesTests
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import XCTest
@testable import BinkRecipes

class BinkRecipesTests: XCTestCase {


    func testCategoryViewModel() {
        let category = Category(idCategory: "", strCategory: "BEEF", strCategoryThumb: "www.images.com/beef", strCategoryDescription: "")
        let categoryViewModel = CategoryViewModel(category: category)
        let attrCategory = NSMutableAttributedString(string: category.strCategory)
        attrCategory.addAttribute(NSAttributedString.Key.kern, value: CGFloat(5.0), range: NSRange(location: 0, length: attrCategory.length))
        
        XCTAssertEqual(attrCategory, categoryViewModel.title)
        XCTAssertEqual(category.strCategoryThumb, "www.images.com/beef")
        XCTAssertEqual(categoryViewModel.contentMode, UIImageView.ContentMode.scaleAspectFit)
    }


    func testMealViewModel() {
        let meal = Meal(strMeal: "Enchilladas", strMealThumb: "www.images.com/mexican", idMeal: "52940")
        let mealViewModel = MealViewModel(meal: meal)
        
        XCTAssertEqual(meal.strMeal, mealViewModel.mealTitle)
        XCTAssertEqual(meal.strMealThumb, mealViewModel.imageURLString)
        XCTAssertEqual(meal.idMeal, mealViewModel.id)
        XCTAssertEqual(meal.idMeal.count, 5)
    }
    
    
    func testRecipeViewModel() {
        let recipe = Recipe(idMeal: "56272",
                            strMeal: "Teriyaki Chicken Casserole",
                            strCategory: "Chicken",
                            strArea: "Japanese",
                            strInstructions: "",
                            strMealThumb: "",
                            strTags: "",
                            strYoutube: "https://www.youtube.com/watch?v=4aZr5hZXP_s",
                            strIngredient1: "soy sauce",
                            strIngredient2: nil,
                            strIngredient3: "",
                            strIngredient4: "",
                            strIngredient5: "",
                            strIngredient6: "",
                            strIngredient7: "",
                            strIngredient8: "",
                            strIngredient9: "",
                            strIngredient10: "",
                            strMeasure1: "3/4 cup",
                            strMeasure2: "",
                            strMeasure3: "",
                            strMeasure4: "",
                            strMeasure5: "",
                            strMeasure6: "",
                            strMeasure7: "",
                            strMeasure8: "",
                            strMeasure9: "",
                            strMeasure10: "")
        
        let viewModel = RecipeViewModel(recipe: recipe)
        
        XCTAssertEqual(recipe.strMeal.uppercased(), viewModel.title)
        XCTAssertEqual(recipe.strArea + " / " + recipe.strCategory, viewModel.category)
        XCTAssertEqual(String(recipe.strYoutube?.dropFirst(32) ?? ""), viewModel.youTubeID)
        XCTAssertEqual(viewModel.youTubeID.count, 11)
        
        let instructions = recipe.strInstructions + "\n\nCheck out the tutorial video below..."
        XCTAssertEqual(instructions, viewModel.instructions)
        
        let measure = recipe.strMeasure1!
        let ingredient = recipe.strIngredient1!
        let combined = "- \(measure) \(ingredient)\n"
        let ingredients = "Ingredients: \n\n\(combined)"
        XCTAssertEqual(ingredients, viewModel.ingredients)
    }
}
