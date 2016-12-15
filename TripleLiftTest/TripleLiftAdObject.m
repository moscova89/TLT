//
//  TripleLiftAdObject.m
//  TripleLiftTest
//
//  Created by iMac on 10/15/16.
//  Copyright © 2016 Moscova. All rights reserved.
//

#import "TripleLiftAdObject.h"

@implementation TripleLiftAdObject


-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        if (dictionary != nil) {
            
            _adID = [self safeObjectForKey:@"advertiser_id" fromDictionary:dictionary];
            _date = [self safeObjectForKey:@"ymd" fromDictionary:dictionary];
            _numberOfClicks = [self safeObjectForKey:@"num_clicks" fromDictionary:dictionary];
            _numberOfImpressions = [self safeObjectForKey:@"num_impressions" fromDictionary:dictionary];
            
        }
    }
    return self;
}



-(id)safeObjectForKey:(NSString*)key fromDictionary:(NSDictionary*)dictionary{
    if ([dictionary objectForKey:key]) {
        return [dictionary objectForKey:key];
    }else{
        return nil;
    }
}

@end
