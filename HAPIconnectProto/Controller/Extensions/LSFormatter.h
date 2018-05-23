//
//  LSFormatter.h
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/23/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSFormatter : NSObject

+(NSString *)translateDeviceIdToSN:(NSString *)deviceId;

+(float)fatByHeight:(float)height weight:(float)weight imp:(int)imp age:(int)age gender:(int)gender;
+(float)waterByHeight:(float)height weight:(float)weight imp:(int)imp gender:(int)gender;

@end
