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
    
    var allCountries: [String] = []
    var allCities: [Array<String>] = []
    
    private var countryToSet: OrderSelection?
    
    private var firstSelectedCountry:  String? = nil
    private var secondSelectedCountry: String? = nil
    private var firstSelectedCity:  String? = nil
    private var secondSelectedCity: String? = nil
    
    private var citiesArray: Array<String>? = nil
    
    func clearSelection(){
        countryToSet = nil
        
        firstSelectedCountry = nil
        secondSelectedCountry = nil
        firstSelectedCity = nil
        secondSelectedCity = nil
        
        citiesArray = nil
    }
    
    
    func getCountryPointerForSelection() -> OrderSelection? {
        return countryToSet
    }
    func setCountryPointerForSelection(country: OrderSelection){
        countryToSet = country
    }
    
    
    func setSelectedCountry(countrySet: String, citiesFromCountry: Array<String>){
        if countryToSet == .FirstCountry {
            firstSelectedCountry = countrySet
        }else{
            secondSelectedCountry = countrySet
        }
        citiesArray = citiesFromCountry
    }
    func setSelectedCity(cityToSet: String) {
        if countryToSet == .FirstCountry {
            firstSelectedCity = cityToSet
        }else{
            secondSelectedCity = cityToSet
        }
    }
    
    
    func getSelectedCountryCities() -> Array<String>? {
        return citiesArray
    }
    func getSelectedCountry(selection: OrderSelection) -> String? {
        if selection == .FirstCountry {
            return firstSelectedCountry
        }else{
            return secondSelectedCountry
        }
    }
    func getSelectedCity(selection: OrderSelection) -> String? {
        if selection == .FirstCountry {
            return firstSelectedCity
        }else{
            return secondSelectedCity
        }
    }
    
    
    // ---------------------------------------------
    // Map Coordinates
    // ---------------------------------------------
    
    var mapLongitude: Double = 0.0
    var mapLatitude: Double = 0.0
    
}

public enum OrderSelection {
    case FirstCountry
    case SecondCountry
}