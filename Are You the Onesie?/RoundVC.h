//
//  RoundVC.h
//  Are You the Onesie?
//
//  Created by Julian Tigler on 8/27/16.
//  Copyright © 2016 High5! Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TruthBoothVC.h"
#import "LightCeremonyVC.h"

@class RoundVC;

@protocol RoundVCDelegate <NSObject>
- (void)roundVCRequestedNewGame:(RoundVC *)sender;
@end

@interface RoundVC : UIViewController<TruthBoothDelegate, LightCeremonyDelegate>

@property (weak, nonatomic) IBOutlet UILabel *roundLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextRoundButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousRoundButton;
@property (weak, nonatomic) IBOutlet UIButton *truthBoothButton;
@property (weak, nonatomic) IBOutlet UILabel *pairLabel;
@property (weak, nonatomic) IBOutlet UILabel *wasMatchLabel;
@property (weak, nonatomic) IBOutlet UITextView *lightCeremonyInstructions;
@property (weak, nonatomic) IBOutlet UIButton *lightCeremonyButton;
@property (weak, nonatomic) IBOutlet UILabel *perfectMatchLabel;
@property (weak, nonatomic) IBOutlet UILabel *perfectMatchCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *nextRoundInstructions;
@property (weak, nonatomic) IBOutlet UILabel *youWinLabel;
@property (weak, nonatomic) IBOutlet UIButton *quitButton;

@property (strong, nonatomic) id<RoundVCDelegate> delegate;

- (id)initWithGuys:(NSArray *)guys girls:(NSArray *)girls matches:(NSDictionary *)matches;

- (IBAction)nextRoundPressed:(id)sender;
- (IBAction)previousRoundPressed:(id)sender;
- (IBAction)truthBoothPressed:(id)sender;
- (IBAction)lightCeremonyPressed:(id)sender;
- (IBAction)quitPressed:(id)sender;

@end
