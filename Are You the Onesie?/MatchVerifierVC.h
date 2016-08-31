//
//  MatchVerifierVC.h
//  Are You the Onesie?
//
//  Created by Julian Tigler on 8/27/16.
//  Copyright © 2016 High5! Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

// Must be at least 2 to not interfere with the flash animation
#define MINIMUM_REVEAL_WAIT_TIME 4
#define MAXIMUM_REVEAL_WAIT_TIME 7

@interface MatchVerifierVC : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UILabel *guyLabel;
@property (weak, nonatomic) IBOutlet UILabel *girlLabel;
@property (weak, nonatomic) IBOutlet UILabel *lockLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIScrollView *guyScroller;
@property (weak, nonatomic) IBOutlet UIScrollView *girlScroller;
@property (weak, nonatomic) IBOutlet UIView *scanningLineView;

- (IBAction)cancelPressed:(id)sender;
- (void)namePressedDown:(id)sender;
- (void)nameUnpressed:(id)sender;

- (id)initWithGuys:(NSArray *)guys girls:(NSArray *)girls matches:(NSDictionary *)matches;
- (BOOL)isMatch:(NSArray *)pair;
- (void)setColorSchemeDark:(BOOL)shouldBeDark;
- (void)onLockCountdownBegan;
- (void)onLockCountdownCanceled;

// Subclasses must implement this method
- (void)onPairLocked:(NSArray *)lockedPair;

@end
