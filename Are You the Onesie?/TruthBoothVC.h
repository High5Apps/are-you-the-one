//
//  TruthBoothVC.h
//  Are You the Onesie?
//
//  Created by Julian Tigler on 8/28/16.
//  Copyright © 2016 High5! Apps. All rights reserved.
//

#import "MatchVerifierVC.h"

@class TruthBoothVC;

@protocol TruthBoothDelegate <NSObject>
- (void)truthBooth:(TruthBoothVC *)sender didRevealPair:(NSArray *)pair asMatch:(BOOL)wasMatch;
@end

@interface TruthBoothVC : MatchVerifierVC

@property (strong, nonatomic) id<TruthBoothDelegate> delegate;

@end
