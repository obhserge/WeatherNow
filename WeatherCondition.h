//
//  Condition.h
//  WeatherNow
//
//  Created by admin on 15.07.15.
//  Copyright (c) 2015 sergeernie. All rights reserved.
//

#import "ServerObject.h"

@interface WeatherCondition : ServerObject

@property (nonatomic, strong) NSString* city;
@property (nonatomic, strong) NSString* country;
@property (nonatomic, strong) NSString* pressure;
@property (nonatomic, strong) NSString* humidity;
@property (nonatomic, strong) NSString* cod;
@property (nonatomic, strong) NSString* icon;
@property (nonatomic, strong) NSString* weatherDescription;
@property (nonatomic, strong) NSString* temp;
@property (nonatomic, strong) NSString* tempMin;
@property (nonatomic, strong) NSString* tempMax;

- (NSString *)imageName;

@end
