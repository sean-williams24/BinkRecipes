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
    
    var category: Category! {
        didSet {
            textLabel.text = category.strCategory.uppercased()
            imageView.sd_setImage(with: URL(string: category.strCategoryThumb), placeholderImage: UIImage(named: "bink"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        letterSpacing(label: textLabel, value: 5.0)
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.6
        layer.cornerRadius = 3
        
    }
    
    func letterSpacing(label: UILabel, value: Double) {
        let attributedString = NSMutableAttributedString(string: label.text!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(value), range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
    }
}
