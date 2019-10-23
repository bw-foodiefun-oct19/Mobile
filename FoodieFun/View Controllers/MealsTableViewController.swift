//
//  ExperiencesTableViewController.swift
//  FoodieFun
//
//  Created by John Kouris on 10/18/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit

class MealsTableViewController: UITableViewController {
    
    let apiController = APIController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if apiController.bearerSignIn?.token == nil {
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

    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.apiController.allMeals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let meal = self.apiController.allMeals[indexPath.row]
        cell.textLabel?.text = meal.itemName
        cell.detailTextLabel?.text = meal.dateVisited
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
            destVC.meal = self.apiController.allMeals[selectedRow.row]
            destVC.apiController = self.apiController
        }
    }
}
