//
//  MemberObject.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/17/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import Foundation

class MemberObject: NSObject
{
    var accountID            : String       = ""
    var enableWeightGoal     : Bool         = false
    var birthday             : String       = ""
    var currentHeight        : String       = ""
    var enableBloodPressure  : Bool         = false
    var enableHeight         : Bool         = false
    var enablePedometer      : Bool         = false
    var enableWeight         : Bool         = false
    var firstName            : String       = ""
    var gender               : Int          = 0
    var isMembershipDeleted  : Bool         = false
    var memberID             : String       = ""
    var pictureURL           : String       = ""
    var startWeight          : String       = ""
    var weightGoal           : String       = ""
}
