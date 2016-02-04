//
//  ApiAccessController.swift
//  MyWeatherForecastApp
//
//  Created by Rigoberto Sáenz Imbacuán on 2/3/16.
//  Copyright © 2016 Rigoberto Saenz Imbacuan. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ApiAccessController {
    
    
    class func requestLocationNameFromCoordinates(currentLatitude: Double, currentLongitude: Double, callbackSuccess: (jsonTree: SwiftyJSON.JSON)->(), callbackError: (error: NSError)->()){
        
        // Creamos los parametros para el request
        let parameters = [
            "latlng": "\(currentLatitude),\(currentLongitude)",
            "sensor": "true"
        ]
        
        // Solicitamos la info del area geografica actual a partir de la ubicacion actual
        Alamofire.request(.GET, "http://maps.googleapis.com/maps/api/geocode/json", parameters: parameters)
            .responseString { response in
                
                // Procemos la respuesta
                if response.result.isSuccess {
                    let jsonData = SwiftyJSON.JSON.parse(response.result.value!)
                    callbackSuccess(jsonTree: jsonData)
                }else{
                    callbackError(error: response.result.error!)
                }
        }
    }
    
    
    class func getAllCountriesAndCities(callbackSuccess: (countries: [String], cities: [Array<String>])->(), callbackError: (error: NSError)->()){
        
        var countries: [String] = []
        var cities: [Array<String>] = []
        
        // Solicitamos la lista de todos los paises y ciudades
        Alamofire.request(.GET, "https://db.tt/z8bWA6av")
            .responseString { response in
                
                // Si el request fue exitoso
                if response.result.isSuccess {
                    
                    // Convertimos el string en un arbol JSON
                    let jsonTree = SwiftyJSON.JSON.parse(response.result.value!)
                    
                    // Extraemos la data de las ciudades y paises
                    for countryInfo in jsonTree {
                        
                        // El paise debe tener un nombre valido
                        if countryInfo.0 != "" {
                            
                            // Agregamos el nombre del pais
                            countries.append(countryInfo.0)
                            
                            // Agregamos las cuidades del pais actual a un array
                            var extractedCities: [String] = []
                            for cityInfo in countryInfo.1.array! {
                                extractedCities.append(cityInfo.string!)
                            }
                            
                            // Agregamos el arary de ciudades
                            cities.append(extractedCities)
                        }
                    }
                    
                    callbackSuccess(countries: countries, cities: cities)
                }else{
                    callbackError(error: response.result.error!)
                }
        }
    }
    
    
    
    
    
}