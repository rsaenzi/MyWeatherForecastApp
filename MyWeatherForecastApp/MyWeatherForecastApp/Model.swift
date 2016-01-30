//
//  Model.swift
//  MyWeatherForecastApp
//
//  Created by Rigoberto Sáenz Imbacuán on 1/28/16.
//  Copyright © 2016 Rigoberto Saenz Imbacuan. All rights reserved.
//

import Foundation

class Model {
    
    
    // ---------------------------------------------
    // Singleton
    // ---------------------------------------------
    
    static let instance = Model()
    private init() {}
    
    
    // ---------------------------------------------
    // Country Selection
    // ---------------------------------------------
    
    private var countryToSet: OrderSelection = .FirstCountry
    
    // [name : [latitude : longitud]]
    private var firstSelectedCountry:  Country? = nil
    private var secondSelectedCountry: Country? = nil
    
    func clearSelectedCountries(){
        print("clean")
        firstSelectedCountry = nil
        secondSelectedCountry = nil
    }
    
    func countryToSetAfter(country: OrderSelection){
        countryToSet = country
    }
    
    func setSelectedCountry(countrySet: Country){
        if countryToSet == .FirstCountry {
            firstSelectedCountry = countrySet
        }else{
            secondSelectedCountry = countrySet
        }
    }
    
    func getSelectedCountry(selection: OrderSelection) -> Country? {
        if selection == .FirstCountry {
            return firstSelectedCountry
        }else{
            return secondSelectedCountry
        }
    }
    
    
    // ---------------------------------------------
    // Map Coordinated
    // ---------------------------------------------
    
    var mapLongitude: Double = 0.0
    var mapLatitude: Double = 0.0
    
    
}

public enum OrderSelection {
    case FirstCountry
    case SecondCountry
}