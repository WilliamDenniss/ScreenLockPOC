//
//  ScreenLockViewController.m
//  ScreenLockPOC
//
//  Created by William Denniss on 4/09/2014.
//  Copyright (c) 2014 William Denniss. All rights reserved.
//

#import "ScreenLockViewController.h"

#import <AudioToolbox/AudioServices.h>

@interface ScreenLockViewController ()

@end

@implementation ScreenLockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:UIApplicationProtectedDataDidBecomeAvailable object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:UIApplicationProtectedDataWillBecomeUnavailable object:nil];

    }
    return self;
}

- (void) dealloc
{
	
}

- (void) didReceiveNotification:(NSNotification*)notification
{
	if (notification.name == UIApplicationProtectedDataDidBecomeAvailable
		|| notification.name == UIApplicationProtectedDataWillBecomeUnavailable)
	{
		NSString* note = [NSString stringWithFormat:@"Passcode Use Detected (%@ at %@)", notification.name, [NSDate date]];
		NSLog(@"%@", note);
		
		msgLabel.text = @"Passcode Use Detected";
		
		AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
	}
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
