//
//  ListVC.swift
//  Weather Gift
//
//  Created by Brittany Foley on 3/16/17.
//  Copyright © 2017 Brittany Foley. All rights reserved.
//

import UIKit
import GooglePlaces

class ListVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var locationsArray = [weatherLocation]()
    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    //MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToPageVC" {
            let controller = segue.destination as! PageVC
            currentPage = (tableView.indexPathForSelectedRow?.row)!
            // Identify the table cell [row] that the user tapped.
            // this is passed back to PageVC as currentpage
            controller.currentPage = currentPage
            controller.locationsArray = locationsArray
        }
    }
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing == true {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
        
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {  let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func saveUserDefaults() {
        var locationsDefaultsArray = [weatherUserDefault]()
        locationsDefaultsArray = locationsArray
        let locationsData = NSKeyedArchiver.archivedData(withRootObject: locationsDefaultsArray)
        UserDefaults.standard.set(locationsData, forKey: "locationsData")
       
    }
}

extension ListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        cell.textLabel?.text = locationsArray[indexPath.row].name
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //we don't need to put any code here because the cell triggers a segue
    }
    
    //MARK: - TableView Editing Functions
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            locationsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveUserDefaults()
            
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //First make a copy of the item that you're going to move
        let itemToMove = locationsArray[sourceIndexPath.row]
        //Delete item from the original location
        locationsArray.remove(at: sourceIndexPath.row)
        //Insert item into the "to", post-move location
        locationsArray.insert(itemToMove, at: destinationIndexPath.row)
        
        saveUserDefaults()
        
    }
    
    //MARK: TableView Code to Freeze the First Cell: No Deleting or Removing
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
       return (indexPath.row == 0 ? false : true )
        
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if proposedDestinationIndexPath.row == 0 {
            return sourceIndexPath
        } else {
            return proposedDestinationIndexPath
        }
        }
    
    func updateTable(place: GMSPlace) {
        let newLocation = weatherLocation()
        newLocation.name = place.name
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        newLocation.coordinates = "\(lat),\(long)"
        print(newLocation.coordinates)
        locationsArray.append(newLocation)
        tableView.reloadData()
    }
    }

extension ListVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        dismiss(animated: true, completion: nil)
        
        updateTable(place: place)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
