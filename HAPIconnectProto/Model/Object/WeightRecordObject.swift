//
//  WeightRecordObject.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/17/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit

class WeightRecordObject: NSObject
{
    var accountID            : String           = ""
    var basalMetabolism      : Int              = 0
    var bmiValue             : Float            = 0.0
    var bodyWaterValue       : Float            = 0.0
    var boneValue            : Float            = 0.0
    var deviceID             : String           = ""
    var deviceSn             : String           = ""
    var isWeightRecordDeleted : Bool            = false
    var measurementDate      : String           = ""
    var measurementDateTimeStamp : Date         = Date()
    var memberID             : String           = ""
    var muscleValue          : Float            = 0.0
    var pbfstate             : Int              = 0
    var pbfValue             : Float            = 0.0
    var remark               : String           = ""
    var resistance           : Int              = 0
    var visceralFatLevel     : Int              = 0
    var weight_date          : String           = ""
    var weight_state         : WEIGHTSTATE      = WeightRecordObject.WEIGHTSTATE(rawValue: WEIGHTSTATE.NONE.rawValue)!
    var weightRecordID       : String           = ""
    var weightValue          : Float            = 0.0
    var wtstate              : Int              = 0
    
    enum WEIGHTSTATE: Int
    {
        case NONE = 0 , WEIGHT_ADD_ONGOING = 1, WEIGHT_UPDATE_ONGOING = 2, WEIGHT_DELETED = 3, WEIGHT_SYNC = 4, WEIGHT_FAILED = 5
    }
}
