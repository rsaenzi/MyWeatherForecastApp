//
//  MapWheatherVC.swift
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
import CoreLocation

class MapWheatherVC: UIViewController {
    
    // Managers
    private let forecastIOClient = APIClient(apiKey: "c617b4ec377c53f3fac8ca7018526435")
    
    // UI
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelCountry: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Iconos blancos
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        // Definimos el sistema de medidas
        forecastIOClient.units = .SI
        
        // Limpiamos la pantalla
        labelTemperature.text = ""
        labelDescription.text = "Please grant the required location permission..."
        labelCountry.text = ""
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Iconos blancos
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        // Mostramos un alert de progreso
        KVNProgress.showWithStatus("Getting weather forecast...")
        
        // Solicitamos el clima y el nombre del punto seleccionado
        getWheather()
    }
    
    func getWheather() {
        
        do {
            
            // Solicitamos el reporte del clima para el area actual
            forecastIOClient.getForecast(latitude: Model.instance.mapLatitude, longitude: Model.instance.mapLongitude) { (currentForecast, error) -> Void in
                
                // Si el reporte es valido
                if let currentForecast = currentForecast {
                    
                    // Ejecutamos en el thread que maneja la UI
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        // Mostramos la temperatura y la descripcion
                        self.labelTemperature.text = "\(currentForecast.currently!.temperature!) °c"
                        self.labelDescription.text = "\(currentForecast.daily!.summary!)"
                    })
                    
                    // Hacemos reverse geocoding para obtener el nombre de la ubicacion actual
                    self.doReverseGeocoding()
                    
                } else if let error = error {
                    
                    //  Uh-oh we have an error!
                    //print("Forecast: \(error.description)")
                    
                    // Cerramos el alert de progreso
                    KVNProgress.dismiss()
                }
            }
        }catch{
            // Cerramos el alert de progreso
            KVNProgress.dismiss()
        }
    }
    
    func doReverseGeocoding(){
        
        do{
            
            // Creamos los parametros para el request
            let parameters = [
                "latlng": "\(Model.instance.mapLatitude),\(Model.instance.mapLongitude)",
                "sensor": "true"
            ]
            
            // Solicitamos la info del area geografica actual a partir de la ubicacion actual
            Alamofire.request(.GET, "http://maps.googleapis.com/maps/api/geocode/json", parameters: parameters)
                .responseString { response in
                    
                    // Si el request fue exitoso
                    if response.result.isSuccess {
                        
                        // Convertimos el string en un arbol JSON
                        let jsonTree = SwiftyJSON.JSON.parse(response.result.value!)
                        
                        // Ejecutamos en el thread que maneja la UI
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            // Mostramos el pais y la ciudad
                            self.labelCountry.text = jsonTree["results"][1]["formatted_address"].string
                        })
                        
                    }else{
                        
                        //  Uh-oh we have an error!
                        //print("Geocoding: \(response.result.error!)")
                    }
                    
                    // Cerramos el alert de progreso
                    KVNProgress.dismiss()
            }
        }catch{
            
            // Cerramos el alert de progreso
            KVNProgress.dismiss()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

