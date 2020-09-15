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

class MealsViewController: UIViewController, NSFetchedResultsControllerDelegate {

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Properties
    
    var category: String!
    var mealViewModels = [MealViewModel]()
    var id: String!
    var fetchedResultsController: NSFetchedResultsController<CoreDataRecipe>!
    var connected = true

    
    // MARK: - Life Cylce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButtonAttributes: [NSAttributedString.Key : Any] = [.font: UIFont(name: "Didot", size: 30) as Any]
        navigationController?.navigationBar.largeTitleTextAttributes = barButtonAttributes
        title = category
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.setupFetchedResultsController()
        
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.connected = true
                self.fetchMealsFromMealsDB()
            } else {
                // Fetch from Core Data
                self.connected = false
                DispatchQueue.main.async {
                    self.title = "Viewing History"
                }
            }
        }

        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    
    
    
    //MARK: - Helper Methods
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<CoreDataRecipe> = CoreDataRecipe.fetchRequest()
//        let predicate = NSPredicate(format: "venueName == %@", currentVenue.name)
//        fetchRequest.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //Instantiate fetched results controller
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: appDelegate.persistentContainer.viewContext , sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("The fetch could not be performed: \(error.localizedDescription)")
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
        vc.id = id
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
        
        let coreDataRecipe = fetchedResultsController.object(at: indexPath)
        let viewModel = MealViewModel(recipe: coreDataRecipe)
        
        cell.viewModel = connected ? mealViewModels[indexPath.row] : viewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        id = mealViewModels[indexPath.row].id
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    
}
