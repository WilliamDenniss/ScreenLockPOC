//
//  ScreenLockViewController.m
//  ScreenLockPOC
//
//  Created by William Denniss on 4/09/2014.
//

#import "ScreenLockViewController.h"

#import <AudioToolbox/AudioServices.h>

#define kScreenLockViewControllerLogHistoryKey @"history"
#define kScreenLockViewControllerLastDetectedKey @"lastDetection"

@interface ScreenLockViewController ()

@end

@implementation ScreenLockViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		
		logHistory = [NSMutableString new];
		
		if ([[NSUserDefaults standardUserDefaults] stringForKey:kScreenLockViewControllerLogHistoryKey])
		{
			logHistory = [[[NSUserDefaults standardUserDefaults] stringForKey:kScreenLockViewControllerLogHistoryKey] mutableCopy];
		}
		
		[self logMessage:@"------------- App Started"];

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
		NSString* note = [NSString stringWithFormat:@"%@ [Passcode Use Detected!]", notification.name];
		[self logMessage:note];
		
		[[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kScreenLockViewControllerLastDetectedKey];

		AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
		
		[self updateUI];
	}
	else
	{
		[self logMessage:[NSString stringWithFormat:@"%@", notification.name]];
	}
}

- (void) updateUI
{
	NSDate* lastPasscodeDate = (NSDate*) [[NSUserDefaults standardUserDefaults] objectForKey:kScreenLockViewControllerLastDetectedKey];

	if (lastPasscodeDate)
	{
		NSDateFormatter* dateFormatter = [self dateFormatter];
		[dateFormatter setDateFormat:@"HH:mm:ss"];
		NSString* dateString = [[self dateFormatter] stringFromDate:lastPasscodeDate];

		if ([lastPasscodeDate earlierDate:[NSDate dateWithTimeIntervalSinceNow:-60*60]] == lastPasscodeDate)
		{
			msgLabel.text = [NSString stringWithFormat:@"Historical Passcode Use Detected\n (%@)", dateString];
		}
		else
		{
			NSTimeInterval since = fabs([lastPasscodeDate timeIntervalSinceNow]);
			
			msgLabel.text = [NSString stringWithFormat:@"Recent Passcode Use Detected!\n (%lds ago)", (long)since];
		}
	}
	else
	{
		msgLabel.text = @"Not yet detected";
	}

	msgHistory.text = logHistory;
	msgHistory.textContainer.lineBreakMode = NSLineBreakByCharWrapping;
	
}

- (NSDateFormatter*) dateFormatter
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	NSCalendar *gregorian = [[NSCalendar alloc]  initWithCalendarIdentifier:NSGregorianCalendar];
	[dateFormatter setCalendar:gregorian];
	dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	return dateFormatter;
}

- (void) logMessage:(NSString*)message
{
	NSString* date = [[self dateFormatter] stringFromDate:[NSDate date]];

	NSString* note = [NSString stringWithFormat:@"%@: %@", date, message];

	[logHistory insertString:@"\n" atIndex:0];
	[logHistory insertString:note atIndex:0];
	
	NSLog(@"%@", note);
	
	[[NSUserDefaults standardUserDefaults] setObject:msgHistory.text forKey:kScreenLockViewControllerLogHistoryKey];
	
	[self updateUI];
}

- (IBAction) clearHistory
{
	logHistory = [NSMutableString new];
	[self logMessage:@"cleared."];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kScreenLockViewControllerLogHistoryKey];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kScreenLockViewControllerLastDetectedKey];

	[self updateUI];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self updateUI];
	[updateTimer invalidate];
	updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
}

- (void) viewDidUnload
{
	[updateTimer invalidate];
	updateTimer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
