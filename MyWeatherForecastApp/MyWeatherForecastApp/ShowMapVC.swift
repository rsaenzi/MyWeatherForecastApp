//
//  ShowMapVC.swift
//  MyWeatherForecastApp
//
//  Created by Rigoberto Sáenz Imbacuán on 1/28/16.
//  Copyright © 2016 Rigoberto Saenz Imbacuan. All rights reserved.
//

import UIKit
import GoogleMaps

class ShowMapVC: UIViewController, GMSMapViewDelegate {
    
    // Google Maps API Key: AIzaSyBctwndeX9l73bhXmn0ErevauD0d7wunj4
    
    
    @IBOutlet weak var mapViewContainer: UIView!
    
    // Marker
    var marker = GMSMarker()
    
    // Init position
    var initLatitude = 4.635040
    var initLongitude = -74.083768
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Coloreamos de negro los controlles de la navigation bar
        self.navigationController!.navigationBar.tintColor = UIColor.blackColor()
        
        // Creamos una posicion de la camara
        let camera = GMSCameraPosition.cameraWithLatitude(4.635040, longitude: -74.083768, zoom: 11)
        
        // Creamos una instancia del mapa
        let mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        
        // Configuramos sus propiedades
        mapView.myLocationEnabled = true
        mapView.accessibilityElementsHidden = false
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = false
        
        // Indicamos que la clase actual puede actual como delagado de los eventos
        mapView.delegate = self
        
        // Agregamos el mapa a la vista
        self.view = mapView
        
        // Creamos el Marker y lo colocamos en la posicion por defecto
        marker.position = CLLocationCoordinate2DMake(initLatitude, initLongitude)
        marker.title = ""
        marker.snippet = ""
        marker.map = mapView
        
        // Mostramos un alert indicandole al usuario que debe hacer long press
        showAlert("If you want to see the weather forecast for a specific point in map, please do a long-press gesture over it...")
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        // Coloreamos de negro los controlles de la navigation bar
        self.navigationController!.navigationBar.tintColor = UIColor.blackColor()
    }
    
    // MARK: GMSMapViewDelegate
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        
        // Movemos el Marker a la nueva posicion
        marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        marker.map = mapView
    }
    
    /**
     * Called after a long-press gesture at a particular coordinate.
     *
     * @param mapView The map view that was pressed.
     * @param coordinate The location that was pressed.
     */
    func mapView(mapView: GMSMapView!, didLongPressAtCoordinate coordinate: CLLocationCoordinate2D){
        
        // Movemos el Marker a la nueva posicion
        marker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        marker.map = mapView
        
        // Guardamos la posicion en el Model
        Model.instance.mapLatitude = coordinate.latitude
        Model.instance.mapLongitude = coordinate.longitude
        
        // Mostramos la pantalla que muestre el clima de la zona
        let vControllerToSet = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ShowMapWheather")
        self.navigationController?.pushViewController(vControllerToSet, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func showAlert(messageToShow: String){
        
        // Creamos la alerta
        let alert: UIAlertController = UIAlertController(title: "MyWeatherForecastApp", message: messageToShow, preferredStyle: UIAlertControllerStyle.Alert)
        
        // Le agregamos el boton OK
        let alertActionOK: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        
        // Asociamos el boton OK al dialogo
        alert.addAction(alertActionOK)
        
        // Mostramos de manera modal la alerta
        self.navigationController?.presentViewController(alert, animated: true, completion: nil)
    }
    
}