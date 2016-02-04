//
//  CitySelectionVC.swift
//  MyWeatherForecastApp
//
//  Created by Rigoberto Sáenz Imbacuán on 2/3/16.
//  Copyright © 2016 Rigoberto Saenz Imbacuan. All rights reserved.
//

import UIKit
import KVNProgress


class CitySelectionVC: UITableViewController {
    
    // Countries Data [Name: [latitude: longitude]]
    var countries: [String] = []
    var cities: [Array<String>] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.instance.getSelectedCountryCities()!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Obtenemos una copia de la celda prototipo
        let currentCell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellCity")!
        
        // Colomamos el nombre del pais en la celda
        currentCell.textLabel?.text = Model.instance.getSelectedCountryCities()![indexPath.row]
        
        // Retornamos la celda ya configurada
        return currentCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        // Obtenemos los datos de la ciudad seleccionada
        let name: String = Model.instance.getSelectedCountryCities()![indexPath.row]
        
        // Guardamos la data del pais seleccionado
        Model.instance.setSelectedCity(name)
        
        // Quitamos la pantalla actual
        self.navigationController?.popViewControllerAnimated(true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
