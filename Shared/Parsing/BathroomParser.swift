//
//  WCParser.swift
//  TestyMcTestenstein
//
//  Created by Mario Schreiner on 17.01.20.
//  Copyright © 2020 Mario Schreiner. All rights reserved.
//

import Foundation
import CoreLocation

class BathroomParser {
    
    public class func parse() -> [Bathroom] {
        var bathrooms: [Bathroom] = []
        
        let stream = InputStream(fileAtPath: Bundle.main.url(forResource: "bathrooms", withExtension: "csv")!.path)!
        let csv = try! CSVReader(stream: stream, hasHeaderRow: true)
        let decoder = CSVRowDecoder()
        
        while let _ = csv.next() {
            let bathroom = try! decoder.decode(Bathroom.self, from: csv)
            bathrooms.append(bathroom)
        }
        
        return bathrooms
    }
    
//    public class func geocode() {
//        DispatchQueue.global(qos: .background).async {
//        let geoCoder = CLGeocoder()
//        
//        let stream = OutputStream(toFileAtPath: "/Users/blackwolf/Desktop/bla.csv", append: false)!
//        let csv = try! CSVWriter(stream: stream)
//        let streamin = InputStream(fileAtPath: Bundle.main.url(forResource: "wc", withExtension: "csv")!.path)!
//        let csvin = try! CSVReader(stream: streamin, hasHeaderRow: true)
//        
//        try! csv.write(row: csvin.headerRow! + ["latitude", "longitude"])
//        
//        
//        let group = DispatchGroup()
//        while let row = csvin.next() {
//            group.enter()
//            sleep(1)
//            let address = "\(csvin["adresse"]!), \(csvin["plz"]!) \(csvin["ort"]!), Schweiz"
//            geoCoder.geocodeAddressString(address) { (placemarks, error) in
//                guard
//                    let placemarks = placemarks,
//                    let location = placemarks.first?.location
//                else {
//                    // handle no location found
//                    return
//                }
//                
//                
//                try! csv.write(row: row + ["\(location.coordinate.latitude)", "\(location.coordinate.longitude)"])
//                print(location)
//                group.leave()
//            }
//            
////            break
////            let wc = try! decoder.decode(WC.self, from: csvin)
////            wcs.append(wc)
//        }
//        
//        group.notify(queue: .main) {
//            csv.stream.close()
//        }
//        }
//    }
    
}
