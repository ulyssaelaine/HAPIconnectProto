//
//  CalendarUtil.swift
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/10/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

import UIKit

class CalendarUtil: NSObject
{
    // MARK: - Shared Instance
    
    static let sharedInstance : CalendarUtil =
    {
        let instance = CalendarUtil()
        return instance
    }()
    
    // MARK: - Initialization Method
    
    override init()
    {
        super.init()
    }
    
    // MARK: -
    
    func getDateFromString(_ dateString : String) -> Date
    {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone      = NSTimeZone.default
        dateFormatter.locale        = NSLocale.current
        let date = dateFormatter.date(from: dateString)!
        
        return date
    }
    
    func checkIfAMorPM(_ date: Date) -> String
    {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "a"
        let currentAMPMFormat       = dateFormatter.string(from: date).uppercased()
        
        return currentAMPMFormat
    }
    
    func getGMTDateFromString(_ dateString : String) -> Date
    {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd"
        dateFormatter.timeZone      = NSTimeZone(abbreviation: "GMT")! as TimeZone
        dateFormatter.locale        = NSLocale.current
        let date = dateFormatter.date(from: dateString)!
        
        return date
    }
    
    func getLocalDateFromString(_ dateString : String) -> Date
    {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone      = NSTimeZone.local as TimeZone
        let date = dateFormatter.date(from: dateString)!
        
        return date
    }
    
    func utcToDateString(_ utc : UInt32) -> String
    {
        let startDate : NSDate      = self.startDate() as NSDate
        let endDate : NSDate        = startDate.addingTimeInterval(TimeInterval(utc))
        
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone      = NSTimeZone.system
        
        return dateFormatter.string(from: endDate as Date)
    }
    
    func getTimeAMPMFromString(_ stringDate : String) -> String
    {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "HH:mm:ss"
        dateFormatter.timeZone      = NSTimeZone.system
        
        let timeDate : Date         = dateFormatter.date(from: stringDate)!
        
        dateFormatter.dateFormat    = "hh:mm a"
        dateFormatter.timeZone      = NSTimeZone.system
        
        return dateFormatter.string(from: timeDate)
    }
    
    func startDate() -> Date
    {
        var startDate: Date?
        if startDate == nil
        {
            var comp: DateComponents?
            comp = DateComponents()
            comp?.timeZone = NSTimeZone.system
            comp?.year = 2010
            comp?.month = 1
            comp?.day = 1
            comp?.hour = 0
            comp?.minute = 0
            comp?.second = 0
            let calendar = NSCalendar(calendarIdentifier: .gregorian)
            if let aComp = comp
            {
                startDate = calendar?.date(from: aComp)
            }
        }
        return startDate!
    }
    
    func convertGMTDateToCurrentTimeZone(sourceDate: NSDate) -> NSDate
    {
        let sourceTimeZone : TimeZone       = NSTimeZone(abbreviation: "GMT")! as TimeZone
        let destinationTimeZone : TimeZone  = NSTimeZone.system
        let sourceGMTOffset : NSInteger     = sourceTimeZone.secondsFromGMT(for: sourceDate as Date)
        let destinationOffset : NSInteger   = destinationTimeZone.secondsFromGMT(for: sourceDate as Date)
        let interval : TimeInterval         = TimeInterval(destinationOffset - sourceGMTOffset)
        let destinationDate : NSDate        = NSDate(timeInterval: interval, since: sourceDate as Date)
        
        return destinationDate
    }
}
