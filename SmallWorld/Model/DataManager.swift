//
//  DataManager.swift
//  SmallWorld
//
//  Created by Tomer Peled on 8/17/18.
//  Copyright © 2018 Tomer Peled. All rights reserved.
//

import UIKit

class DataManager {
    
    static let sharedInstance = DataManager()
    
    private let openRestCountriesURL = "https://restcountries.eu/rest/v2/all?fields=name;nativeName;capital;area;region;callingCodes;population;borders;alpha3Code;flag"
    
    private var countries = [String:Country]()
    
    //main fetching function - gets the data using NSURLSession, converting it to a country array
    //and saving it as a dictionary for an effective fetching for the borders
    func fetchAllCountries(completion: @escaping ([Country]) -> ()) {
        let url = URL(string: openRestCountriesURL)
        URLSession.shared.dataTask(with: url!) {[unowned self] (data, response, error) in
            
            if error != nil {
                NSLog("DataManager - DataTask didFailWithError: \(String(describing: error))")
                return
            } else {
                guard let unwrappedData = data else {
                    NSLog("DataManager - DataTask got nil")
                    return
                }
                do {
                    let countriesArray = try JSONDecoder().decode([Country].self, from: unwrappedData)
                    for country in countriesArray{
                        self.countries[country.alpha3Code!] = country
                    }
                    DispatchQueue.main.async {
                        completion(countriesArray)
                    }
                } catch let jsonError {
                    NSLog("DataManager - JSONDecoder didFailWithError: \(jsonError)")
                }
            }
            }.resume()
    }
    
    //fetches the country's borders
    func fetchBordersOf(country: Country, completion: @escaping ([Country]) -> ())  {
        var result = [Country]()
        
        for element in country.borders! {
            if let border = countries[element] {
                result.append(border)
            }
        }
        completion(result)
    }
}
