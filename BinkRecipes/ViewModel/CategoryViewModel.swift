//
//  CategoryViewModel.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Foundation
import SDWebImage
import UIKit

struct CategoryViewModel {
    
    // MARK: - Instance Properties

    public let title: NSAttributedString
    public let imageURLString: String
    public let contentMode: UIImageView.ContentMode
    
    
    // MARK: - Object Lifecycle

    public init (category: Category) {
        let attributedString = NSMutableAttributedString(string: category.strCategory.uppercased())
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(5.0), range: NSRange(location: 0, length: attributedString.length))
        
        self.title = attributedString
        self.imageURLString = category.strCategoryThumb
        
        if attributedString.string == "GOAT" || attributedString.string == "BREAKFAST" {
            contentMode = .scaleAspectFill
        } else {
            contentMode = .scaleAspectFit
        }
    }
}
