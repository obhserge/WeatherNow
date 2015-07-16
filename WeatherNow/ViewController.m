//
//  ViewController.m
//  WeatherNow
//
//  Created by admin on 15.07.15.
//  Copyright (c) 2015 sergeernie. All rights reserved.
//

#import "ViewController.h"
#import "ServerManager.h"
#import "UIImageView+LBBlurredImage.h"
#import "Reachability.h"

#import "WeatherCondition.h"

@interface ViewController ()

@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, assign) BOOL isFirstUpdate;
@property (nonatomic, strong) UILabel* cityLabel;
@property (nonatomic, strong) UILabel* hiloLabel;
@property (nonatomic, strong) UILabel* temperatureLabel;
@property (nonatomic, strong) UILabel* conditionsLabel;
@property (nonatomic, strong) UIImageView* iconView;
@property (nonatomic, strong) UIButton* refreshButton;
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;

@property (nonatomic, strong) Reachability *internetReachableFoo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ** Don't forget to add NSLocationWhenInUseUsageDescription in MyApp-Info.plist and give it a string
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    // Проверяем какая версия iOS. Если iOS 8, то спрашиваем у пользователя, что хотим
    // использовать его текущее местоположение.
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    // задаем фон
    UIImage *background = [UIImage imageNamed:@"bg"];
    self.backgroundImageView = [[UIImageView alloc] initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    // Blur
    //[self.backgroundImageView setImageToBlur:background blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:nil];
    
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    CGFloat inset = 20;
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 30;
    CGFloat buttonWidth = 30;
    CGFloat buttonHeight = 30;
    CGRect hiloFrame = CGRectMake(inset, headerFrame.size.height - hiloHeight, headerFrame.size.width - 2*inset, hiloHeight);
    CGRect temperatureFrame = CGRectMake(inset, headerFrame.size.height - temperatureHeight - hiloHeight, headerFrame.size.width - 2*inset, temperatureHeight);
    CGRect iconFrame = CGRectMake(inset, temperatureFrame.origin.y - iconHeight, iconHeight, iconHeight);
    CGRect conditionsFrame = iconFrame;
    // make the conditions text a little smaller than the view
    // and to the right of our icon
    conditionsFrame.size.width = self.view.bounds.size.width - 2*inset - iconHeight - 10;
    conditionsFrame.origin.x = iconFrame.origin.x + iconHeight + 10;
    
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    //self.tableView.tableHeaderView = header;
    
    // bottom left
    self.temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    self.temperatureLabel.backgroundColor = [UIColor clearColor];
    self.temperatureLabel.textColor = [UIColor whiteColor];
    self.temperatureLabel.text = @"0°";
    self.temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    [self.view addSubview:self.temperatureLabel];
    
    // bottom left
    self.hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    self.hiloLabel.backgroundColor = [UIColor clearColor];
    self.hiloLabel.textColor = [UIColor whiteColor];
    self.hiloLabel.text = @"0° / 0°";
    self.hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    [self.view addSubview:self.hiloLabel];
    
    // refresh button
    self.refreshButton = [[UIButton alloc]
                         initWithFrame:CGRectMake(self.view.bounds.size.width - inset - 30, inset, buttonWidth, buttonHeight)];
    [self.refreshButton setBackgroundImage:[UIImage imageNamed:@"reload"] forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(refreshWeather) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.refreshButton];
    
    // top
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
    self.cityLabel.backgroundColor = [UIColor clearColor];
    self.cityLabel.textColor = [UIColor whiteColor];
    self.cityLabel.text = @"Loading...";
    self.cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.cityLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.cityLabel];
    
    self.conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    self.conditionsLabel.backgroundColor = [UIColor clearColor];
    self.conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.conditionsLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.conditionsLabel];
    
    // bottom left
    self.iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.backgroundColor = [UIColor clearColor];
    //[self.iconView setBackgroundColor:[UIColor greenColor]];
    //self.iconView.image = [UIImage imageNamed:@"weather-clear"];

    [self.view addSubview:self.iconView];
    
    [self findCurrentLocation];
    
}


# pragma mark - Settings

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Actions

- (void)findCurrentLocation {
    
    [self replaceRefreshButtonWithActivityIndicator];
    
    self.isFirstUpdate = YES;
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)refreshWeather {
    
    [self findCurrentLocation];
    
    [self.view setNeedsDisplay];
    
}

- (void)replaceRefreshButtonWithActivityIndicator {
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:self.refreshButton.frame];
    
    [self.activityIndicator setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin |
                                                 UIViewAutoresizingFlexibleRightMargin |
                                                 UIViewAutoresizingFlexibleTopMargin |
                                                 UIViewAutoresizingFlexibleBottomMargin)];
    
    [self.activityIndicator startAnimating];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self.refreshButton removeFromSuperview];
    
    [self.view addSubview:self.activityIndicator];
    
}

- (void)removeActivityIndicatorFromRefreshButon {
    
    // удаляем activityIndicator с супервью, останавливаем networkActivityIndicator
    // и добавляем кнопку refresh на view
    
    [self.activityIndicator removeFromSuperview];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self.view addSubview:self.refreshButton];
    
}

- (void)getWeatherCondition:(CLLocation*) location {
    
    [[ServerManager sharedManager] getCurrentConditionWithCoordinate:location
                                                           onSuccess:^(WeatherCondition *condition) {
                                                               
                                                               self.cityLabel.text = [NSString stringWithFormat:@"%@ (%@)", condition.city, condition.country];
                                                               
                                                               self.temperatureLabel.text = condition.temp;
                                                               
                                                               self.hiloLabel.text = [NSString stringWithFormat:@"%@ / %@", condition.tempMax, condition.tempMin];
                                                               
                                                               self.conditionsLabel.text = condition.weatherDescription;
                                                               
                                                               self.iconView.image = [UIImage imageNamed:condition.icon];
                                                               
                                                               [self removeActivityIndicatorFromRefreshButon];
                                                               
                                                           }
     
                                                           onFailure:^(NSError *error, NSInteger statusCode) {
                                                               
                                                               NSLog(@"Error: %@", [error localizedDescription]);
                                                               
                                                               [self removeActivityIndicatorFromRefreshButon];
                                                               
                                                           }
     ];

    
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    if (self.isFirstUpdate) {
        self.isFirstUpdate = NO;
        return;
    }
    
    CLLocation *location = [locations lastObject];
    
    if (location.horizontalAccuracy > 0) {
        
        self.currentLocation = location;
        [self.locationManager stopUpdatingLocation];
        
        self.internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
        
        // Проверяем наличие интернета
        
        __weak typeof(self) weakSelf = self;
        
        self.internetReachableFoo.reachableBlock = ^(Reachability*reach)
        {
            // Интернет есть, делаем запрос
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSLog(@"интернет есть!");
                
                [weakSelf getWeatherCondition:location];
                
            });
        };
        
        // Если интернета нету
        self.internetReachableFoo.unreachableBlock = ^(Reachability*reach)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //NSLog(@"Нету интернета :(");
                
                [weakSelf removeActivityIndicatorFromRefreshButon];
                
                [[[UIAlertView alloc]
                  initWithTitle:@"Упс, ошибочка вышла.."
                  message:@"Отсутствует подключение к интернету!"
                  delegate:nil
                  cancelButtonTitle:@"Ладно"
                  otherButtonTitles: nil] show];
                
            });
        };
        
        [self.internetReachableFoo startNotifier];
        
    }

}


@end
