//
//  ServerObject.h
//  WeatherNow
//
//  Created by admin on 15.07.15.
//  Copyright (c) 2015 sergeernie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ServerObject : NSObject

- (id)initWithServerResponse:(NSDictionary*) responseObject;

@end
