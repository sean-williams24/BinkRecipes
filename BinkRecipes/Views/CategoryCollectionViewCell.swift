//
//  CategoryCollectionViewCell.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    var category: Category! {
        didSet {
            textLabel.text = category.strCategory
            imageView.image = UIImage()
        }
    }
    
}
