//
//  ExperiencesTableViewController.swift
//  FoodieFun
//
//  Created by John Kouris on 10/18/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import UIKit
import CoreData

class ExperiencesTableViewController: UITableViewController {
    
    let apiController = APIController()
    let images = ["eggsBG", "fishBG", "hummusBG", "kebabBG", "mealBG", "pitaBG", "pizzaBG", "saladBG", "steakBG", "toastBG", "tritipBG", "twoSaladsBG"]
    
    lazy var fetchedResultsController: NSFetchedResultsController<Experience> = {
        let fetchRequest: NSFetchRequest<Experience> = Experience.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: false)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.mainContext, sectionNameKeyPath: "itemName", cacheName: nil)
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        
        return frc
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if apiController.token == nil {
            performSegue(withIdentifier: "SignInViewModalSegue", sender: self)
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "experienceCell", for: indexPath) as? ExperienceTableViewCell else { return UITableViewCell() }
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.2189036906, green: 0.3357507586, blue: 0.3665895164, alpha: 1)
        cell.experience = fetchedResultsController.object(at: indexPath)
        
        let randomNumber = Int.random(in: 0...images.count-1)
        cell.backgroundImageView.image = UIImage(named: images[randomNumber])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let experience = fetchedResultsController.object(at: indexPath)
            apiController.delete(experience: experience)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignInViewModalSegue" {
            if let signInVC = segue.destination as? SignInViewController {
                signInVC.apiController = apiController
            }
        } else if segue.identifier == "searchSegue" {
            if let searchVC = segue.destination as? SearchViewController {
                searchVC.apiController = apiController
            }
        } else if segue.identifier == "editExperienceSegue" {
            if let experienceVC = segue.destination as? AddExperienceViewController, let indexPath = tableView.indexPathForSelectedRow {
                let experience = fetchedResultsController.object(at: indexPath)
                
                experienceVC.experience = experience
                experienceVC.apiController = apiController
            }
        }
    }
    
}

extension ExperiencesTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
//            tableView.moveRow(at: indexPath, to: newIndexPath)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        @unknown default:
            return
        }
    }
    
}
