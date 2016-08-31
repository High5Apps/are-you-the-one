//
//  MatchVerifierVC.m
//  Are You the Onesie?
//
//  Created by Julian Tigler on 8/27/16.
//  Copyright © 2016 High5! Apps. All rights reserved.
//

#import "MatchVerifierVC.h"
#import "Colors.h"

#define LOCK_SECONDS 4

@interface MatchVerifierVC ()
@property (strong, nonatomic) NSArray *guys;
@property (strong, nonatomic) NSArray *girls;
@property (strong, nonatomic) NSDictionary *matches;
@property (strong, nonatomic) NSArray *pairColors;
@property (strong, nonatomic) NSMutableArray *guyButtons;
@property (strong, nonatomic) NSMutableArray *girlButtons;
@property (strong, nonatomic) NSMutableArray *lockedPairs;
@property (strong, nonatomic) NSString *pressedGuy;
@property (strong, nonatomic) NSString *pressedGirl;
@property (strong, nonatomic) NSTimer *lockTimer;
@property int lockTickCount;
@end

@implementation MatchVerifierVC

- (id)initWithGuys:(NSArray *)guys girls:(NSArray *)girls matches:(NSDictionary *)matches{
    self = [super initWithNibName:@"MatchVerifierVC" bundle:nil];
    if (self) {
        // Custom initialization
        self.guys = guys;
        self.girls = girls;
        self.matches = matches;
        self.lockedPairs = [NSMutableArray arrayWithCapacity:self.guys.count];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    self.cancelButton = cancelButton;
    
    [self addNameButtons];
    
    [self setColorSchemeDark:NO];
}

- (void)addNameButtons{
    float buttonHeight = 44.0;
    float margin = 0.0;
    
    self.guyButtons = [NSMutableArray arrayWithCapacity:self.guys.count];
    self.girlButtons = [NSMutableArray arrayWithCapacity:self.girls.count];
    
    for (UIScrollView *scrollView in @[self.guyScroller, self.girlScroller]) {
        NSArray *nameSource;
        NSMutableArray *buttonArray;
        if (scrollView == self.guyScroller) {
            nameSource = self.guys;
            buttonArray = self.guyButtons;
        }else{
            nameSource = self.girls;
            buttonArray = self.girlButtons;
        }
        
        float y = 0;
        for (int i = 0; i < nameSource.count; i++) {
            NSString *name = [nameSource objectAtIndex:i];
            y = i * (buttonHeight + margin);
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(0, y, scrollView.frame.size.width, buttonHeight);
            [button setTitle:name forState:UIControlStateNormal];
            [scrollView addSubview:button];
            
            [self addActionsToNameButton:button];

            [buttonArray addObject:button];
        }
        
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, y + buttonHeight);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addActionsToNameButton:(UIButton *)nameButton{
    [nameButton addTarget:self action:@selector(namePressedDown:) forControlEvents:UIControlEventTouchDown];
    [nameButton addTarget:self action:@selector(nameUnpressed:) forControlEvents:UIControlEventTouchUpInside];
    [nameButton addTarget:self action:@selector(nameUnpressed:) forControlEvents:UIControlEventTouchDragExit];
    [nameButton addTarget:self action:@selector(nameUnpressed:) forControlEvents:UIControlEventTouchCancel];
    
    [nameButton setEnabled:YES];
}

- (IBAction)cancelPressed:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)namePressedDown:(id)sender{
    UIButton *nameButton = (UIButton *)sender;
    NSString *name = nameButton.titleLabel.text;
    BOOL isGuy = [self.guyButtons containsObject:sender];
;
    
    if (isGuy) {
        self.pressedGuy = name;
        
        self.guyLabel.hidden = NO;
        self.guyLabel.text = name;
    }else{
        self.pressedGirl = name;
        
        self.girlLabel.hidden = NO;
        self.girlLabel.text = name;
    }
    
    if (self.pressedGirl && self.pressedGuy) {
        [self onLockCountdownBegan];
    }
}

- (void)onLockCountdownBegan{
    if (self.lockTimer) {
        [self.lockTimer invalidate];
        self.lockTimer = nil;
    }
    
    self.lockTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(lockTimerTick) userInfo:nil repeats:YES];
    self.lockTickCount = 0;
    [self lockTimerTick];
    
    [self setColorSchemeDark:YES];
    [self animateScanningLineView];
}

- (void)setColorSchemeDark:(BOOL)shouldBeDark{
    if (shouldBeDark) {
        self.view.backgroundColor = [UIColor blackColor];
        self.instructionLabel.textColor = [UIColor whiteColor];
        self.guyLabel.textColor = [UIColor whiteColor];
        self.girlLabel.textColor = [UIColor whiteColor];
        self.lockLabel.textColor = [UIColor whiteColor];
    }else{
        self.view.backgroundColor = [Colors lightBackgroundColor];
        self.instructionLabel.textColor = [UIColor blackColor];
        self.guyLabel.textColor = [UIColor blackColor];
        self.girlLabel.textColor = [UIColor blackColor];
        self.lockLabel.textColor = [UIColor blackColor];
    }
}

