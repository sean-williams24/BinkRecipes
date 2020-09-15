//
//  MealDetailViewController.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

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
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let services = Services()
        services.fetchMealDetailsFor(id: id) { viewModel, error in
            guard let viewModel = viewModel else {
                print(error?.localizedDescription as Any)
                return
            }
            
            DispatchQueue.main.async {
                self.titleLabel.text = viewModel.title
                self.instructionsLabel.text = viewModel.instructions
                self.imageView.image = viewModel.image
                self.youTubeView.load(withVideoId: viewModel.youTubeID)
                self.categoryLabel.text = viewModel.category
                self.ingredientsLabel.text = viewModel.ingredients
            }
            
        }
    }
    
    

    
    
}
