//
//  DetailsVC.swift
//  NeredeyimApp
//
//  Created by Faruk Yaşar on 23.01.2023.
//

import UIKit
import MapKit
import Parse
class DetailsVC: UIViewController, MKMapViewDelegate  {
    
    @IBOutlet weak var detayİmageView: UIImageView!
    
    @IBOutlet weak var mekanAdLabel: UILabel!
    
    @IBOutlet weak var mekanTipLabel: UILabel!
    
    @IBOutlet weak var mekanTanıtımLabel: UILabel!
    
    @IBOutlet weak var detayMapView: MKMapView!
    
    var choosenPlaceId = ""
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getDataFromParse()
        detayMapView.delegate = self
    }
    
    
    //Parse dan verileri çekmek
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: choosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if error != nil{
                
            }else{
                
                // Objeleri alma
                if objects != nil{
                    if objects!.count > 0 {
                        let choosenPlaceObject = objects![0]
                        
                        if let placeName = choosenPlaceObject.object(forKey: "name") as? String{
                            self.mekanAdLabel.text = placeName
                        }
                        if let placetype = choosenPlaceObject.object(forKey: "type") as? String{
                            self.mekanTipLabel.text = placetype
                        }
                        if let placeDesc = choosenPlaceObject.object(forKey: "introduce") as? String{
                            self.mekanTanıtımLabel.text = placeDesc
                        }
                        if let placeLatitude = choosenPlaceObject.object(forKey: "latitude") as? String{
                            if let placeLatitudeDouble = Double(placeLatitude){
                                self.choosenLatitude = placeLatitudeDouble
                            }
                            
                        }
                        if let placeLongitude = choosenPlaceObject.object(forKey: "longitude") as? String{
                            if let placeLongitudeDouble = Double(placeLongitude){
                                self.choosenLongitude = placeLongitudeDouble
                            }
                            
                        }
                        
                        if let imageData = choosenPlaceObject.object(forKey: "image") as? PFFileObject{
                            imageData.getDataInBackground { data, error in
                                if error == nil {
                                    if data != nil {
                                        self.detayİmageView.image = UIImage(data: data!)
                                    }
                                    
                                }
                            }
                        }
                        
                        //Harita detaylarını alma
                        let location = CLLocationCoordinate2D(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
                        
                        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                        
                        let region = MKCoordinateRegion(center: location, span: span)
                        
                        self.detayMapView.setRegion(region, animated: true)
                        
                        //Tam lokasyonu gösterme
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.mekanAdLabel.text!
                        annotation.subtitle = self.mekanTipLabel.text!
                        
                        self.detayMapView.addAnnotation(annotation)
                    }
                }
            }
        }
    }
    //Pİn Tanımlama
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        if pinView == nil{
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        }else{
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    
    //Navigasyon
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.choosenLatitude != 0.0 && self.choosenLongitude != 0.0{
            let requestLocation = CLLocation(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks{
                    if placemark.count > 0{
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.mekanAdLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
}


