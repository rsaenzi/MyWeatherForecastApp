//
//  MainMenuVC.swift
//  MyWeatherForecastApp
//
//  Created by Rigoberto Sáenz Imbacuán on 1/27/16.
//  Copyright © 2016 Rigoberto Saenz Imbacuan. All rights reserved.
//

import UIKit

class MainMenuVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Navigation bar transparente con iconos blancos
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        
        // Iconos blancos
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Iconos blancos
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onClickTravel(sender: UIButton, forEvent event: UIEvent) {
        
        // Limpiamos cualquier seleccion previa
        Model.instance.clearSelectedCountries()
    }
    
    
}

