//
//  NSArray+LSAddition.m
//  HAPIconnectProto
//
//  Created by Elaine Reyes on 5/16/18.
//  Copyright © 2018 Anxa Europe Limited. All rights reserved.
//

#import "NSArray+LSAddition.h"

@implementation NSArray (LSAddition)

int keyValue(NSString*key)
{
    key = key.uppercaseString;
    NSData *data = [key dataUsingEncoding:NSASCIIStringEncoding];
    int value = 0;
    [data getBytes:&value];
    return value;
}

- (NSArray *)arrayByDiction
{
    NSMutableArray *outArray = [[NSMutableArray alloc] init];
    int minLength = 999;
    int compair[self.count];
    int compairIndex[self.count];
    for (NSString *temp in self) {
        minLength = (int)MIN(minLength, temp.length);
    }
    
    for (int r = 0; r < self.count; r++) {
        NSString *temp = [self objectAtIndex:r];
        compair[r] = 0;
        compairIndex[r] = 0;
        for (int i = 0; i < minLength; i ++) {
            int tempKeyValue = keyValue([temp substringWithRange:NSMakeRange(i, 1)]) * powf(60, (minLength - 1 - i));
            compair[r] += tempKeyValue;
        }
        //        NSLog(@"compair %d",compair[r]);
    }
    int minValue = MIN(compair[0], compair[1]);
    int maxValue = MAX(compair[0], compair[1]);
    if (compair[0] > compair[1]) {
        [outArray addObject:[self objectAtIndex:1]];
        [outArray addObject:[self objectAtIndex:0]];
    } else {
        [outArray addObject:[self objectAtIndex:0]];
        [outArray addObject:[self objectAtIndex:1]];
    }
    
    if (compair[2] < minValue) {
        [outArray insertObject:[self objectAtIndex:2] atIndex:0];
    }
    else if (compair[2] < maxValue) {
        [outArray insertObject:[self objectAtIndex:2] atIndex:1];
    }
    else {
        [outArray addObject:[self objectAtIndex:2]];
    }
    
    return outArray;
}

- (NSString *)stringOfArrayWithDiction
{
    NSArray *temp = [self arrayByDiction];
    NSMutableString *tempString = [[NSMutableString alloc]init];
    for (NSString *string in temp) {
        [tempString appendString:string];
    }
    return tempString;
}

@end
