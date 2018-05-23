//
//  LSFormatter.m
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/23/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

#import "LSFormatter.h"

@implementation LSFormatter

#pragma mark -

+(NSString *)translateDeviceIdToSN:(NSString *)deviceId
{
    NSInteger firstPart     = [self stringToInt32:[deviceId substringWithRange:NSMakeRange(0, 6)]];
    NSInteger secondPart    = [self stringToInt32:[deviceId substringWithRange:NSMakeRange(6, 6)]];
    
    NSNumber *firstNumber   = [NSNumber numberWithUnsignedInteger:firstPart];
    NSNumber *secondNumber  = [NSNumber numberWithUnsignedInteger:secondPart];
    
    NSMutableString *firstString    = [NSMutableString stringWithString:[firstNumber stringValue]];
    NSMutableString *secondString   = [NSMutableString stringWithString:[secondNumber stringValue]];
    
    NSString *zeroString    = [NSString stringWithFormat:@"0"];
    NSInteger length        = 8 - firstString.length;
    
    for (int i = 0; i<length; i++)
    {
        [firstString insertString:zeroString atIndex:0];
    }
    
    length = 8-secondString.length;
    
    for (int i = 0; i<length; i++)
    {
        [secondString insertString:zeroString atIndex:0];
    }
    
    [firstString appendString:secondString];
    return firstString;
}

+(uint32_t)stringToInt32:(NSString*)subString
{
    NSString *lowcaseString = [subString lowercaseString];
    char *characterPoint = (char*)[lowcaseString UTF8String];
    uint32_t result = 0;
    
    for (int i = 0; i<[lowcaseString length]; i++)
    {
        result = result<<4;
        char localChar = *characterPoint;
        uint8_t localInt = 0;
        
        if (localChar>='0'&&localChar<='9')
        {
            localInt = localChar-'0';
        }
        
        if (localChar>='a'&&localChar<='f')
        {
            localInt = localChar - 'a' +10;
        }
        result = result |localInt;
        characterPoint++;
    }
    
    return result;
}

#pragma mark -

+(float)fatByHeight:(float)height weight:(float)weight imp:(int)imp age:(int)age gender:(int)gender
{
    imp = imp - 10;
    
    /* MALE */
    
    if (gender == 1)
    {
        float fat;
        
        fat = 60.3-486583*height*height/weight/imp+9.146*weight/height/height/imp-251.193*height*height/weight/age+1625303/imp/imp-0.0139*imp+0.05975*age;
        
        if (fat<5)
        {
            fat=5;
        }
        
        return fat;
    }
    
    /* FEMALE */
    
    else if (gender == 2)
    {
        float fat;
        
        fat = 57.621-186.422*height*height/weight-382280*height*height/weight/imp+128.005*weight/height/imp-0.0728*weight/height+7816.359/height/imp-3.333*weight/height/height/age;
        
        if (fat<5)
        {
            fat=5;
        }
        
        return fat;
    }
    return 0;
}

+(float)waterByHeight:(float)height weight:(float)weight imp:(int)imp gender:(int)gender
{
    imp = imp - 10;
    
    /* MALE */
    
    if (gender == 1)
    {
        float water;
        
        water=30.849+259672.5*height*height/weight/imp+0.372*imp/height/weight-2.581*height*weight/imp;
        
        return water;
    }
    
    /* FEMALE */
    
    else if (gender == 2)
    {
        float water;
        
        water=23.018+201468.7*height*height/weight/imp+421.543/weight/height+160.445*height/weight;
        
        return water;
    }
    return 0;
}

@end
