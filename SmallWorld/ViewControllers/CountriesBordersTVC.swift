//
//  CountriesBordersTVC.swift
//  SmallWorld
//
//  Created by Tomer Peled on 8/17/18.
//  Copyright © 2018 Tomer Peled. All rights reserved.
//

import UIKit

class CountriesBordersTVC: UITableViewController {
    
    let cellId = "bordersCountriesIdentifier"
    let segueId = "showCountry"
    
    var countryBorders: [Country]? {
        didSet{
            self.tableView.reloadData()
        }
    }
    var selectedCountry: Country? {
        didSet {
            setTitle()
            fetchBorders()
        }
    }
    
    func setTitle() {
        if let name = selectedCountry?.name {
            navigationItem.title = "\(name)'s Borders Countries"
        }
    }
    
    func fetchBorders() {
        DataManager.sharedInstance.fetchBordersOf(country: selectedCountry!) { [weak self] (countries: [Country]) in
            self?.countryBorders = countries
        }
    }
    // MARK: - UITableView methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryBorders?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = countryBorders?[indexPath.item].name ?? ""
        cell.detailTextLabel?.text = countryBorders?[indexPath.item].nativeName ?? ""
        return cell
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId {
            if let destinationVC = segue.destination as? CountryVC {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    destinationVC.selectedCountry = countryBorders?[indexPath.row]
                }
            }
        }
    }

}
