//
//  ScreenLockViewController.h
//  ScreenLockPOC
//
//  Created by William Denniss on 2014-09-04.
//

#import <UIKit/UIKit.h>

@interface ScreenLockViewController : UIViewController {

	
	IBOutlet UILabel* msgLabel;
	IBOutlet UITextView* msgHistory;
	
	NSMutableString* logHistory;
	
	NSTimer* updateTimer;
}

- (IBAction) clearHistory;

@end
