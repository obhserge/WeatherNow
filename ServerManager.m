//
//  ServerManager.m
//  WeatherNow
//
//  Created by admin on 15.07.15.
//  Copyright (c) 2015 sergeernie. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "WeatherCondition.h"

@interface ServerManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager* requestOperationManager;

@end

@implementation ServerManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] init];
    }
    return self;
}


// инициализируем синглтон, который будет возвращать нам ServerManager
+ (ServerManager*)sharedManager {
    
    static ServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}


// GET запрос к серверу. В запросе передаем latitude и longitude, которые получили от locationManager из ViewController'а

- (void)getCurrentConditionWithCoordinate:(CLLocation*) location
                                onSuccess:(void(^)(WeatherCondition* condition)) success
                                onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSString* latitude = [[NSNumber numberWithFloat:location.coordinate.latitude] stringValue];
    NSString* longitude = [[NSNumber numberWithFloat:location.coordinate.longitude] stringValue];
    
    //NSLog(@"latitude on server manager:%@, longitude  on server manager:%@", latitude, longitude);
    
    NSString* urlString =
    [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?"
                                "lat=%@&lon=%@&units=metric", latitude, longitude];
    
    [self.requestOperationManager GET:urlString
                           parameters:nil
                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                  //NSLog(@"JSON: %@", responseObject);
                                  
                                  WeatherCondition* currentCondition = [[WeatherCondition alloc] initWithServerResponse:responseObject];
                                  
                                  if (success) {
                                      success(currentCondition);
                                  }
                                  
                              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                  
                                  NSLog(@"Error: %@", [error localizedDescription]);
                                  
                                  if (failure) {
                                      failure(error, operation.response.statusCode);
                                  }
                              }
     ];
    
}

@end
