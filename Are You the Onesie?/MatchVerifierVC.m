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
        
        self.pairColors = @[
                            [UIColor redColor],
                            [UIColor orangeColor],
                            [UIColor greenColor],
                            [UIColor cyanColor],
                            [UIColor purpleColor],
                            [UIColor yellowColor],
                            [UIColor brownColor],
                            [UIColor darkGrayColor]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.rightBarButtonItem = cancelButton;
    self.cancelButton = cancelButton;
    
    self.guyButtons = [NSMutableArray array];
    [self.guyButtons addObject:self.guy1];
    [self.guyButtons addObject:self.guy2];
    [self.guyButtons addObject:self.guy3];
    [self.guyButtons addObject:self.guy4];
    [self.guyButtons addObject:self.guy5];
    [self.guyButtons addObject:self.guy6];
    [self.guyButtons addObject:self.guy7];
    [self.guyButtons addObject:self.guy8];
    
    self.girlButtons = [NSMutableArray array];
    [self.girlButtons addObject:self.girl1];
    [self.girlButtons addObject:self.girl2];
    [self.girlButtons addObject:self.girl3];
    [self.girlButtons addObject:self.girl4];
    [self.girlButtons addObject:self.girl5];
    [self.girlButtons addObject:self.girl6];
    [self.girlButtons addObject:self.girl7];
    [self.girlButtons addObject:self.girl8];
    
    for (int i = 0; i < self.guys.count; i++) {
        UIButton *guyButton = [self.guyButtons objectAtIndex:i];
        [guyButton setTitle:(NSString *)[self.guys objectAtIndex:i] forState:UIControlStateNormal];
        [self addActionsToNameButton:guyButton];
        
        UIButton *girlButton = [self.girlButtons objectAtIndex:i];
        [girlButton setTitle:(NSString *)[self.girls objectAtIndex:i] forState:UIControlStateNormal];
        [self addActionsToNameButton:girlButton];
    }
    
    [self setColorSchemeDark:NO];
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

- (BOOL)isGuyFromSender:(id)sender{
    UIButton *button = (UIButton *)sender;
    int tag = (int)button.tag;
    return tag % 2 == 0;
}

- (UIButton *)buttonFromSender:(id)sender{
    UIButton *button = (UIButton *)sender;
    int tag = (int)button.tag;
    BOOL isGuy = tag % 2 == 0;
    int nameIndex = tag / 2;
    
    if (isGuy) {
        button = [self.guyButtons objectAtIndex:nameIndex];
    }else{
        button = [self.girlButtons objectAtIndex:nameIndex];
    }
    
    return button;
}

- (IBAction)cancelPressed:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)namePressedDown:(id)sender{
    UIButton *nameButton = [self buttonFromSender:sender];
    NSString *name = nameButton.titleLabel.text;
    BOOL isGuy = [self isGuyFromSender:sender];
    
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
    
    BOOL isGuy = [self isGuyFromSender:sender];
    
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
    
    UIColor *buttonColor = [self.pairColors objectAtIndex:self.lockedPairs.count];
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

@end
