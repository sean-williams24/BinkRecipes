//
//  UIViewControllerExtension .swift
//  BinkRecipes
//
//  Created by Sean Williams on 16/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: - Universal Alert Controller
     
     func showAlert(title: String, message: String?) {
         DispatchQueue.main.async {
             let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
             ac.addAction(UIAlertAction(title: "OK", style: .default))
             self.present(ac, animated: true)
         }
     }
}
