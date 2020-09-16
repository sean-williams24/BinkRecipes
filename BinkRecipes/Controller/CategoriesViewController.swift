//
//  ViewController.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import Network
import UIKit

class CategoriesViewController: UIViewController {

    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    
    
    // MARK: - Properties
    
    var categoryViewModels = [CategoryViewModel]()
    let sectionInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
    var itemsPerRow: CGFloat = 2.0
    var category: String!
    let titleMinHeight: CGFloat = 0.0
    var titleViewMaxHeight: CGFloat = 100
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")

    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // Connected
                self.itemsPerRow = 2.0
                let services = Services()
                services.fetchCategories { [weak self] categories, error in
                    guard error == nil else {
                        print(error?.localizedDescription as Any)
                        return
                    }
                    
                    self?.categoryViewModels = categories
                    
                    DispatchQueue.main.async {
                         self?.collectionView.reloadData()
                     }
                }
            } else {
                // Disconnnected
                self.categoryViewModels = []
                self.itemsPerRow = 1.0
                
                let noConnectionCategory = Category(idCategory: "0", strCategory: "View Previously Viewed Recipes", strCategoryThumb: "", strCategoryDescription: "")
                let noConnectionViewModel = CategoryViewModel(category: noConnectionCategory)
                self.categoryViewModels.append(noConnectionViewModel)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }

        monitor.start(queue: queue)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MealsViewController
        vc.category = category
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let attrCategory = categoryViewModels[indexPath.row].title
        category = attrCategory.string
        performSegue(withIdentifier: "showMeals", sender: self)
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


// MARK: - Scroll View Delegates

extension CategoriesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let newTitleHeight = titleHeightConstraint.constant - contentOffsetY
        
        if newTitleHeight < titleMinHeight {
            titleHeightConstraint.constant = titleMinHeight
        } else if newTitleHeight > titleViewMaxHeight {
            titleHeightConstraint.constant = titleViewMaxHeight
        } else {
            titleHeightConstraint.constant = titleHeightConstraint.constant - contentOffsetY
            scrollView.contentOffset.y = 0.0
        }
    }
}
