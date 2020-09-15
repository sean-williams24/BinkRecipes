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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

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
}
