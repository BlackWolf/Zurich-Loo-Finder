//
//  TransferManager.swift
//  TestyMcTestenstein
//
//  Created by Mario Schreiner on 30.01.20.
//  Copyright © 2020 Mario Schreiner. All rights reserved.
//

import Foundation
import WatchConnectivity
import Combine

class TransferManager: NSObject, WCSessionDelegate, ObservableObject {
    
    static let shared = TransferManager()
    
    private let session = WCSession.default
    
    var applicationContext: [String: Any] {
        return self.session.receivedApplicationContext
    }
    
    override init() {
        super.init()
        self.session.delegate = self
        self.trySessionActivation()
    }
    
    private func trySessionActivation() {
        guard WCSession.isSupported() else {
            print("Watch Connectivity is not supported on this device")
            return
        }
        
        self.session.activate()
    }
    
    func updateApplicationContext(_ newContext: [String: Any]) {
        guard self.session.activationState == .activated else {
            return
        }
        
        try? self.session.updateApplicationContext(newContext)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        DispatchQueue.main.sync {
            self.objectWillChange.send()
        }
    }
    
    
    
    
    
    // MARK: - WCSessionDelegate

    // MARK: Session Management
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        guard error == nil else {
            print(error!)
            return
        }

        guard activationState == .activated else {
            print("WCSession activation failed")
            return
        }

        #if os(iOS)
            guard self.session.isPaired else {
                print("No watch is paired!")
                return
            }

            guard self.session.isWatchAppInstalled else {
                print("The watch app is not installed")
                return
            }
        #endif
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    #endif
    
    #if os(iOS)
    func sessionDidDeactivate(_ session: WCSession) {
        //Might happen if the user switches watches
        self.trySessionActivation()
    }
    #endif
    
}
