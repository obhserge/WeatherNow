//
//  ServerManager.h
//  WeatherNow
//
//  Created by admin on 15.07.15.
//  Copyright (c) 2015 sergeernie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class WeatherCondition;


@interface ServerManager : NSObject

+ (ServerManager*)sharedManager;

- (void)getCurrentConditionWithCoordinate:(CLLocation*) location
                                onSuccess:(void(^)(WeatherCondition* condition)) success
                                onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

@end
