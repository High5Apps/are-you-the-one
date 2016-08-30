//
//  LightCeremonyVC.h
//  Are You the Onesie?
//
//  Created by Julian Tigler on 8/28/16.
//  Copyright © 2016 High5! Apps. All rights reserved.
//

#import "MatchVerifierVC.h"

@class LightCeremonyVC;

@protocol LightCeremonyDelegate <NSObject>
- (void)lightCeremony:(LightCeremonyVC *)sender didRevealCorrectMatchCount:(int)correctMatchCount;
@end

@interface LightCeremonyVC : MatchVerifierVC

@property (strong, nonatomic) id<LightCeremonyDelegate> delegate;

@end
