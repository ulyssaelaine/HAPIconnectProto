//
//  DeviceBindingObject.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/17/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import Foundation

class DeviceBindingObject: NSObject
{
    var isDeviceDeleted      : Bool             = false
    var accountID            : String           = ""
    var broadcast            : String           = ""
    var deviceBindingID      : String           = ""
    var deviceID             : String           = ""
    var deviceSn             : String           = ""
    var mac                  : String           = ""
    var memberID             : String           = ""
    var password             : String           = ""
    var serviceNo            : String           = ""
    var deviceUserNo         : Int              = 0
    var maxUserQuantity      : Int              = 0
}
