//
//  ViewController.m
//  BeaconCache
//
//  Created by Cornelius on 02.10.14.
//  Copyright (c) 2014 Cornelius. All rights reserved.
//

#import "BeaconCacheViewController.h"



@interface BeaconCacheViewController ()

@end

@implementation BeaconCacheViewController

@synthesize cacheRegion, locationManager, cacheImage, cacheLabel, soundIDnotAvailable, soundIdhot, soundIDwarm, soundIDcold;

//ToDo: animation icon, sounds

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self setup];
    
    [locationManager startRangingBeaconsInRegion:self.cacheRegion];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init methods

- (void)setup {
    [self setupLocationManager];
    [self createBeaconCacheRegion];
    [self setupSounds];
    [self setupAnimations];
}

- (void)setupAnimations {
    CGAffineTransform scale = CGAffineTransformMakeScale(0.8, 0.8);
    [UIView beginAnimations:@"Scale" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:MAXFLOAT];
    cacheImage.transform = scale;
    [UIView commitAnimations];
}

- (void)setupLocationManager {
    // init of location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    // authorization request
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if ((authStatus == kCLAuthorizationStatusDenied) ||
        (authStatus == kCLAuthorizationStatusRestricted) ||
        (authStatus == kCLAuthorizationStatusNotDetermined)) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)createBeaconCacheRegion {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
    self.cacheRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                                          major:36836
                                                                          minor:35482
                                                                     identifier:@"cacheRegion"];
    self.cacheRegion.notifyEntryStateOnDisplay = YES;
}

- (void)setupSounds {
    CFBundleRef mainBundle = CFBundleGetMainBundle ();
    
    CFURLRef soundFileURLRef  = CFBundleCopyResourceURL (
                                                         mainBundle,
                                                         CFSTR ("Submarine"),
                                                         CFSTR ("aiff"),
                                                         NULL
                                                         );
    AudioServicesCreateSystemSoundID (
                                      soundFileURLRef,
                                      &soundIDnotAvailable
                                      );
    soundFileURLRef  = CFBundleCopyResourceURL (
                                                mainBundle,
                                                CFSTR ("Morse"),
                                                CFSTR ("aiff"),
                                                NULL
                                                );
    AudioServicesCreateSystemSoundID (
                                      soundFileURLRef,
                                      &soundIDcold
                                      );
    soundFileURLRef  = CFBundleCopyResourceURL (
                                                mainBundle,
                                                CFSTR ("Ping"),
                                                CFSTR ("aiff"),
                                                NULL
                                                );
    AudioServicesCreateSystemSoundID (
                                      soundFileURLRef,
                                      &soundIDwarm
                                      );
    soundFileURLRef  = CFBundleCopyResourceURL (
                                                mainBundle,
                                                CFSTR ("Glass"),
                                                CFSTR ("aiff"),
                                                NULL
                                                );
    AudioServicesCreateSystemSoundID (
                                      soundFileURLRef,
                                      &soundIdhot
                                      );
}

#pragma mark - change UI state methods

- (void)setImageForProximity:(CLProximity)proximity {
    if (proximity == CLProximityUnknown) {
        [cacheImage setImage:[UIImage imageNamed:@"notAvailable"]];
    } else if (proximity == CLProximityFar) {
        [cacheImage setImage:[UIImage imageNamed:@"cold"]];
    } else if (proximity == CLProximityNear) {
        [cacheImage setImage:[UIImage imageNamed:@"warm"]];
    } else if (proximity == CLProximityImmediate) {
        [cacheImage setImage:[UIImage imageNamed:@"hot"]];
    }
}

-(void)playSoundForProximity:(CLProximity)proximity {
    if (proximity == CLProximityUnknown) {
        AudioServicesPlaySystemSound(soundIDnotAvailable);
    } else if (proximity == CLProximityFar) {
        AudioServicesPlaySystemSound(soundIDcold);
    } else if (proximity == CLProximityNear) {
        AudioServicesPlaySystemSound(soundIDwarm);
    } else if (proximity == CLProximityImmediate) {
        AudioServicesPlaySystemSound(soundIdhot);
    }
}

-(void)setLabelForProximity:(CLProximity)proximity {
    if (proximity == CLProximityUnknown) {
        [cacheLabel setText:@""];
    } else if (proximity == CLProximityFar) {
        [cacheLabel setText:@"Kalt"];
    } else if (proximity == CLProximityNear) {
        [cacheLabel setText:@"Warm"];
    } else if (proximity == CLProximityImmediate) {
        [cacheLabel setText:@"Heiß"];
    }
}

-(IBAction)playSound:(id)sender {
    AudioServicesPlaySystemSound(soundIDwarm);
    AudioServicesPlayAlertSound(soundIDnotAvailable);
}


#pragma mark - CLLocationManager delegates

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    CLBeacon *beacon = [beacons firstObject];
    [self setImageForProximity:beacon.proximity];
    [self playSoundForProximity:beacon.proximity];
    [self setLabelForProximity:beacon.proximity];

}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    NSLog(@"Enter region");
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region{
    NSLog(@"Exit region");
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"LocationManager error: %@", error.localizedDescription);
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region {
    NSLog(@"");
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"status: %d", status);
}


@end
