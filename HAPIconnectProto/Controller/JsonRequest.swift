//
//  JsonRequest.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/10/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit

class JsonRequest: NSObject
{
    // MARK: - Shared Instance
    
    static let sharedInstance : JsonRequest =
    {
        let instance = JsonRequest()
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init()
    {
        super.init()
    }
    
    // MARK: - Login Parameters
    
    func loginUserJson(loginName: String, app : String, carrier : String, loginType : Int, clientId : String) -> NSMutableDictionary
    {
        let main                    = NSMutableDictionary()
        main["app"]                 = app
        main["carrier"]             = carrier
        main["loginname"]           = loginName
        main["clientId"]            = clientId
        main["loginType"]           = NSNumber(integerLiteral: loginType)
        
        return main
    }
    
    // MARK: - Download Path
    
    func downloadData() -> NSMutableDictionary
    {
        let main                    = NSMutableDictionary()
        main["ts"]                  = 0
        return main
    }
    
    // MARK: - Add Device
    
    func addDevice(_ protocolType : String) -> NSMutableDictionary
    {
        let deviceObj : DeviceObject = StorageManager.sharedInstance.getDeviceByProtocolType(protocolType: protocolType as String)
        
        let main                    = NSMutableDictionary()
        main["communicationType"]   = deviceObj.communicationType
        main["deviceName"]          = deviceObj.deviceName.replacingOccurrences(of: " ", with: "")
        main["deviceType"]          = String(format:"0%d",deviceObj.deviceType)
        main["id"]                  = deviceObj.deviceID
        main["mac"]                 = deviceObj.mac
        main["maxUserQuantity"]     = deviceObj.maxUserQuantity
        main["modelNum"]            = deviceObj.modelNum
        main["picture"]             = deviceObj.picture
        main["qrcode"]              = deviceObj.deviceQRCode
        main["sn"]                  = deviceObj.deviceSn
        
        return main
    }
    
    // MARK: - Bind Device
    
    func bindDevice(_ deviceBindings : NSArray) -> NSMutableDictionary
    {
        var deviceBindingArray : NSArray = NSArray()
        
        for i in 0..<deviceBindings.count
        {
            let deviceBind : DeviceBindingObject = deviceBindings[i] as! DeviceBindingObject
            
            let main                = NSMutableDictionary()
            main["accountId"]       = deviceBind.accountID
            main["broadcast"]       = deviceBind.broadcast
            main["deleted"]         = String(format:"%d",deviceBind.isDeviceDeleted ? 1 : 0)
            main["deviceId"]        = deviceBind.deviceID
            main["deviceSn"]        = deviceBind.deviceSn
            main["id"]              = String().UUIDString()
            main["mac"]             = ""
            main["memberId"]        = deviceBind.memberID
            main["password"]        = deviceBind.password
            main["serviceNo"]       = ""
            main["userNo"]          = deviceBind.deviceUserNo
            
            deviceBindingArray      = deviceBindingArray.adding(main) as NSArray
        }
        
        let main                    = NSMutableDictionary()
        main["deviceBinding"]       = deviceBindingArray
        
        return main
    }
    
    // MARK: - Unbind Device
    
    func unbindDevice(_ deviceID : String, userNum : Int, memberID : String) -> NSMutableDictionary
    {
        let main                    = NSMutableDictionary()
        main["deviceId"]            = deviceID
        main["userNo"]              = NSNumber.init(value: userNum)
        main["memberId"]            = memberID
        
        return main
    }
    
    // MARK: - Add / Edit Weight
    
    func addWeight(_ weightRecordObj : WeightRecordObject) -> NSMutableDictionary
    {
        let main                    = NSMutableDictionary()
        main["accountId"]           = weightRecordObj.accountID
        main["bmi"]                 = weightRecordObj.bmiValue
        main["bodyWater"]           = weightRecordObj.bodyWaterValue
        main["bone"]                = weightRecordObj.boneValue
        main["deviceId"]            = weightRecordObj.deviceID
        main["deviceSn"]            = weightRecordObj.deviceSn
        main["id"]                  = String().UUIDString()
        main["measurementDate"]     = weightRecordObj.measurementDate
        main["memberId"]            = weightRecordObj.memberID
        main["muscle"]              = weightRecordObj.muscleValue
        main["pbf"]                 = weightRecordObj.pbfValue
        main["pbfstate"]            = String(format:"%d",weightRecordObj.pbfstate)
        main["resistance"]          = weightRecordObj.resistance
        main["weight"]              = weightRecordObj.weightValue
        
        return main
    }
    
    // MARK: - Delete Weight
    
    func deleteWeight(_ weightRecordObj : WeightRecordObject) -> NSMutableDictionary
    {
        let main                    = NSMutableDictionary()
        main["id"]                  = weightRecordObj.weightRecordID
        return main
    }
}
