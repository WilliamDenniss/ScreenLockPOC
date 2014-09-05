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

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:UIApplicationWillTerminateNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];

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
		NSString* note = [NSString stringWithFormat:@"Passcode Use Detected! [%@]", notification.name];
		[self logMessage:note];
	
		msgLabel.text = @"Passcode Use Detected";
		
		AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
	}
	else
	{
		[self logMessage:notification.name];
	}
}

- (void) logMessage:(NSString*)message
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSCalendar *gregorian = [[NSCalendar alloc]  initWithCalendarIdentifier:NSGregorianCalendar];
	[dateFormatter setCalendar:gregorian];
	dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString* date = [dateFormatter stringFromDate:[NSDate date]];

	NSString* note = [NSString stringWithFormat:@"%@: %@", date, message];

	msgHistory.text = [NSString stringWithFormat:@"%@\n%@", note, msgHistory.text];
	NSLog(@"%@", note);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	msgHistory.text = @"";
	[self logMessage:@"App Started"];

	msgLabel.text = @"Not yet detected";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
