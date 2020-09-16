//
//  MealDetailViewController.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import CoreData
import UIKit
import YoutubePlayer_in_WKWebView

class MealDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var youTubeView: WKYTPlayerView!
    
    
    // MARK: - Properties
    
    var id: String!
    let titleMinHeight: CGFloat = 0.0
    var titleViewMaxHeight: CGFloat = 300
    var connection = true
    var viewModel: RecipeViewModel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false

        if connection {
            configureForMealDB()
        } else {
            
            // Load from Core Data
            
            self.titleLabel.text = viewModel.title
            self.instructionsLabel.text = viewModel.instructions
            self.imageView.image = viewModel.image
            self.categoryLabel.text = viewModel.category
            self.ingredientsLabel.text = viewModel.ingredients
            youTubeView.isHidden = true
            
        }
    }
    
    // MARK: - Helper Methods
    
    fileprivate func configureForMealDB() {
        let services = Services()
        services.fetchMealDetailsFor(id: id) { [weak self] viewModel, error in
            guard let viewModel = viewModel else {
                print(error?.localizedDescription as Any)
                return
            }
            
            DispatchQueue.main.async {
                self?.titleLabel.text = viewModel.title
                self?.instructionsLabel.text = viewModel.instructions
                self?.imageView.image = viewModel.image
                self?.youTubeView.load(withVideoId: viewModel.youTubeID)
                self?.categoryLabel.text = viewModel.category
                self?.ingredientsLabel.text = viewModel.ingredients
                
                // Persist recipe to Core Data
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let coreDataRecipe = CoreDataRecipe(context: appDelegate.persistentContainer.viewContext)
                coreDataRecipe.title = viewModel.title
                coreDataRecipe.instructions = viewModel.instructions
                coreDataRecipe.youTubeID = viewModel.youTubeID
                coreDataRecipe.category = viewModel.category
                coreDataRecipe.ingredients = viewModel.ingredients
                coreDataRecipe.id = self?.id
                coreDataRecipe.date = Date()
                coreDataRecipe.image = viewModel.image?.pngData()
                appDelegate.saveContext()
            }
        }
    }
    
    
}

// MARK: - Scroll View Delegates

extension MealDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let newTitleHeight = imageViewHeightConstraint.constant - contentOffsetY
 
        if newTitleHeight < titleMinHeight {
            imageViewHeightConstraint.constant = titleMinHeight
        } else if newTitleHeight > titleViewMaxHeight {
            imageViewHeightConstraint.constant = titleViewMaxHeight
        } else {
            imageViewHeightConstraint.constant = imageViewHeightConstraint.constant - contentOffsetY
            scrollView.contentOffset.y = 0.0
        }
    }
}
