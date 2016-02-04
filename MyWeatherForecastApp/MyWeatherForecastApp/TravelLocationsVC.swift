//
//  TravelLocationsVC.swift
//  MyWeatherForecastApp
//
//  Created by Rigoberto Sáenz Imbacuán on 1/28/16.
//  Copyright © 2016 Rigoberto Saenz Imbacuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ForecastIO
import KVNProgress
import GoogleMaps


class TravelLocationsVC: UIViewController {
    
    // APi Access
    private let googleMapsGeocodingAPIKey = "AIzaSyABstQbHmTXkLvaaPtC1GCfqE9Bmv0DJgA"
    private let forecastIOClient = APIClient(apiKey: "c617b4ec377c53f3fac8ca7018526435")
    
    // Recomendation
    private var firstTemperature: Float = 0
    private var secondTemperature: Float = 0
    
    // First Country
    @IBOutlet weak var labelFirstTemperature: UILabel!
    @IBOutlet weak var labelFirstCountry: UILabel!
    
    // Second Country
    @IBOutlet weak var labelSecondTemperature: UILabel!
    @IBOutlet weak var labelSecondCountry: UILabel!
    
    // Recomendation
    @IBOutlet weak var labelRecomendationTitle: UILabel!
    @IBOutlet weak var labelRecomendationCity: UILabel!
    @IBOutlet weak var imageRecomendation: UIImageView!
    
