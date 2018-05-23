//
//  AppUtil.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/10/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit

class AppUtil: NSObject
{
    // MARK: - Shared Instance
    
    static let sharedInstance : AppUtil =
    {
        let instance = AppUtil()
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init()
    {
        super.init()
    }
    
    // MARK: - Get URLs
    
    func getDomainURLString() -> NSString
    {
        return "http://hapi.lhealthcenter.com/healthcenter-personal/" as NSString
    }
    
    func loginPathString() -> NSString
    {
        return "personal/account_service/login" as NSString
    }
    
    func logoutPathString() -> NSString
    {
        return "personal/account_service/logout" as NSString
    }
    
    func downloadPathString() -> NSString
    {
        return "personal/sync_record_service/download" as NSString
    }
    
    func uploadPathString() -> NSString
    {
        return "personal/sync_record_service/upload" as NSString
    }
    
    func addDevicePath() -> NSString
    {
        return "personal/device_service/add_device" as NSString
    }
    
    func bindDevicePath() -> NSString
    {
        return "personal/device_service/bind_device" as NSString
    }
    
    func unbindDevicePath() -> NSString
    {
        return "personal/device_service/unbind_device" as NSString
    }
    
    func pedometerSavePath() -> NSString
    {
        return "personal/pedometer_record_service/save" as NSString
    }
    
    func pedometerDeletePath() -> NSString
    {
        return "personal/pedometer_record_service/delete" as NSString
    }
    
    func weightSavePath() -> NSString
    {
        return "personal/weight_record_service/save" as NSString
    }
    
    func weightDeletePath() -> NSString
    {
        return "personal/weight_record_service/delete" as NSString
    }
    
    func bloodPressureSavePath() -> NSString
    {
        return "personal/bp_record_service/save" as NSString
    }
    
    func bloodPressureDeletePath() -> NSString
    {
        return "personal/bp_record_service/delete" as NSString
    }
    
    // MARK: - Int
    
    func getAgeBasedOnNSDate(_ date : Date) -> Int
    {
        let dateNow         = Date()
        let ageComponents   : DateComponents = Calendar.current.dateComponents([.year], from: date, to: dateNow)
        
        let age : Int       = ageComponents.year!
        
        return age
    }
    
    // MARK: - LSBluetooth Framework
    
    func getDeviceInfo(_ deviceInfo : LSDeviceInfo) -> DeviceObject
    {
        let deviceInfoObj : DeviceObject    = DeviceObject()
        
        deviceInfoObj.deviceID              = deviceInfo.deviceId
        deviceInfoObj.deviceSn              = deviceInfo.deviceSn
        deviceInfoObj.deviceName            = deviceInfo.deviceName
        
        if let modelNum : String = deviceInfo.modelNumber
        {
            deviceInfoObj.modelNum          = modelNum
        }
        else
        {
            deviceInfoObj.modelNum          = "LS405"
        }
        
        deviceInfoObj.mac                   = "<null>"
        deviceInfoObj.picture               = "<null>"
        deviceInfoObj.protocolType          = deviceInfo.protocolType
        deviceInfoObj.deviceType            = Int(deviceInfo.deviceType.rawValue)
        deviceInfoObj.maxUserQuantity       = deviceInfo.maxUserQuantity
        
        if deviceInfoObj.protocolType == "A2"
        {
            deviceInfoObj.communicationType = 4
        }
        else if deviceInfoObj.protocolType == "A3"
        {
            deviceInfoObj.communicationType = 5
        }
        else if deviceInfoObj.protocolType == "A4"
        {
            deviceInfoObj.communicationType = 6
        }
        
        return deviceInfoObj
    }
    
    func convertToDeviceInfo(_ deviceObj : DeviceObject, deviceBindingObj : DeviceBindingObject) -> LSDeviceInfo
    {
        let deviceInfo : LSDeviceInfo = LSDeviceInfo()
        
        deviceInfo.deviceId         = deviceObj.deviceID
        deviceInfo.broadcastId      = deviceBindingObj.broadcast
        deviceInfo.password         = deviceBindingObj.password
        deviceInfo.protocolType     = deviceObj.protocolType
        deviceInfo.deviceType       = self.stringToDeviceType(deviceObj.deviceType)
        deviceInfo.deviceUserNumber = UInt(deviceBindingObj.deviceUserNo)
        deviceInfo.peripheralIdentifier = deviceBindingObj.deviceBindingID
        deviceInfo.deviceName       = deviceObj.deviceName
        
        return deviceInfo
    }
    
    func getDeviceBindingInfo(_ deviceInfo : LSDeviceInfo, deviceUserNum : Int, memberObj : MemberObject) -> DeviceBindingObject
    {
        let deviceBindingObj : DeviceBindingObject  = DeviceBindingObject()
        
        deviceBindingObj.isDeviceDeleted    = false
        deviceBindingObj.accountID          = memberObj.accountID
        deviceBindingObj.broadcast          = deviceInfo.broadcastId
        deviceBindingObj.deviceID           = deviceInfo.deviceId
        deviceBindingObj.deviceSn           = deviceInfo.deviceSn
        deviceBindingObj.memberID           = memberObj.memberID
        deviceBindingObj.deviceUserNo       = deviceUserNum
        deviceBindingObj.password           = deviceInfo.password
        deviceBindingObj.maxUserQuantity    = deviceInfo.maxUserQuantity
        deviceBindingObj.deviceBindingID    = deviceInfo.peripheralIdentifier
        
        return deviceBindingObj
    }
    
    func getPedometerUserInfo(_ accountObj : AccountObject) -> LSPedometerUserInfo
    {
        let accountID   = UserDefaults.standard.value(forKey: "accountID") as? String
        
        let memberObj   : MemberObject  = StorageManager.sharedInstance.getMemberInfo(accountID: accountID!)
        
        let pedometerUserInfo : LSPedometerUserInfo = LSPedometerUserInfo()
        
        pedometerUserInfo.memberId  = memberObj.memberID
        pedometerUserInfo.userNo    = 1
        
        pedometerUserInfo.weight    = Double(memberObj.startWeight)!
        pedometerUserInfo.height    = Double(memberObj.currentHeight)!
        
        pedometerUserInfo.weightUnit = accountObj.weightUnit
        
        let birthdate : Date        = CalendarUtil.sharedInstance.getGMTDateFromString(memberObj.birthday)
        pedometerUserInfo.age       = self.getAgeBasedOnNSDate(birthdate)
        
        if memberObj.gender == 1
        {
            pedometerUserInfo.userGender = SEX_MALE
        }
        else
        {
            pedometerUserInfo.userGender = SEX_FEMALE
        }
        
        return pedometerUserInfo
    }
    
    func getWeighingScaleInfo(_ accountObj : AccountObject, userNumber : Int) -> LSProductUserInfo
    {
        let accountID   = UserDefaults.standard.value(forKey: "accountID") as? String
        
        let memberObj       : MemberObject      = StorageManager.sharedInstance.getMemberInfo(accountID: accountID!)
        
        let productUserInfo : LSProductUserInfo = LSProductUserInfo()
        
        productUserInfo.memberId    = memberObj.memberID
        productUserInfo.userNumber  = UInt(userNumber)
        
        if accountObj.weightUnit == "kg"
        {
            productUserInfo.unit = UNIT_KG
        }
        else
        {
            productUserInfo.unit = UNIT_LB
        }
        
        if memberObj.gender == 1
        {
            productUserInfo.sex = SEX_MALE
        }
        else
        {
            productUserInfo.sex = SEX_FEMALE
        }
        
        let birthdate : Date    = CalendarUtil.sharedInstance.getGMTDateFromString(memberObj.birthday)
        productUserInfo.age     = UInt(self.getAgeBasedOnNSDate(birthdate))
        
        productUserInfo.athleteLevel = 0
        
        productUserInfo.height  = Float(memberObj.currentHeight)! / 100.0
        productUserInfo.goalWeight = Float(memberObj.weightGoal)!
        
        return productUserInfo
    }
    
    func stringToDeviceType(_ deviceType : Int) -> LSDeviceType
    {
        var tempDeviceType : LSDeviceType?
        
        if deviceType == Int(LS_WEIGHT_SCALE.rawValue)
        {
            tempDeviceType = LS_WEIGHT_SCALE
        }
        else if deviceType == Int(LS_FAT_SCALE.rawValue)
        {
            tempDeviceType = LS_FAT_SCALE
        }
        else if deviceType == Int(LS_KITCHEN_SCALE.rawValue)
        {
            tempDeviceType = LS_KITCHEN_SCALE
        }
        else if deviceType == Int(LS_PEDOMETER.rawValue)
        {
            tempDeviceType = LS_PEDOMETER
        }
        else if deviceType == Int(LS_SPHYGMOMETER.rawValue)
        {
            tempDeviceType = LS_SPHYGMOMETER
        }
        else if deviceType == Int(LS_HEIGHT_MIRIAM.rawValue)
        {
            tempDeviceType = LS_HEIGHT_MIRIAM
        }
        
        return tempDeviceType!
    }
    
    func getBMIValueByHeightAndWeight(_ height : Float, weightValue : Float) -> Float
    {
        let heightValue : Float = (height*0.01)*(height*0.01)
        
        return weightValue / heightValue
    }
    
    func getAgeBasedonDate(_ date : Date) -> Int
    {
        let dateNow : Date = Date()
        
        let ageComponents : NSDateComponents = Calendar.current.dateComponents([.year], from: date, to: dateNow) as NSDateComponents
        
        return ageComponents.year
    }
    
    func muscleByWeight(_ weight : Float, fat : Float, gender : Int) -> Float
    {
        /* MALE */
        
        if gender == 1
        {
            let muscle : Float = 0.95*weight-0.0095*fat*weight-0.13
            
            return muscle
        }
            
        /* FEMALE */
            
        else if gender == 2
        {
            let muscle : Float = 1.13+0.914*weight-0.00914*fat*weight
            
            return muscle
        }
        
        return 0
    }
    
    func boneByMuscle(_ muscle : Float, gender : Int) -> Float
    {
        /* MALE */
        
        if gender == 1
        {
            let bone : Float = 0.116+0.0525*muscle
            
            return bone
        }
            
            /* FEMALE */
            
        else if gender == 2
        {
            let bone : Float = 1.22+0.0944*muscle
            
            return bone
        }
        
        return 0
    }
    
    // MARK: - Private Methods
    
    func lastURLWithToken(string : String, sessionID : String) -> NSString
    {
        let timestamp   : NSString  = self.stringFromTimestamp()
        let nonce       : NSString  = String().random as NSString
        let signature   : NSString  = self.signatureWithTokenOrPassword(string: string as NSString, timestamp: timestamp, nonce: nonce)
        var path        : NSString  = ""
        
        if sessionID.isEmpty
        {
            path = "?signature=\(signature)&timestamp=\(timestamp)&nonce=\(nonce)" as NSString
        }
        else
        {
            path = "?signature=\(signature)&timestamp=\(timestamp)&nonce=\(nonce)&sessionId=\(sessionID)" as NSString
        }
        
        return path
    }
    
    func lastURLWithTokenAndSession() -> NSString
    {
        let sessionId : String      = UserDefaults.standard.value(forKey: "sessionId") as! String
        let accessToken : String    = UserDefaults.standard.value(forKey: "accessToken") as! String
        
        let lastPath : NSString     = self.lastURLWithToken(string: accessToken as String, sessionID: sessionId as String)
        return lastPath
    }
    
    func stringFromTimestamp() -> NSString
    {
        let timestamp : NSString = NSString(format:"%.f",NSDate().timeIntervalSince1970 * 1000)
        return timestamp
    }
    
    func signatureWithTokenOrPassword(string : NSString, timestamp : NSString, nonce : NSString) -> NSString
    {
        var tmpArray : NSArray  = [string, timestamp, nonce]
        tmpArray                = tmpArray.byDiction()! as NSArray
        let signature : NSString = self.encodeSignature(tmpArray.stringOfArrayWithDiction()) as NSString
        return signature as NSString
    }
    
    func encodeSignature(_ parameters: String) -> String
    {
        let input: String = parameters
        
        let cstr = input.cString(using: String.Encoding.utf8)
        let data = NSData(bytes: cstr, length: input.count)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = digest.map { String(format: "%02x", $0) }
        
        return hexBytes.joined()
    }
    
    func md5Hash(_ paramString: String) -> String
    {
        let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5_Init(context)
        CC_MD5_Update(context, paramString, CC_LONG(paramString.lengthOfBytes(using: String.Encoding.utf8)))
        CC_MD5_Final(&digest, context)
        context.deallocate(capacity: 1)
        var hexString = ""
        for byte in digest
        {
            hexString += String(format:"%02x", byte)
        }
        
        return hexString
    }
    
    // MARK: - Delete All Core Data + NSUserDefaults
    
    func clearCoreDataAndNSUserDefaults()
    {
        /* Delete Core Data */
        
        StorageManager.sharedInstance.deleteAllAccountEntity()
        StorageManager.sharedInstance.deleteAllMemberEntity()
        StorageManager.sharedInstance.deleteAllDeviceEntity()
        StorageManager.sharedInstance.deleteAllDeviceBindingEntity()
        StorageManager.sharedInstance.deleteAllWeightRecordEntity()
        
        /* Delete UserDefaults */
        
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        UserDefaults.standard.removeObject(forKey: "sessionId")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        
        UserDefaults.standard.removeObject(forKey: "accountID")
        UserDefaults.standard.removeObject(forKey: "memberID")
        
        /* Delete Caches Directory */
        
        let cachesDirectory : NSArray   = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true) as NSArray
        let directoryPath   : NSString  = cachesDirectory[0] as! NSString
        let zipPath         : String    = directoryPath.appendingPathComponent("Archive.zip") as String
        let unZipPath       : String    = directoryPath.appendingPathComponent("Archive.json") as String
        do
        {
            try FileManager.default.removeItem(atPath: zipPath)
            try FileManager.default.removeItem(atPath: unZipPath)
        }
        catch
        {
            print(error.localizedDescription)
        }
    }
}

// MARK: - Extension - String

extension String
{
    var random: String
    {
        let random: Int = Int(10000 + arc4random() % 90000)
        let tmp = "\(random)"
        return tmp
    }
    
    func UUIDString() -> String
    {
        let UUID = CFUUIDCreate(kCFAllocatorDefault)
        let UUIDString = CFUUIDCreateString(kCFAllocatorDefault, UUID) as String?
        // Remove '-' in UUID
        return (UUIDString?.components(separatedBy: "-").joined(separator: "").lowercased())!
    }
}

// MARK: - Extension - Int

extension Int64
{
    var boolValue: Bool { return self != 0 }
}

// MARK: - Extension - Bool

extension Bool
{
    init?(string: String)
    {
        switch string
        {
        case "True", "true", "yes", "1":
            self = true
        case "False", "false", "no", "0":
            self = false
        default:
            self = false
        }
    }
}
