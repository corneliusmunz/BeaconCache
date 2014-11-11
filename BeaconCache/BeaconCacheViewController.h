//
//  ViewController.h
//  BeaconCache
//
//  Created by Cornelius on 02.10.14.
//  Copyright (c) 2014 Cornelius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>


@interface BeaconCacheViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLBeaconRegion *cacheRegion;
@property (strong, nonatomic) IBOutlet UIImageView *cacheImage;
@property (strong, nonatomic) IBOutlet UILabel *cacheLabel;
@property SystemSoundID soundIDnotAvailable;
@property SystemSoundID soundIDcold;
@property SystemSoundID soundIDwarm;
@property SystemSoundID soundIdhot;


-(IBAction)playSound:(id)sender;


@end

