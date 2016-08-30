//
//  TruthBoothVC.m
//  Are You the Onesie?
//
//  Created by Julian Tigler on 8/28/16.
//  Copyright © 2016 High5! Apps. All rights reserved.
//

#import "TruthBoothVC.h"

@interface TruthBoothVC ()
@property (strong, nonatomic) NSString *pressedGuy;
@property (strong, nonatomic) NSString *pressedGirl;
@property (strong, nonatomic) NSMutableArray *lockedPairs; // pairs must be @[guy, girl]
@property (strong, nonatomic) NSMutableArray *guyButtons;
@property (strong, nonatomic) NSMutableArray *girlButtons;
@end

@implementation TruthBoothVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.topItem.title = @"The Truth Booth";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nameUnpressed:(id)sender{
    [super nameUnpressed:sender];
    
    if (self.lockedPairs.count == 1 && !self.pressedGuy && !self.pressedGirl) {
        [self revealMatch:[self.lockedPairs objectAtIndex:0]];
    }
}

- (void)onPairLocked:(NSArray *)lockedPair{
    [super onPairLocked:lockedPair];
    
    [self.lockedPairs insertObject:lockedPair atIndex:0];
    
    for (UIButton *button in self.guyButtons) {
        button.enabled = NO;
    }
    
    for (UIButton *button in self.girlButtons) {
        button.enabled = NO;
    }
}

- (void)revealMatch:(NSArray *)lockedPair{
    [self setColorSchemeDark:YES];
    [self.activityIndicator startAnimating];
    
    BOOL isMatch = [super isMatch:lockedPair];
    
    NSString *lockText;
    UIColor *textColor;
    if (isMatch) {
        lockText = @"Match!";
        textColor = [UIColor greenColor];
    }else{
        lockText = @"No Match!";
        textColor = [UIColor redColor];
    }
    
    int randomWaitTime = MINIMUM_REVEAL_WAIT_TIME + arc4random() % (MAXIMUM_REVEAL_WAIT_TIME - MINIMUM_REVEAL_WAIT_TIME);
    
    [self.lockLabel performSelector:@selector(setTextColor:) withObject:textColor afterDelay:randomWaitTime];
    [self.lockLabel performSelector:@selector(setText:) withObject:lockText afterDelay:randomWaitTime];
    [self.activityIndicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:randomWaitTime];
    [self performSelector:@selector(notifiyDelegate) withObject:nil afterDelay:randomWaitTime + 1];
}

- (void)notifiyDelegate{
    NSArray *pair = [self.lockedPairs objectAtIndex:0];
    [self.delegate truthBooth:self didRevealPair:pair asMatch:[self isMatch:pair]];
}

- (void)onLockCountdownBegan{
    [super onLockCountdownBegan];
    
    self.cancelButton.enabled = NO;
}

- (void)onLockCountdownCanceled{
    [super onLockCountdownCanceled];
    
    self.cancelButton.enabled = YES;
}

@end
