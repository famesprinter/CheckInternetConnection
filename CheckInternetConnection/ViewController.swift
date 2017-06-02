//
//  ViewController.swift
//  CheckInternetConnection
//
//  Created by Kittitat Rodphotong on 6/2/2560 BE.
//  Copyright © 2560 Kittitat Rodphotong. All rights reserved.
//

import UIKit
import SystemConfiguration

class ViewController: UIViewController {
    // MARK: Variable
    

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("IS INTERNET CONNECTION: \(isInternetAvailable())")
    }
    
    func isInternetAvailable() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}

