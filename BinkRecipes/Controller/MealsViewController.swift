//
//  MealsViewController.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import UIKit

class MealsViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    var category: String!
    var mealViewModels = [MealViewModel]()
    var id: String!
    
    // MARK: - Life Cylce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let services = Services()
        services.fetchMealsFor(category: category) { meals, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            self.mealViewModels = meals
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MealDetailViewController
        vc.id = id
    }

}


// MARK: - TableView Delegates

extension MealsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mealViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealTableViewCell
        cell.viewModel = mealViewModels[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        id = mealViewModels[indexPath.row].id
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    
}
