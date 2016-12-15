//
//  TripleLiftAdObject.h
//  TripleLiftTest
//
//  Created by iMac on 10/15/16.
//  Copyright © 2016 Moscova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripleLiftAdObject : NSObject

@property (nonatomic, strong) NSNumber* adID;
@property (nonatomic, strong) NSString* date;
@property (nonatomic, strong) NSNumber* numberOfClicks;
@property (nonatomic, strong) NSNumber* numberOfImpressions;


-(instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end
