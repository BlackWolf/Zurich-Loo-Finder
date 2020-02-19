//
//  HostingController.swift
//  SeeIT WatchKit Extension
//
//  Created by Mario Schreiner on 04.02.20.
//  Copyright © 2020 Mario Schreiner. All rights reserved.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<ContentView> {
    override var body: ContentView {
        return ContentView(bathrooms: BathroomParser.parse())
    }
}
