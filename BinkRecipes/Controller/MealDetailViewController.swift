//
//  MealDetailViewController.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import UIKit

class MealDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    
    // MARK: - Properties
    
    var id: String!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let services = Services()
        services.fetchMealDetailsFor(id: id) { recipe, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            print(recipe?.title as Any)
        }
    }
    
    

    
    
}
