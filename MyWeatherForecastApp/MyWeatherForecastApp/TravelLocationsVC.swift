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


class TravelLocationsVC: UIViewController {
    
    // Managers
    private let forecastIOClient = APIClient(apiKey: "c617b4ec377c53f3fac8ca7018526435")
    
    // Recomendation
    private var firstTemperature: Double = 0
    private var secondTemperature: Double = 0
    
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
        if Model.instance.getSelectedCountry(OrderSelection.FirstCountry) != nil {
            
            // Solicitamos la info del clima para el primer pais
            getFirstCountryWheather(Model.instance.getSelectedCountry(OrderSelection.FirstCountry)!)
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
    func getFirstCountryWheather(firstCountry: Country){
        
        // Solicitamos el reporte del clima para el area actual
        forecastIOClient.getForecast(latitude: Double(firstCountry.latitude)!, longitude: Double(firstCountry.longitude)!) { (currentForecast, error) -> Void in
            
            // Si el reporte es valido
            if let currentForecast = currentForecast {
                
                // Guardamos la temperatura para hacer la comparacion
                self.firstTemperature = Double(currentForecast.currently!.temperature!)
                
                // Hacemos reverse geocoding para obtener el nombre de la ubicacion actual
                self.getFirstCountryGeocoding(firstCountry, temperature: "\(currentForecast.currently!.temperature!) °c")
                
            } else if let error = error {
                
                //  Uh-oh we have an error!
                //print("Forecast: \(error.description)")
                self.hideAllButtons()
                
                // Cerramos el alert de progreso
                KVNProgress.dismiss()
            }
        }
    }
    func getFirstCountryGeocoding(firstCountry: Country, temperature: String){
        
        do{
            
            // Creamos los parametros para el request
            let parameters = [
                "latlng": "\(firstCountry.latitude),\(firstCountry.longitude)",
                "sensor": "true"
            ]
            
            // Solicitamos la info del area geografica actual a partir de la ubicacion actual
            Alamofire.request(.GET, "http://maps.googleapis.com/maps/api/geocode/json", parameters: parameters)
                .responseString { response in
                    
                    // Si el request fue exitoso
                    if response.result.isSuccess {
                        
                        // Convertimos el string en un arbol JSON
                        let jsonTree = SwiftyJSON.JSON.parse(response.result.value!)
                        //print(response.result.value!)
                        
                        // Ejecutamos en el thread que maneja la UI
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            // Mostramos el pais y la ciudad
                            self.containerFirstCountry.hidden = false
                            self.labelFirstTemperature.text = temperature
                            self.labelFirstCountry.text = jsonTree["results"][1]["formatted_address"].string
                        })
                        
                        // Si aplica, mostramos la data del segundo pais
                        if Model.instance.getSelectedCountry(OrderSelection.SecondCountry) != nil {
                            
                            // Solicitamos la info del clima para el primer pais
                            self.getSecondCountryWheather(Model.instance.getSelectedCountry(OrderSelection.SecondCountry)!)
                        }else {
                            
                            // Mostramos el segundo boton para que el usuario pueda seleccionar la segunda ciudad
                            self.containerSecondCountry.hidden = false
                            
                            // Cerramos el alert de progreso
                            KVNProgress.dismiss()
                        }
                    }else{
                        
                        //  Uh-oh we have an error!
                        //print("Geocoding: \(response.result.error!)")
                        self.hideAllButtons()
                        
                        // Cerramos el alert de progreso
                        KVNProgress.dismiss()
                    }
            }
        }catch{
            self.hideAllButtons()
            
            // Cerramos el alert de progreso
            KVNProgress.dismiss()
        }
    }
    
    
    // ----------------------------------------------------------------------
    // Second Country
    // ----------------------------------------------------------------------
    func getSecondCountryWheather(secondCountry: Country){
        
        // Solicitamos el reporte del clima para el area actual
        forecastIOClient.getForecast(latitude: Double(secondCountry.latitude)!, longitude: Double(secondCountry.longitude)!) { (currentForecast, error) -> Void in
            
            // Si el reporte es valido
            if let currentForecast = currentForecast {
                
                // Guardamos la temperatura para hacer la comparacion
                self.secondTemperature = Double(currentForecast.currently!.temperature!)
                
                // Hacemos reverse geocoding para obtener el nombre de la ubicacion actual
                self.getSecondCountryGeocoding(secondCountry, temperature: "\(currentForecast.currently!.temperature!) °c")
                
            } else if let error = error {
                
                //  Uh-oh we have an error!
                //print("Forecast: \(error.description)")
                self.hideAllButtons()
                
                // Cerramos el alert de progreso
                KVNProgress.dismiss()
            }
        }
    }
    func getSecondCountryGeocoding(firstCountry: Country, temperature: String){
        
        do{
            
            // Creamos los parametros para el request
            let parameters = [
                "latlng": "\(firstCountry.latitude),\(firstCountry.longitude)",
                "sensor": "true"
            ]
            
            // Solicitamos la info del area geografica actual a partir de la ubicacion actual
            Alamofire.request(.GET, "http://maps.googleapis.com/maps/api/geocode/json", parameters: parameters)
                .responseString { response in
                    
                    // Si el request fue exitoso
                    if response.result.isSuccess {
                        
                        // Convertimos el string en un arbol JSON
                        let jsonTree = SwiftyJSON.JSON.parse(response.result.value!)
                        //print(response.result.value!)
                        
                        // Ejecutamos en el thread que maneja la UI
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            // Mostramos el pais y la ciudad
                            self.containerSecondCountry.hidden = false
                            self.labelSecondTemperature.text = temperature
                            self.labelSecondCountry.text = jsonTree["results"][1]["formatted_address"].string
                            
                            // LLegados a este punto podemos mostrar la recomendacion
                            self.containerRecomendation.hidden = false
                            
                            // Determinamos cual ciudad es mejor para vacacionar
                            if self.firstTemperature > self.secondTemperature {
                                //self.labelRecomendationTitle.text = labelSecondCountry.text
                                self.labelRecomendationCity.text = self.labelFirstCountry.text
                            }else {
                                //self.labelRecomendationTitle.text = "Success"
                                self.labelRecomendationCity.text = self.labelSecondCountry.text
                            }
                            
                            // Cerramos el alert de progreso
                            KVNProgress.dismiss()
                        })
                        
                    }else{
                        
                        //  Uh-oh we have an error!
                        //print("Geocoding: \(response.result.error!)")
                        self.hideAllButtons()
                        
                        // Cerramos el alert de progreso
                        KVNProgress.dismiss()
                    }
            }
        }catch{
            self.hideAllButtons()
            
            // Cerramos el alert de progreso
            KVNProgress.dismiss()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickFirstCountry(sender: UIButton, forEvent event: UIEvent) {
        Model.instance.countryToSetAfter(OrderSelection.FirstCountry)
    }
    
    @IBAction func onClickSecondCountry(sender: UIButton, forEvent event: UIEvent) {
        Model.instance.countryToSetAfter(OrderSelection.SecondCountry)
    }
}