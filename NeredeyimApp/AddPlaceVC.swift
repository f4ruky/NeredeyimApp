//
//  AddPlaceVC.swift
//  NeredeyimApp
//
//  Created by Faruk Yaşar on 23.01.2023.
//

import UIKit

class AddPlaceVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mekanAdiText: UITextField!
    @IBOutlet weak var mekanTipiText: UITextField!
    @IBOutlet weak var mekanTanıtımText: UITextField!
    @IBOutlet weak var imageViewPlace: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageViewPlace.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseİmage))
        imageViewPlace.addGestureRecognizer(gestureRecognizer)
    }
    

    @IBAction func ileriButton(_ sender: Any) {
        if mekanAdiText.text != "" && mekanTipiText.text != "" && mekanTanıtımText.text != ""{
            
            if let choosenImage = imageViewPlace.image{
                let placeModel = PlaceModel.sharedInstance
                placeModel.MekanAdi = mekanAdiText.text!
                placeModel.MekanTipi = mekanTipiText.text!
                placeModel.MekanTanıtım = mekanTanıtımText.text!
                placeModel.MekanResim  = choosenImage
            }
            
            performSegue(withIdentifier: "toMapVC", sender: nil)
        }else{
            let alert = UIAlertController(title: "Error", message: "Yer Adı/ Tipi / Tanıtım ?", preferredStyle: UIAlertController.Style.alert)
            
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
        }
        
        
    }
    @objc func chooseİmage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageViewPlace.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
}
