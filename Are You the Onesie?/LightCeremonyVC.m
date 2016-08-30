//
//  LightCeremonyVC.m
//  Are You the Onesie?
//
//  Created by Julian Tigler on 8/28/16.
//  Copyright © 2016 High5! Apps. All rights reserved.
//

#import "LightCeremonyVC.h"

#define FLASH_ANIMATION_DURATION 2

@interface LightCeremonyVC ()
@property (strong, nonatomic) NSArray *guys;
@property (strong, nonatomic) NSArray *girls;
@property (strong, nonatomic) NSMutableArray *guyButtons;
@property (strong, nonatomic) NSMutableArray *girlButtons;
@property (strong, nonatomic) NSString *pressedGuy;
@property (strong, nonatomic) NSString *pressedGirl;

@property (strong, nonatomic) NSArray *pairColors;
@property (strong, nonatomic) NSMutableArray *lockedPairs; // pairs must be @[guy, girl]
@end

@implementation LightCeremonyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.topItem.title = @"The Light Ceremony";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onPairLocked:(NSArray *)lockedPair{
    [super onPairLocked:lockedPair];
    
    [self.lockedPairs addObject:lockedPair];
}

- (void)nameUnpressed:(id)sender{
    [super nameUnpressed:sender];
        
    if ((self.lockedPairs.count == self.guys.count) && !self.pressedGuy && !self.pressedGirl) {
        [self setColorSchemeDark:YES];
        self.cancelButton.enabled = NO;
        [self revealCorrectMatchCount];
    }
}

#pragma mark - Helpers
- (void)revealCorrectMatchCount{
    [self.activityIndicator startAnimating];
    self.lockLabel.text = @"0";
    
    int correctCount = 0;
    for (NSArray *pair in self.lockedPairs) {
        if ([self isMatch:pair]) {
            correctCount++;
        }
    }
    
    float waitSeconds = 0.0;
    for (int i = 0; i < correctCount; i++) {
        waitSeconds += [self randomWaitTime];
        
        [self.lockLabel performSelector:@selector(setText:) withObject:[NSString stringWithFormat:@"%i", (i + 1)] afterDelay:waitSeconds];
        
        [self performSelector:@selector(flashBackgroundToColor:) withObject:[UIColor yellowColor] afterDelay:waitSeconds];
    }
    
    int spinnerActiveTimeAfterLastBeam = waitSeconds;
    if (correctCount != self.guys.count) {
        spinnerActiveTimeAfterLastBeam += [self randomWaitTime] + FLASH_ANIMATION_DURATION;
    }

    [self.activityIndicator performSelector:@selector(stopAnimating) withObject:nil afterDelay:spinnerActiveTimeAfterLastBeam];
    [self performSelector:@selector(onCorrectMatchCountRevealed:) withObject:[NSNumber numberWithInt:correctCount] afterDelay:spinnerActiveTimeAfterLastBeam + 2];
}

- (int)randomWaitTime{
    return MINIMUM_REVEAL_WAIT_TIME + arc4random() % (MAXIMUM_REVEAL_WAIT_TIME - MINIMUM_REVEAL_WAIT_TIME);
}

- (void)flashBackgroundToColor:(UIColor *)color{
    UIColor *originalColor = self.view.backgroundColor;
    
    float onDuration = 0.1;
    [UIView animateWithDuration:onDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.view.backgroundColor = color;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:FLASH_ANIMATION_DURATION - onDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.view.backgroundColor = originalColor;
        } completion:nil];
    }];
}

- (void)onCorrectMatchCountRevealed:(NSNumber *)correctCount{
    [self.delegate lightCeremony:self didRevealCorrectMatchCount:[correctCount intValue]];
}

@end
