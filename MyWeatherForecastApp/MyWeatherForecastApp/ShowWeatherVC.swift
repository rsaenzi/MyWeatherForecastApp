//
//  ShowWeatherVC.swift
//  MyWeatherForecastApp
//
//  Created by Rigoberto Sáenz Imbacuán on 1/27/16.
//  Copyright © 2016 Rigoberto Saenz Imbacuan. All rights reserved.
//

import UIKit
import ForecastIO
import KVNProgress
import CoreLocation


class ShowWeatherVC: UIViewController, CLLocationManagerDelegate {
    
    // Managers
    private var locationManager = CLLocationManager()
    private let forecastIOClient = APIClient(apiKey: "c617b4ec377c53f3fac8ca7018526435")
    
    // User Data
    private var currentLongitude: Double?
    private var currentLatitude: Double?
    
    // UI
    @IBOutlet weak var labelTemperature: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelCountry: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            
            // Mostramos un alert de progreso
            KVNProgress.showWithStatus("Getting weather forecast...")
            
            // Limpiamos la pantalla
            labelTemperature.text = ""
            labelDescription.text = "Please grant the required location permission..."
            labelCountry.text = ""
            
            // Definimos el sistema de medidas
            forecastIOClient.units = .SI
            
            // Solicitamos la autorizacion del usuario para el uso de su ubicacion
            locationManager.requestAlwaysAuthorization()
            
            // Si los servicios de localizacion fueron autorizados
            if CLLocationManager.locationServicesEnabled(){
                
                // Indicamos que esta clase es un observer que cumple con el protocol correspondiente
                locationManager.delegate = self
                
                // Indicamos la precision de la ubicacion
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                
                // Solicitamos que de manera continua se nos informe de la ubicacion del usuario
                locationManager.startUpdatingLocation()
                
            }else{
                
                // Mostramos la causa del error
                labelDescription.text = "Please grant the required location permission..."
                
                // Cerramos el alert de progreso
                KVNProgress.dismiss()
            }
        }catch{
            
            // Mostramos la causa del error
            labelDescription.text = "Please grant the required location permission..."
            
            // Cerramos el alert de progreso
            KVNProgress.dismiss()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        do {
            
            // Solicitamos el primer resultado obtenido
            let userLocation:CLLocation = locations[0]
            
            // Obtenemos la ubicacion del usuario
            currentLongitude = userLocation.coordinate.longitude;
            currentLatitude = userLocation.coordinate.latitude;
            
            // Detenemos la captura de la ubicacion
            locationManager.stopUpdatingLocation();
            
            // Solicitamos el reporte del clima para el area actual
            forecastIOClient.getForecast(latitude: currentLatitude!, longitude: currentLongitude!) { (currentForecast, error) -> Void in
                
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
            
            // Solicitamos la info del area geografica actual a partir de la ubicacion actual
            ApiAccessController.requestLocationNameFromCoordinates(currentLatitude!, currentLongitude: currentLongitude!,
                callbackSuccess: { (jsonTree) -> () in
                    
                    // Ejecutamos en el thread que maneja la UI
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        // Mostramos el pais y la ciudad
                        self.labelCountry.text = jsonTree["results"][1]["formatted_address"].string
                    })
                    
                    // Cerramos el alert de progreso
                    KVNProgress.dismiss()
                    
                }, callbackError: { (error) -> () in
                    
                    // Informamos sobre el error
                    print(error)
                    
                    // Cerramos el alert de progreso
                    KVNProgress.dismiss()
            })
            
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

