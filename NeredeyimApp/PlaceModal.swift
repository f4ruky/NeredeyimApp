//
//  PlaceModal.swift
//  NeredeyimApp
//
//  Created by Faruk Yaşar on 23.01.2023.
//

import Foundation
import UIKit

class PlaceModel{
    static let sharedInstance = PlaceModel()
    
    var MekanAdi = ""
    var MekanTipi = ""
    var MekanTanıtım = ""
    var MekanResim = UIImage()
    var Latitude = ""
    var Longitude = ""
    
    private init(){}
}
