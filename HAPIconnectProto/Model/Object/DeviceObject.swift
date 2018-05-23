//
//  DeviceObject.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/17/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import Foundation

class DeviceObject: NSObject
{
    var deviceID             : String           = ""
    var deviceName           : String           = ""
    var deviceQRCode         : String           = ""
    var deviceSn             : String           = ""
    var deviceType           : Int              = 0
    var mac                  : String           = ""
    var modelNum             : String           = ""
    var picture              : String           = ""
    var protocolType         : String           = ""
    var communicationType    : Int              = 0
    var maxUserQuantity      : Int              = 0
}
