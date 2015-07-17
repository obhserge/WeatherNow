//
//  Condition.m
//  WeatherNow
//
//  Created by admin on 15.07.15.
//  Copyright (c) 2015 sergeernie. All rights reserved.
//

#import "WeatherCondition.h"

@implementation WeatherCondition

- (id)initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super initWithServerResponse:responseObject];
    if (self) {
        self.cod = [responseObject objectForKey:@"cod"];
        self.city = [responseObject objectForKey:@"name"];
        
        NSDictionary* sys = [responseObject objectForKey:@"sys"];
        self.country = [sys objectForKey:@"country"];
        
        NSArray* weather = [responseObject objectForKey:@"weather"];
        NSDictionary* weatherDict = [weather firstObject];
        NSString* weatherCode = [weatherDict objectForKey:@"icon"];
        
        self.weatherDescription = [weatherDict objectForKey:@"description"];
        
        NSString* iconName = nil;
        
        if ([weatherCode isEqualToString:@"01d"]) {
            iconName = @"weather-clear";
        } else if ([weatherCode isEqualToString:@"02d"]) {
            iconName = @"weather-few";
        } else if ([weatherCode isEqualToString:@"03d"]) {
            iconName = @"weather-few";
        } else if ([weatherCode isEqualToString:@"04d"]) {
            iconName = @"weather-broken";
        } else if ([weatherCode isEqualToString:@"09d"]) {
            iconName = @"weather-shower";
        } else if ([weatherCode isEqualToString:@"10d"]) {
            iconName = @"weather-rain";
        } else if ([weatherCode isEqualToString:@"11d"]) {
            iconName = @"weather-tstorm";
        } else if ([weatherCode isEqualToString:@"13d"]) {
            iconName = @"weather-snow";
        } else if ([weatherCode isEqualToString:@"50d"]) {
            iconName = @"weather-mist";
        } else if ([weatherCode isEqualToString:@"01n"]) {
            iconName = @"weather-moon";
        } else if ([weatherCode isEqualToString:@"02n"]) {
            iconName = @"weather-few-night";
        } else if ([weatherCode isEqualToString:@"03n"]) {
            iconName = @"weather-few-night";
        } else if ([weatherCode isEqualToString:@"04n"]) {
            iconName = @"weather-broken";
        } else if ([weatherCode isEqualToString:@"09n"]) {
            iconName = @"weather-shower";
        } else if ([weatherCode isEqualToString:@"10n"]) {
            iconName = @"weather-rain-night";
        } else if ([weatherCode isEqualToString:@"11n"]) {
            iconName = @"weather-tstorm";
        } else if ([weatherCode isEqualToString:@"13n"]) {
            iconName = @"weather-snow";
        } else if ([weatherCode isEqualToString:@"50n"]) {
            iconName = @"weather-mist";
        }
        
        self.icon = iconName;
        
        NSDictionary* main = [responseObject objectForKey:@"main"];
        NSInteger temp = [[main objectForKey:@"temp"] integerValue];
        NSInteger tempMax = [[main objectForKey:@"temp_max"] integerValue];
        NSInteger tempMin = [[main objectForKey:@"temp_min"] integerValue];
        
        self.temp = [NSString stringWithFormat:@"%ld°", (long)temp];
        self.tempMax = [NSString stringWithFormat:@"%ld°", (long)tempMax];
        self.tempMin = [NSString stringWithFormat:@"%ld°", (long)tempMin];
        
    }
    
    return self;
}

@end
