//
//  ViewController.swift
//  NeredeyimApp
//
//  Created by Faruk Yaşar on 22.01.2023.
//

import UIKit
import Parse


class SignUpVC: UIViewController {

    @IBOutlet weak var KullanıcıAdi: UITextField!
    
    @IBOutlet weak var Parola: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
        
    }

    @IBAction func GirisYapButton(_ sender: Any) {
        if KullanıcıAdi.text != "" && Parola.text != ""{
            
            PFUser.logInWithUsername(inBackground: KullanıcıAdi.text!, password: Parola.text!) { user, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error!!")
                }else{
                    //Segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        }else{
            makeAlert(titleInput: "Error", messageInput: "Kullanıcı Adı / Parola?")
        }
    }
    
    @IBAction func KaydolButton(_ sender: Any) {
        if KullanıcıAdi.text != "" && Parola.text != ""{
            
            let user = PFUser()
            user.username = KullanıcıAdi.text!
            user.password = Parola.text!
            
            user.signUpInBackground{(success, error) in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error!!")
                }
                else{
                    //Segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
        }else{
            makeAlert(titleInput: "Error", messageInput: "Kullanıcı Adı / Parola? ")
        }
    }
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

