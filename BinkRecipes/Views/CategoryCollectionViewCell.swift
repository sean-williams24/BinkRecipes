//
//  CategoryCollectionViewCell.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import SDWebImage
import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    var viewModel: CategoryViewModel! {
        didSet {
            textLabel.attributedText = viewModel.title
            imageView.sd_setImage(with: URL(string: viewModel.imageURLString), placeholderImage: UIImage(named: "bink"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.6
        layer.cornerRadius = 3
        
    }
    

}
