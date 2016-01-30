//
//  CountrySelectionVC.swift
//  MyWeatherForecastApp
//
//  Created by Rigoberto Sáenz Imbacuán on 1/28/16.
//  Copyright © 2016 Rigoberto Saenz Imbacuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KVNProgress


class CountrySelectionVC: UITableViewController {
    
    
    @IBOutlet var tableCountries: UITableView!
    
    // Countries Data [Name: [latitude: longitude]]
    var countryList: [JSON]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            
            // Mostramos un alert de progreso
            KVNProgress.showWithStatus("Getting countries...")
            
            // Solicitamos la info del area geografica actual a partir de la ubicacion actual
            Alamofire.request(.GET, "https://restcountries.eu/rest/v1/all")
                .responseString { response in
                    
                    // Si el request fue exitoso
                    if response.result.isSuccess {
                        
                        // Convertimos el string en un arbol JSON
                        let jsonTree = SwiftyJSON.JSON.parse(response.result.value!)
                        
                        // Guardamos la lista de paises
                        self.countryList = jsonTree.array!
                        
                        // Actualizamos la tabla
                        self.tableCountries.reloadData()
                        
                    }else{
                        
                        //  Uh-oh we have an error!
                        //print("Countries: \(response.result.error!)")
                    }
                    
                    // Cerramos el alert de progreso
                    KVNProgress.dismiss()
            }
        }catch{
            // Cerramos el alert de progreso
            KVNProgress.dismiss()
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if countryList == nil {
            return 0
        }else {
            return countryList!.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Obtenemos una copia de la celda prototipo
        let currentCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellCountry")!
        
        // Colomamos el nombre del pais en la celda
        currentCell.textLabel?.text = countryList![indexPath.row]["name"].string
        
        // Retornamos la celda ya configurada
        return currentCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        // Obtenemos los datos del pais seleccionado
        let name: String = countryList![indexPath.row]["name"].string!
        let latitude: String = String(countryList![indexPath.row]["latlng"][0].double!) // Lat
        let longitude: String = String(countryList![indexPath.row]["latlng"][1].double!) // Long
        
        // Guardamos la data del pais seleccionado
        let country = Country(name: name, longitude: longitude, latitude: latitude)
        Model.instance.setSelectedCountry(country)
        
        // Quitamos la pantalla actual
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
