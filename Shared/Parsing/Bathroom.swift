//
//  WC.swift
//  TestyMcTestenstein
//
//  Created by Mario Schreiner on 17.01.20.
//  Copyright © 2020 Mario Schreiner. All rights reserved.
//

import Foundation
import CoreLocation

struct Bathroom: Codable, Identifiable, Equatable, Hashable {
    
    var id: String {
        return self.address
    }
    
    let costDescription: String
    let address: String
    let longitude: Double
    let latitude: Double
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        let ourLocation = CLLocation(latitude: latitude, longitude: longitude)
        return ourLocation.distance(from: location)
    }
    
    enum CodingKeys: String, CodingKey {
        case costDescription = "gebuehren"
        case address = "adresse"
        case longitude
        case latitude
    }
    
}
