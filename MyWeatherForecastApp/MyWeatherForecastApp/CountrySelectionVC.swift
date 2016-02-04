//
//  CountrySelectionVC.swift
//  MyWeatherForecastApp
//
//  Created by Rigoberto Sáenz Imbacuán on 1/28/16.
//  Copyright © 2016 Rigoberto Saenz Imbacuan. All rights reserved.
//

import UIKit
import KVNProgress


class CountrySelectionVC: UITableViewController {
    
    
    @IBOutlet var tableCountries: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            // SI es necesario descargar las ciudades y paises
            if Model.instance.allCountries.count == 0 || Model.instance.allCities.count == 0 {
                
                // Mostramos un alert de progreso
                KVNProgress.showWithStatus("Getting countries...")
                
                // Obtenemos la lista completa de paises y ciudades
                ApiAccessController.getAllCountriesAndCities({
                    (countries, cities) -> () in
                    
                    // Guardamos los datos
                    Model.instance.allCountries = countries
                    Model.instance.allCities = cities
                    
                    // Actualizamos la tabla
                    self.tableCountries.reloadData()
                    
                    // Cerramos el alert de progreso
                    KVNProgress.dismiss()
                    
                    }, callbackError: { (error) -> () in
                        
                        // Cerramos el alert de progreso
                        KVNProgress.dismiss()
                })
            }
        }catch{
            
            // Cerramos el alert de progreso
            KVNProgress.dismiss()
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.instance.allCountries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Obtenemos una copia de la celda prototipo
        let currentCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellCountry")!
        
        // Colomamos el nombre del pais en la celda
        currentCell.textLabel?.text = Model.instance.allCountries[indexPath.row]
        
        // Retornamos la celda ya configurada
        return currentCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        // Obtenemos los datos del pais seleccionado
        let name: String = Model.instance.allCountries[indexPath.row]
        
        // Guardamos la data del pais seleccionado
        Model.instance.setSelectedCountry(name, citiesFromCountry: Model.instance.allCities[indexPath.row])
    }
    
}