    // Containers
    @IBOutlet weak var containerFirstCountry: UIView!
    @IBOutlet weak var containerSecondCountry: UIView!
    @IBOutlet weak var containerRecomendation: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Definimos el sistema de medidas
        forecastIOClient.units = .SI
    }
    
    private func hideAllButtons(){
        containerFirstCountry.hidden = true
        containerSecondCountry.hidden = true
        containerRecomendation.hidden = true
    }
    
    
    override func viewWillAppear(animated: Bool){ // Called when the view is about to made visible. Default does nothing
        super.viewWillAppear(true)
        
        // Mostramos un alert de progreso
        KVNProgress.showWithStatus("Getting weather forecast...")
        
        // Por seguridad, todos los botones estan desactivados
        hideAllButtons()
        
        // Si aplica, mostramos la data del primer pais
        if Model.instance.getSelectedCountry(.FirstCountry) != nil && Model.instance.getSelectedCity(.FirstCountry) != nil {
            
            // Solicitamos la info del clima para el primer pais
            getFirstCountryWheather(Model.instance.getSelectedCountry(.FirstCountry)!, firstCity: Model.instance.getSelectedCity(.FirstCountry)!)
        }else {
            
            // Mostramos el primer boton para que el usuario pueda seleccionar la primera ciudad
            self.containerFirstCountry.hidden = false
            
            // Cerramos el alert de progreso
            KVNProgress.dismiss()
        }
    }
    
    // ----------------------------------------------------------------------
    // First Country
    // ----------------------------------------------------------------------
    func getFirstCountryWheather(firstCountry: String, firstCity: String){
        
        do{
            // Creamos los parametros para el request
            let parameters = [
                "address": "\(firstCity),\(firstCountry)".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!,
                "key": googleMapsGeocodingAPIKey
            ]
            
            // Solicitamos la info del area geografica actual a partir de la ubicacion actual
            Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/geocode/json", parameters: parameters)
                .responseString { response in
                    
                    // Si el request fue exitoso
                    if response.result.isSuccess {
                        
                        // Convertimos el string en un arbol JSON
                        let jsonTree = SwiftyJSON.JSON.parse(response.result.value!)
                        
                        // Extraemos las coordenas
                        let firstCityCoords = (jsonTree["results"][0]["geometry"]["location"]["lat"].double!, jsonTree["results"][0]["geometry"]["location"]["lng"].double!)
                        
                        // Solicitamos el reporte del clima para el area actual
                        self.forecastIOClient.getForecast(latitude: firstCityCoords.0, longitude: firstCityCoords.1) { (currentForecast, error) -> Void in
                            
                            // Si el reporte es valido
                            if let currentForecast = currentForecast {
                                
                                // Guardamos la temperatura para hacer la comparacion posterior
                                self.firstTemperature = currentForecast.currently!.temperature!
                                
                                // Ejecutamos en el thread que maneja la UI
                                dispatch_async(dispatch_get_main_queue(),{
                                    
                                    // Mostramos la temperatura
                                    self.containerFirstCountry.hidden = false
                                    self.labelFirstCountry.text = "\(firstCity), \(firstCountry)"
                                    self.labelFirstTemperature.text = "\(self.firstTemperature) °c"
                                })
                                
                                // Si aplica, mostramos la data del segundo pais
                                if Model.instance.getSelectedCountry(.SecondCountry) != nil && Model.instance.getSelectedCity(.SecondCountry) != nil {
                                    
                                    // Solicitamos la info del clima para el segundo pais
                                    self.getSecondCountryWheather(Model.instance.getSelectedCountry(.SecondCountry)!, secondCity: Model.instance.getSelectedCity(.SecondCountry)!)
                                    
                                }else {
                                    
                                    // Ejecutamos en el thread que maneja la UI
                                    dispatch_async(dispatch_get_main_queue(),{
                                        
                                        // Mostramos el segundo boton para que el usuario pueda seleccionar la segunda ciudad
                                        self.containerSecondCountry.hidden = false
                                    })
                                    
                                    // Cerramos el alert de progreso
                                    KVNProgress.dismiss()
                                }
                                
                            } else {
                                
                                // Error
                                self.hideAllButtons()
                                
                                // Cerramos el alert de progreso
                                KVNProgress.dismiss()
                            }
                        }
                        
                    }else{
                        
                        // Error
                        self.hideAllButtons()
                        
                        // Cerramos el alert de progreso
                        KVNProgress.dismiss()
                    }
            }
        }catch{
            
            // Error
            self.hideAllButtons()
            
            // Cerramos el alert de progreso
            KVNProgress.dismiss()
        }
    }
    
    
    // ----------------------------------------------------------------------
    // Second Country
    // ----------------------------------------------------------------------
    func getSecondCountryWheather(secondCountry: String, secondCity: String){
        
        
        do{
            // Creamos los parametros para el request
            let parameters = [
                "address": "\(secondCity),\(secondCountry)".stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!,
                "key": googleMapsGeocodingAPIKey
            ]
            
            // Solicitamos la info del area geografica actual a partir de la ubicacion actual
            Alamofire.request(.GET, "https://maps.googleapis.com/maps/api/geocode/json", parameters: parameters)
                .responseString { response in
                    
                    // Si el request fue exitoso
                    if response.result.isSuccess {
                        
                        // Convertimos el string en un arbol JSON
                        let jsonTree = SwiftyJSON.JSON.parse(response.result.value!)
                        
                        // Extraemos las coordenas
                        let secondCityCoords = (jsonTree["results"][0]["geometry"]["location"]["lat"].double!, jsonTree["results"][0]["geometry"]["location"]["lng"].double!)
                        
                        // Solicitamos el reporte del clima para el area actual
                        self.forecastIOClient.getForecast(latitude: secondCityCoords.0, longitude: secondCityCoords.1) { (currentForecast, error) -> Void in
                            
                            // Si el reporte es valido
                            if let currentForecast = currentForecast {
                                
                                // Guardamos la temperatura para hacer la comparacion posterior
                                self.secondTemperature = currentForecast.currently!.temperature!
                                
                                // Ejecutamos en el thread que maneja la UI
                                dispatch_async(dispatch_get_main_queue(),{
                                    
                                    // Mostramos la temperatura
                                    self.containerSecondCountry.hidden = false
                                    self.labelSecondCountry.text = "\(secondCity), \(secondCountry)"
                                    self.labelSecondTemperature.text = "\(self.secondTemperature) °c"
                                    
                                    
                                    // LLegados a este punto podemos mostrar la recomendacion
                                    self.containerRecomendation.hidden = false
                                    
                                    // Determinamos cual ciudad es mejor para vacacionar
                                    if self.firstTemperature > self.secondTemperature {
                                        self.labelRecomendationCity.text = self.labelFirstCountry.text
                                    }else {
                                        self.labelRecomendationCity.text = self.labelSecondCountry.text
                                    }
                                    
                                })
                                
                                // Cerramos el alert de progreso
                                KVNProgress.dismiss()
                                
                            } else {
                                
                                // Error
                                self.hideAllButtons()
                                
                                // Cerramos el alert de progreso
                                KVNProgress.dismiss()
                            }
                        }
                        
                    }else{
                        
                        // Error
                        self.hideAllButtons()
                        
                        // Cerramos el alert de progreso
                        KVNProgress.dismiss()
                    }
            }
        }catch{
            
            // Error
            self.hideAllButtons()
            
            // Cerramos el alert de progreso
            KVNProgress.dismiss()
        }
    }
    
    @IBAction func onClickFirstCountry(sender: UIButton, forEvent event: UIEvent) {
        Model.instance.setCountryPointerForSelection(OrderSelection.FirstCountry)
    }
    
    @IBAction func onClickSecondCountry(sender: UIButton, forEvent event: UIEvent) {
        Model.instance.setCountryPointerForSelection(OrderSelection.SecondCountry)
    }
}