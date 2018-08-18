//
//  CountriesAllTVC.swift
//  SmallWorld
//
//  Created by Tomer Peled on 8/17/18.
//  Copyright © 2018 Tomer Peled. All rights reserved.
//

import UIKit

class CountriesAllTVC: UITableViewController {

    let cellId = "allCountriesIdentifier"
    let segueId = "showBorders"
    
    var countries: [Country]? {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCountries()
    }
    
    func fetchCountries() {
        DataManager.sharedInstance.fetchAllCountries{ [weak self]  (countries: [Country]) in
            self?.countries = countries
        }
    }
    
    // MARK: - UITableView methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        cell.textLabel?.text = countries?[indexPath.item].name ?? ""
        cell.detailTextLabel?.text = countries?[indexPath.item].nativeName ?? ""
        return cell
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueId {
            if let destinationVC = segue.destination as? CountriesBordersTVC {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    destinationVC.selectedCountry = countries?[indexPath.row]
                }
            }
        }
    }
}
