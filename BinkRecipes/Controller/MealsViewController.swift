//
//  MealsViewController.swift
//  BinkRecipes
//
//  Created by Sean Williams on 14/09/2020.
//  Copyright © 2020 Sean Williams. All rights reserved.
//

import CoreData
import Network
import UIKit

class MealsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    var category: String!
    var mealViewModels = [MealViewModel]()
    var id: String!
    var fetchedResultsController: NSFetchedResultsController<CoreDataRecipe>!
    var connected = true
    var recipeViewModel: RecipeViewModel!
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    // MARK: - Life Cylce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButtonAttributes: [NSAttributedString.Key : Any] = [.font: UIFont(name: "Didot", size: 30) as Any]
        navigationController?.navigationBar.largeTitleTextAttributes = barButtonAttributes
        title = category
        
        self.setupFetchedResultsController()
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.connected = true
                
                // If internet connection is re-established whilst viewing history - pop VC
                if self.category == nil {
                    DispatchQueue.main.async {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                } else {
                    self.fetchMealsFromMealsDB()
                }
            } else {
                // Fetch recipes from Core Data
                self.connected = false
                DispatchQueue.main.async {
                    self.showAlert(title: "Oops", message: "Your Internet connection seems to be down. You can see your viewing history until your connection is re-established.")
                    self.mealViewModels = []
                    self.category = nil
                    self.title = "Viewing History"
                    self.tableView.reloadData()
                }
            }
        }
        
        monitor.start(queue: queue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    
    //MARK: - Helper Methods
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<CoreDataRecipe> = CoreDataRecipe.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //Instantiate fetched results controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext , sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            self.showAlert(title: "Database Problem", message: "Sorry, we couldnt fetch your history at this time.")
        }
    }
    
    fileprivate func fetchMealsFromMealsDB() {
        let services = Services()
        services.fetchMealsFor(category: category) { [weak self] meals, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            self?.mealViewModels = meals
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MealDetailViewController
        
        if connected {
            vc.id = id
        } else {
            vc.connection = false
            vc.viewModel = recipeViewModel
        }
    }
}


// MARK: - TableView Delegates

extension MealsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if connected {
            return mealViewModels.count
        } else {
            return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealTableViewCell
        cell.selectionStyle = .none
        
        if connected {
            cell.viewModel = mealViewModels[indexPath.row]
        } else {
            let coreDataRecipe = fetchedResultsController.object(at: indexPath)
            let viewModel = MealViewModel(recipe: coreDataRecipe)
            cell.viewModel = viewModel
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if connected {
            id = mealViewModels[indexPath.row].id
        } else {
            let coreDataRecipe = fetchedResultsController.object(at: indexPath)
            let viewModel = RecipeViewModel(coreDataRecipe: coreDataRecipe)
            recipeViewModel = viewModel
        }
        
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if !connected {
            if editingStyle == .delete {
                let recipeToDelete = fetchedResultsController.object(at: indexPath)
                appDelegate.persistentContainer.viewContext.delete(recipeToDelete)
                appDelegate.saveContext()
            }
        }
    }
}

// MARK: Fetched results controller delegate

extension MealsViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            
        default:
            break
        }
    }
}
