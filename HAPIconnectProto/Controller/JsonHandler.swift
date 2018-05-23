//
//  JsonHandler.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/10/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit
import SSZipArchive

class JsonHandler: NSObject
{
    // MARK: - Shared Instance
    
    static let sharedInstance : JsonHandler =
    {
        let instance = JsonHandler()
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init()
    {
        super.init()
    }
    
    // MARK: - Login
    
    func getLoginResponse(response: NSDictionary) -> Bool
    {
        let responseCode : Int = response["responseCode"] as! Int
        
        if responseCode == 200
        {
            /* Successful */
            
            let sessionId : String = response["sessionId"] as! String
            let accessToken : String = response["accessToken"] as! String
            
            UserDefaults.standard.set(sessionId, forKey: "sessionId")
            UserDefaults.standard.set(accessToken, forKey: "accessToken")
            
            return true
        }
        else
        {
            return false
        }
    }
    
    // MARK: - Sync
    
    func getSyncResponse(response: NSDictionary) -> Bool
    {
        let responseCode : Int = response["responseCode"] as! Int
        
        if responseCode == 200
        {
            /* Successful */
            
            DispatchQueue.main.async
            {
                let fileURLString : String = response["fileUrl"] as! String
                
                let request     = URLRequest(url: URL(string:fileURLString)!)
                let config      = URLSessionConfiguration.default
                let session     = URLSession(configuration: config)
                
                let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
                    
                    if error == nil
                    {
                        let cachesDirectory : NSArray   = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as NSArray
                        let directoryPath   : NSString  = cachesDirectory[0] as! NSString
                        let zipPath         : String    = directoryPath.appendingPathComponent("Archive.zip") as String
                        let unZipPath       : String    = directoryPath.appendingPathComponent("Archive.json") as String
                        
                        let fileManager     = FileManager()
                        
                        if let fileManagerDir   = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first
                        {
                            let zipFileURL      = fileManagerDir.appendingPathComponent("Archive.zip")
                            let destinationPath = fileManagerDir.appendingPathComponent("Archive.json")
                            
                            do
                            {
                                /* Write Zip File */
                                
                                try data?.write(to: zipFileURL, options: Data.WritingOptions.atomicWrite)
                                
                                /* Create Directory named Archive.json */
                                
                                try fileManager.createDirectory(at: destinationPath, withIntermediateDirectories: true, attributes: nil)
                                
                                if SSZipArchive.unzipFile(atPath: zipPath, toDestination: unZipPath)
                                {
                                    do
                                    {
                                        /* Zip File inside Archive.json Directory */
                                        
                                        try SSZipArchive.unzipFile(atPath: zipPath, toDestination: unZipPath, overwrite: true, password: nil)
                                        
                                        /* Get Files inside Archive.json Folder */
                                        
                                        let directoryContents = try fileManager.contentsOfDirectory(at: destinationPath, includingPropertiesForKeys: nil, options: [])
                                        
                                        /* Get json files */
                                        
                                        let jsonFiles = directoryContents.filter{ $0.pathExtension == "json" }
                                        
                                        /* Read Last File */
                                        
                                        let data = try Data(contentsOf: jsonFiles.last!, options: Data.ReadingOptions.mappedIfSafe)
                                        
                                        /* Read Json File */
                                        
                                        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String:Any]
                                        
                                        print("jsonResult: \(jsonResult)")
                                        
                                        /* ----- Account Object ----- */
                                        
                                        let account = jsonResult["account"] as! NSDictionary
                                        let accountObj : AccountObject = self.getAccount(account: account)
                                        
                                        if StorageManager.sharedInstance.accountEntryExists(accountObj: accountObj)
                                        {
                                            StorageManager.sharedInstance.updateObject(obj: accountObj)
                                        }
                                        else
                                        {
                                            let addAccount : AccountEntity  = StorageManager.sharedInstance.addObject(obj: accountObj) as! AccountEntity
                                            let getAccount : AccountObject  = StorageManager.sharedInstance.getAccountManagedObject(accountManagedObject: addAccount)
                                            
                                            print("account: \(getAccount)")
                                        }
                                        
                                        /* ----- Member Object ----- */
                                        
                                        let member = jsonResult["member"] as! NSArray
                                        let firstMember = member.firstObject as! NSDictionary
                                        let memberObj   : MemberObject  = self.getMember(member: firstMember)
                                        
                                        if StorageManager.sharedInstance.memberEntryExists(memberObj: memberObj)
                                        {
                                            StorageManager.sharedInstance.updateObject(obj: memberObj)
                                        }
                                        else
                                        {
                                            let addMember   : MemberEntity  = StorageManager.sharedInstance.addObject(obj: memberObj) as! MemberEntity
                                            let getMember   : MemberObject  = StorageManager.sharedInstance.getMemberManagedObject(memberManagedObject: addMember)
                                            
                                            print("member: \(getMember)")
                                        }
                                        
                                        /* ----- Device Object ----- */
                                        
                                        if let devices = jsonResult["devices"] as? NSArray
                                        {
                                            for deviceTemp in devices
                                            {
                                                let deviceDict  = deviceTemp as! NSDictionary
                                                let deviceObj   : DeviceObject = self.getDevice(device: deviceDict)
                                                
                                                if StorageManager.sharedInstance.deviceEntryExists(deviceObj: deviceObj)
                                                {
                                                    StorageManager.sharedInstance.updateObject(obj: deviceObj)
                                                }
                                                else
                                                {
                                                    let addDevice   : DeviceEntity  = StorageManager.sharedInstance.addObject(obj: deviceObj) as! DeviceEntity
                                                    let getDevice   : DeviceObject  = StorageManager.sharedInstance.getDeviceManagedObject(deviceManagedObject: addDevice)
                                                    
                                                    print("devices: \(getDevice)")
                                                }
                                            }
                                        }
                                        
                                        /* ----- Device Binding Object ----- */
                                        
                                        if let deviceBindings = jsonResult["deviceBindings"] as? NSArray
                                        {
                                            for deviceTemp in deviceBindings
                                            {
                                                let deviceDict  = deviceTemp as! NSDictionary
                                                let deviceObj   : DeviceBindingObject = self.getDeviceBinding(deviceBinding: deviceDict)
                                                
                                                if StorageManager.sharedInstance.deviceBindingEntryExists(deviceBindingObj: deviceObj)
                                                {
                                                    StorageManager.sharedInstance.updateObject(obj: deviceObj)
                                                }
                                                else
                                                {
                                                    let addDevice   : DeviceBindingEntity  = StorageManager.sharedInstance.addObject(obj: deviceObj) as! DeviceBindingEntity
                                                    let getDevice   : DeviceBindingObject  = StorageManager.sharedInstance.getDeviceBindingManagedObject(deviceBindingManagedObject: addDevice)
                                                    
                                                    print("binding devices: \(getDevice)")
                                                }
                                            }
                                        }
                                        
                                        /* ----- Weight Record Object ----- */
                                        
                                        if let weightRecords = jsonResult["weightRecords"] as? NSArray
                                        {
                                            for weightRecordsTemp in weightRecords
                                            {
                                                let weightRecordDict    = weightRecordsTemp as! NSDictionary
                                                let weightRecordObj     : WeightRecordObject = self.getWeightRecordObj(weightRecordObj: weightRecordDict)
                                                
                                                if StorageManager.sharedInstance.weightEntryExists(weightRecordObj: weightRecordObj)
                                                {
                                                    StorageManager.sharedInstance.updateObject(obj: weightRecordObj)
                                                }
                                                else
                                                {
                                                    let addWeight   : WeightRecordEntity    = StorageManager.sharedInstance.addObject(obj: weightRecordObj) as! WeightRecordEntity
                                                    let getWeight   : WeightRecordObject   = StorageManager.sharedInstance.getWeightRecordManagedObject(weightRecordManagedObject: addWeight)
                                                    
                                                    print("weight: \(getWeight)")
                                                }
                                            }
                                        }
                                        
                                    }
                                    catch
                                    {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                            catch
                            {
                                print(error.localizedDescription)
                            }
                            
                        }
                    }
                    
                });
                
                task.resume()
            }
            
            return true
        }
        else
        {
            return false
        }
    }
    
    // MARK: - Account
    
    func getAccount(account: NSDictionary) -> AccountObject
    {
        let accountObj = AccountObject()
        
        if let accountID = account["id"] as? String
        {
            accountObj.accountID = "\(accountID)"
            
            UserDefaults.standard.set(accountObj.accountID, forKey: "accountID")
        }
        
        if let userName = account["username"] as? String
        {
            accountObj.userName = userName
        }
        
        if let email = account["email"] as? String
        {
            accountObj.email = email
        }
        
        if let mobileNum = account["mobile"] as? String
        {
            accountObj.mobileNum = mobileNum
        }
        
        if let name = account["name"] as? String
        {
            accountObj.firstName = name
        }
        
        if let accountProfile = account["accountProfile"] as? NSDictionary
        {
            if let weightUnit = accountProfile["weightUnit"] as? String
            {
                accountObj.weightUnit = weightUnit
            }
            
            if let heightUnit = accountProfile["heightUnit"] as? String
            {
                accountObj.heightUnit = heightUnit
            }
            
            if let bpUnit = accountProfile["bpUnit"] as? String
            {
                accountObj.bpUnit = bpUnit
            }
        }
        
        return accountObj
    }
    
    // MARK: - Member
    
    func getMember(member: NSDictionary) -> MemberObject
    {
        let memberObj = MemberObject()
        
        if let memberID = member["id"] as? String
        {
            memberObj.memberID = "\(memberID)"
            
            UserDefaults.standard.set(memberObj.memberID, forKey: "memberID")
        }
        
        if let accountID = member["accountId"] as? String
        {
            memberObj.accountID = "\(accountID)"
        }
        
        if let name = member["name"] as? String
        {
            memberObj.firstName = name
        }
        
        if let birthday = member["birthday"] as? String
        {
            memberObj.birthday = birthday
        }
        
        if let gender = member["sex"] as? Int64
        {
            memberObj.gender = Int(gender)
        }
        
        if let deleted = member["deleted"] as? Int64
        {
            memberObj.isMembershipDeleted = deleted.boolValue
        }
        
        if let memberProfile = member["memberProfile"] as? NSDictionary
        {
            if let weightGoal = memberProfile["weightGoal"] as? String
            {
                memberObj.weightGoal = weightGoal
            }
            
            if let weight = memberProfile["weight"] as? String
            {
                memberObj.startWeight = weight
            }
            
            if let enablePedometer = memberProfile["enablePedometer"] as? String
            {
                memberObj.enablePedometer = Bool(enablePedometer)!
            }
            
            if let enableBloodPressure = memberProfile["enableBloodPressure"] as? String
            {
                memberObj.enableBloodPressure = Bool(enableBloodPressure)!
            }
            
            if let height = memberProfile["height"] as? String
            {
                memberObj.currentHeight = height
            }
            
            if let pictureUrl = memberProfile["pictureUrl"] as? String
            {
                memberObj.pictureURL = pictureUrl as String
            }
            
            if let enableWeight = memberProfile["enableWeight"] as? String
            {
                memberObj.enableWeight = Bool(enableWeight)!
            }
            
            if let enableWeightGoal = memberProfile["enableWeightGoal"] as? String
            {
                memberObj.enableWeightGoal = Bool(enableWeightGoal)!
            }
            
            if let enableHeight = memberProfile["enableHeight"] as? String
            {
                memberObj.enableHeight = Bool(enableHeight)!
            }
        }
        
        return memberObj
    }
    
    // MARK: - Devices
    
    func getDevice(device: NSDictionary) -> DeviceObject
    {
        let deviceObject = DeviceObject()
        
        if let deviceID = device["id"] as? String
        {
            deviceObject.deviceID = deviceID
        }
        
        if let deviceSn = device["sn"] as? String
        {
            deviceObject.deviceSn = deviceSn
        }
        
        if let mac = device["mac"] as? String
        {
            deviceObject.mac = mac
        }
        
        if let qrcode = device["qrcode"] as? String
        {
            deviceObject.deviceQRCode = qrcode
        }
        
        if let deviceType = device["deviceType"] as? String
        {
            deviceObject.deviceType = Int(deviceType)!
        }
        
        if let deviceName = device["deviceName"] as? String
        {
            deviceObject.deviceName = deviceName
        }
        
        if let maxUserQuantity = device["maxUserQuantity"] as? Int64
        {
            deviceObject.maxUserQuantity = Int(maxUserQuantity)
        }
        
        if let communicationType = device["communicationType"] as? Int64
        {
            deviceObject.communicationType = Int(communicationType)
        }
        
        if deviceObject.communicationType == 4
        {
            deviceObject.protocolType = "A2"
        }
        else if deviceObject.communicationType == 5
        {
            deviceObject.protocolType = "A3"
        }
        else if deviceObject.communicationType == 6
        {
            deviceObject.protocolType = "A4"
        }
        
        if let modelNum = device["modelNum"] as? String
        {
            deviceObject.modelNum = modelNum
        }
        
        if let picture = device["picture"] as? String
        {
            deviceObject.picture = picture
        }
        
        return deviceObject
    }
    
    // MARK: - Device Binding
    
    func getDeviceBinding(deviceBinding: NSDictionary) -> DeviceBindingObject
    {
        let deviceBindingObject = DeviceBindingObject()
        
        if let deviceBindingID  = deviceBinding["id"] as? String
        {
            deviceBindingObject.deviceBindingID = deviceBindingID
        }
        
        if let accountID  = deviceBinding["accountId"] as? String
        {
            deviceBindingObject.accountID = accountID
        }
        
        if let memberID  = deviceBinding["memberId"] as? String
        {
            deviceBindingObject.memberID = memberID
        }
        
        if let mac  = deviceBinding["mac"] as? String
        {
            deviceBindingObject.mac = mac
        }
        
        if let password = deviceBinding["password"] as? String
        {
            deviceBindingObject.password = password
        }
        
        if let serviceNo  = deviceBinding["serviceNo"] as? String
        {
            deviceBindingObject.serviceNo = serviceNo
        }
        
        if let deviceID  = deviceBinding["deviceId"] as? String
        {
            deviceBindingObject.deviceID = deviceID
        }
        
        if let deviceSn  = deviceBinding["deviceSn"] as? String
        {
            deviceBindingObject.deviceSn = deviceSn
        }
        
        if let userNo  = deviceBinding["userNo"] as? Int64
        {
            deviceBindingObject.deviceUserNo = Int(userNo)
        }
        
        if let broadcast  = deviceBinding["broadcast"] as? String
        {
            deviceBindingObject.broadcast = broadcast
        }
        
        if let deleted  = deviceBinding["deleted"] as? Int64
        {
            deviceBindingObject.isDeviceDeleted = deleted.boolValue
        }
        
        return deviceBindingObject
    }
    
    // MARK: - Weight Record Obj
    
    func getWeightRecordObj(weightRecordObj: NSDictionary) -> WeightRecordObject
    {
        let weightRecordObject = WeightRecordObject()
        
        if let weightRecordID  = weightRecordObj["id"] as? String
        {
            weightRecordObject.weightRecordID = weightRecordID
        }
        
        if let accountId  = weightRecordObj["accountId"] as? String
        {
            weightRecordObject.accountID = accountId
        }
        
        if let memberId  = weightRecordObj["memberId"] as? String
        {
            weightRecordObject.memberID = memberId
        }
        
        if let deviceId  = weightRecordObj["deviceId"] as? String
        {
            weightRecordObject.deviceID = deviceId
        }
        
        if let deviceSn  = weightRecordObj["deviceSn"] as? String
        {
            weightRecordObject.deviceSn = deviceSn
        }
        
        if let measurementDate  = weightRecordObj["measurementDate"] as? String
        {
            weightRecordObject.measurementDate = measurementDate
            
            weightRecordObject.measurementDateTimeStamp = CalendarUtil.sharedInstance.getDateFromString(weightRecordObject.measurementDate)
            
            let dateArray = measurementDate.components(separatedBy: " ")
            
            weightRecordObject.weight_date = dateArray.first!
        }
        
        if let weightValue  = weightRecordObj["weight"] as? Float
        {
            weightRecordObject.weightValue = weightValue
        }
        
        if let bmiValue  = weightRecordObj["bmi"] as? Float
        {
            weightRecordObject.bmiValue = bmiValue
        }
        
        if let pbfValue  = weightRecordObj["pbf"] as? Float
        {
            weightRecordObject.pbfValue = pbfValue
        }
        
        if let wtstate  = weightRecordObj["wtstate"] as? Int64
        {
            weightRecordObject.wtstate = Int(wtstate)
        }
        
        if let pbfstate  = weightRecordObj["pbfstate"] as? Int64
        {
            weightRecordObject.pbfstate = Int(pbfstate)
        }
        
        if let resistance  = weightRecordObj["resistance"] as? Int64
        {
            weightRecordObject.resistance = Int(resistance)
        }
        
        if let bodyWaterValue  = weightRecordObj["bodyWater"] as? Float
        {
            weightRecordObject.bodyWaterValue = bodyWaterValue
        }
        
        if let muscleValue  = weightRecordObj["muscle"] as? Float
        {
            weightRecordObject.muscleValue = muscleValue
        }
        
        if let boneValue  = weightRecordObj["bone"] as? Float
        {
            weightRecordObject.boneValue = boneValue
        }
        
        if let remark  = weightRecordObj["remark"] as? String
        {
            weightRecordObject.remark = remark
        }
        
        if let isWeightRecordDeleted  = weightRecordObj["deleted"] as? Int64
        {
            weightRecordObject.isWeightRecordDeleted = isWeightRecordDeleted.boolValue
        }
        
        weightRecordObject.weight_state = WeightRecordObject.WEIGHTSTATE.WEIGHT_SYNC
        
        return weightRecordObject
    }
}
