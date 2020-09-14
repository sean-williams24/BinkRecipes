//
//  ViewController.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import UIKit

class CategoriesViewController: UIViewController {

    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Properties
    
    var categoryViewModels = [CategoryViewModel]()
    let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    let itemsPerRow: CGFloat = 2.0
    
    // MARK: - Life Cycle

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
            guard let data = data else {
                print(error?.localizedDescription as Any)
                return
            }
            
            let decoder = JSONDecoder()
            if let mealDB = try? decoder.decode(MealDB.self, from: data) {
                
                let categories = mealDB.categories.sorted {$0.strCategory < $1.strCategory}
                
                self.categoryViewModels = categories.map({CategoryViewModel(category: $0)})
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
            
            
        }.resume()
    }

}


// MARK: - Extensions

extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categoryViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
        let category = categoryViewModels[indexPath.row]
        cell.viewModel = category
        
        return cell
        
    }
}


extension CategoriesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
