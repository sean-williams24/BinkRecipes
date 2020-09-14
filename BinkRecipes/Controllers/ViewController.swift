//
//  ViewController.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        
        URLSession.shared.dataTask(with: Endpoints.listAllCategories.url) { (data, response, error) in
            guard data == data else {
                print(error?.localizedDescription as Any)
                return
            }
            
            
            
        }.resume()
    }


}

