//
//  ConnectionManager.swift
//  iyzicoSDK
//
//  Created by Vural Çelik on 4.03.2021.
//

import Foundation

class ConnectionManager {
    
    static func getIPAddressForCellOrWireless()-> String? {

        let WIFI_IF : [String] = ["en0"]
        let KNOWN_WIRED_IFS : [String] = ["en2", "en3", "en4"]
        let KNOWN_CELL_IFS : [String] = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]

        var addresses : [String : String] = ["wireless":"",
                                             "wired":"",
                                             "cell":""]

        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {

            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next } // memory has been renamed to pointee in swift 3 so changed memory to pointee

                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    let name: String = String(cString: (interface?.ifa_name)!)
                    if (WIFI_IF.contains(name) || KNOWN_WIRED_IFS.contains(name) || KNOWN_CELL_IFS.contains(name)) {

                        // String.fromCString() is deprecated in Swift 3. So use the following code inorder to get the exact IP Address.
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                        if WIFI_IF.contains(name){
                            addresses["wireless"] =  address
                        }else if KNOWN_WIRED_IFS.contains(name){
                            addresses["wired"] =  address
                        }else if KNOWN_CELL_IFS.contains(name){
                            addresses["cell"] =  address
                        }
                    }

                }
            }
        }
        freeifaddrs(ifaddr)

        var ipAddressString : String?
        let wirelessString = addresses["wireless"]
        let wiredString = addresses["wired"]
        let cellString = addresses["cell"]
        if let wirelessString = wirelessString, wirelessString.count > 0{
            ipAddressString = wirelessString
        }else if let wiredString = wiredString, wiredString.count > 0{
            ipAddressString = wiredString
        }else if let cellString = cellString, cellString.count > 0{
            ipAddressString = cellString
        }
        return ipAddressString
    }
}