- (void)animateScanningLineView{
    CGPoint initialCenter = CGPointMake(self.scanningLineView.center.x, self.view.frame.size.height);
    self.scanningLineView.center = initialCenter;
    self.scanningLineView.hidden = NO;
    
    CGPoint topCenter = CGPointMake(self.scanningLineView.center.x, self.navigationBar.frame.origin.y + self.navigationBar.frame.size.height);
    
    float duration = 0.75;
    
    [UIView animateWithDuration:duration delay:0*duration options:UIViewAnimationOptionCurveLinear animations:^{
        self.scanningLineView.center = topCenter;
    } completion:nil];
    
    [UIView animateWithDuration:duration delay:1*duration options:UIViewAnimationOptionCurveLinear animations:^{
        self.scanningLineView.center = initialCenter;
    } completion:nil];
    
    [UIView animateWithDuration:duration delay:2*duration options:UIViewAnimationOptionCurveLinear animations:^{
        self.scanningLineView.center = topCenter;
    } completion:nil];
    
    [UIView animateWithDuration:duration delay:3*duration options:UIViewAnimationOptionCurveLinear animations:^{
        self.scanningLineView.center = initialCenter;
    } completion:^(BOOL finished) {
        self.scanningLineView.hidden = YES;
    }];
}

- (void)nameUnpressed:(id)sender{
    self.lockLabel.text = @"";
    
    BOOL isGuy = [self.guyButtons containsObject:sender];
    
    if (isGuy) {
        self.guyLabel.hidden = YES;
        self.pressedGuy = nil;
    }else{
        self.girlLabel.hidden = YES;
        self.pressedGirl = nil;
    }
    
    if (self.lockTimer && self.lockTickCount != LOCK_SECONDS) {
        [self onLockCountdownCanceled];
    }
}

- (void)onLockCountdownCanceled{
    [self.lockTimer invalidate];
    self.lockTimer = nil;
    
    [self setColorSchemeDark:NO];
    [self.scanningLineView.layer removeAllAnimations];
}

- (void)lockTimerTick{
    self.lockTickCount++;
    
    int secondsRemaining = LOCK_SECONDS - self.lockTickCount;
    
    if (secondsRemaining == 0) {
        self.lockLabel.text = @"🔒";
        [self onPairLocked:@[self.pressedGuy, self.pressedGirl]];
    }
}

- (BOOL)isMatch:(NSArray *)pair{
    return [self.matches objectForKey:pair[0]] == pair[1];
}

- (void)onPairLocked:(NSArray *)lockedPair{
    [self.lockTimer invalidate];
    self.lockTimer = nil;
    
    [self setColorSchemeDark:NO];
    
    UIButton *guyButton = [self buttonForName:lockedPair[0] isGuy:YES];
    UIButton *girlButton = [self buttonForName:lockedPair[1] isGuy:NO];
    
    UIColor *buttonColor = [self colorForPairNumber:(int)self.lockedPairs.count];
    [guyButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [girlButton setTitleColor:buttonColor forState:UIControlStateNormal];
    
    [guyButton setEnabled:NO];
    [girlButton setEnabled:NO];
}

- (UIButton *)buttonForName:(NSString *)name isGuy:(BOOL)isGuy{
    if (isGuy) {
        int i = (int)[self.guys indexOfObject:name];
        return [self.guyButtons objectAtIndex:i];
    }else{
        int i = (int)[self.girls indexOfObject:name];
        return [self.girlButtons objectAtIndex:i];
    }
}

- (UIColor *)colorForPairNumber:(int)pairNumber{
    if (!self.pairColors) {
        NSArray *firstPairColors = @[
                            [UIColor purpleColor],
                            [UIColor orangeColor],
                            [UIColor redColor],
                            [UIColor greenColor],
                            [UIColor cyanColor],
                            [UIColor yellowColor],
                            [UIColor brownColor]];
        
        NSMutableArray *pairColors = [NSMutableArray arrayWithCapacity:self.guys.count];
        for (int i = 0; i < self.guys.count; i++) {
            if (i < firstPairColors.count) {
                [pairColors addObject:[firstPairColors objectAtIndex:i]];
            }else {
                [pairColors addObject:[self randomColor]];
            }
        }
        
        self.pairColors = pairColors;
    }
    
    return [self.pairColors objectAtIndex:pairNumber];
}

- (UIColor *)randomColor{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
