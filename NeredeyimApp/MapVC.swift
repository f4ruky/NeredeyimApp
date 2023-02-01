//
//  MapVC.swift
//  NeredeyimApp
//
//  Created by Faruk Yaşar on 23.01.2023.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Kaydet", style: UIBarButtonItem.Style.plain, target: self, action: #selector(SaveButtonClicked))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Geri", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
    }
    
    @objc func chooseLocation(gestureRecognizer : UIGestureRecognizer){
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            
            annotation.title = PlaceModel.sharedInstance.MekanAdi
            annotation.subtitle = PlaceModel.sharedInstance.MekanTipi
            
            
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedInstance.Latitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.Longitude = String(coordinates.longitude)
        }
        
    }
    
    //lokasyon Tanımlama
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func SaveButtonClicked(){
        let placeModel = PlaceModel.sharedInstance
        
        //Parse veri tabanında veri tabanı oluşturma işlemi
        let object = PFObject(className: "Places")
        object["name"] = placeModel.MekanAdi
        object["type"] = placeModel.MekanTipi
        object["introduce"] = placeModel.MekanTanıtım
        object["latitude"] = placeModel.Latitude
        object["longitude"] = placeModel.Longitude
        
        //Kaydedeceğimiz image verisini önce dataya dönüştürüp kaydetme işlemi
        
        if let imageData = placeModel.MekanResim.jpegData(compressionQuality: 0.5){
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        object.saveInBackground{(success, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            }else{
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
            
    }
    @objc func backButtonClicked(){
        self.dismiss(animated: true)
    }

  

}
