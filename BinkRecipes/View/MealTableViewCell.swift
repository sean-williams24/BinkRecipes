//
//  MealCollectionViewCell.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import SDWebImage
import UIKit

class MealTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealTitleLabel: UILabel!
    
    
    var viewModel: MealViewModel! {
        didSet {
            mealImageView.sd_setImage(with: URL(string: viewModel.imageURLString), placeholderImage: UIImage(named: "bink"))
            mealTitleLabel.text = viewModel.mealTitle
        }
    }
}
