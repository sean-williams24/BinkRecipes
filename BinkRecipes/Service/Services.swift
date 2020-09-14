//
//  Services.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Foundation

class Services {
    
    enum Endpoints {
        
        static let baseURL = "https://www.themealdb.com/api/json/v1/1/"
        
        case listAllCategories
        case categoryFilter
        case recipeDetails
        
        var stringValue: String {
            switch self {
            case .listAllCategories: return Endpoints.baseURL + "categories.php"
            case .categoryFilter: return Endpoints.baseURL + "filter.php?c="
            case .recipeDetails: return Endpoints.baseURL + "lookup.php?i="
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    func fetchCategories(completion: @escaping([CategoryViewModel], Error?)->()) {
        URLSession.shared.dataTask(with: Endpoints.listAllCategories.url) { (data, response, error) in
            guard let data = data else {
                completion([], error)
                return
            }
            
            let decoder = JSONDecoder()
            if let mealDB = try? decoder.decode(MealDB.self, from: data) {
                
                let categories = mealDB.categories.sorted {$0.strCategory < $1.strCategory}
                
                let categoryViewModels = categories.map({CategoryViewModel(category: $0)})
                completion(categoryViewModels, nil)
            }
        }.resume()
    }
}
