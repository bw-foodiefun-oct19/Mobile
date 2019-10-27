//
//  ExperiencesTableViewController.swift
//  FoodieFun
//
//  Created by John Kouris on 10/18/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class MealsTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segementedControl: UISegmentedControl!
    
    
    let apiController = APIController()
    
    var filteredMeals: [Meal] = []
    
    var isChanged: Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.apiController.tokenFromUserDefaults == nil && self.apiController.token == nil {
            performSegue(withIdentifier: "ToSignInView", sender: self)
        } else {
            self.apiController.fetchMeals { (error) in
                if let error = error {
                    print(error)
                    return
                } else {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let index = self.segementedControl.selectedSegmentIndex
        
        self.isChanged = true
        
        if let searchTerm = self.searchBar.text,
        !searchTerm.isEmpty {
            
            switch index {
                
            case 0:
                self.filteredMeals = self.apiController.allMeals.filter {$0.restaurantName?.contains(searchTerm) ?? false}
            case 1:
                self.filteredMeals = self.apiController.allMeals.filter {$0.itemName.contains(searchTerm)}
            case 2:
                let searchTermInt = Int(searchTerm)
                self.filteredMeals = self.apiController.allMeals.filter {$0.foodRating == searchTermInt}
            default:
                self.filteredMeals = self.apiController.allMeals
            }
            self.tableView.reloadData()
        } else {
            self.isChanged = false
            self.apiController.fetchMeals { (error) in
                if let error = error {
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if !self.isChanged {
            return self.apiController.allMeals.count
        } else {
            return self.filteredMeals.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var meal: Meal
        
        if !self.isChanged {
            meal = self.apiController.allMeals[indexPath.row]
        } else {
            meal = self.filteredMeals[indexPath.row]
        }
        let customCell = cell as! MealTableViewCell
        customCell.meal = meal
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let meal = self.apiController.allMeals[indexPath.row]
        self.apiController.deleteMeal(for: meal) { (error) in
            if let error = error {
                print(error)
                return
            }
        }
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSignInView" {
            guard let destVC = segue.destination as? SignInViewController else {return}
            destVC.apiController = self.apiController
        } else if segue.identifier == "ToCreateMeal" {
            guard let destVC = segue.destination as? DetailMealViewController else {return}
            destVC.apiController = self.apiController
        } else if segue.identifier == "ToUpdateMeal" {
            guard let destVC = segue.destination as? DetailMealViewController,
                let selectedRow = self.tableView.indexPathForSelectedRow else {return}
            if !isChanged {
                destVC.meal = self.apiController.allMeals[selectedRow.row]
            } else {
                destVC.meal = self.filteredMeals[selectedRow.row]
            }
            destVC.apiController = self.apiController
        }
    }
}

