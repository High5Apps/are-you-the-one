//
//  RoundVC.m
//  Are You the Onesie?
//
//  Created by Julian Tigler on 8/27/16.
//  Copyright © 2016 High5! Apps. All rights reserved.
//

#import "RoundVC.h"

#define KEY_TRUTH_BOOTH @"truth-booth-pair"
#define KEY_LIGHT_CEREMONY @"light-ceremony-count"

@interface RoundVC ()
@property (strong, nonatomic) NSArray *guys;
@property (strong, nonatomic) NSArray *girls;
@property (strong, nonatomic) NSDictionary *matches;
@property (strong, nonatomic) NSMutableDictionary *roundsInfo;
@property int roundNumber;
@property BOOL didWin;
//@property int correctMatchesCount;
@end

@implementation RoundVC

- (id)initWithGuys:(NSArray *)guys girls:(NSArray *)girls matches:(NSDictionary *)matches{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Custom initialization
        self.guys = guys;
        self.girls = girls;
        self.matches = matches;
        
        self.roundsInfo = [NSMutableDictionary dictionaryWithObject:[NSMutableDictionary dictionary] forKey:[NSNumber numberWithInt:1]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setRound:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)previousRoundPressed:(id)sender{
    [self setRound:self.roundNumber - 1];
}

- (IBAction)nextRoundPressed:(id)sender{
    [self setRound:self.roundNumber + 1];
}

- (IBAction)truthBoothPressed:(id)sender{
    TruthBoothVC *truthBoothVC = [[TruthBoothVC alloc] initWithGuys:self.guys girls:self.girls matches:self.matches];
    truthBoothVC.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:truthBoothVC];
    navigationController.navigationBar.translucent = NO;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)lightCeremonyPressed:(id)sender{
    LightCeremonyVC *lightCeremonyVC = [[LightCeremonyVC alloc] initWithGuys:self.guys girls:self.girls matches:self.matches];
    lightCeremonyVC.delegate = self;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:lightCeremonyVC];
    navigationController.navigationBar.translucent = NO;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)quitPressed:(id)sender{
    if (self.didWin) {
        [self.delegate roundVCRequestedNewGame:self];
    }else{
        UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                                       message:@"Are you sure you want to quit?"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        [actionSheet addAction:cancelAction];
        
        UIAlertAction* quitAction = [UIAlertAction actionWithTitle:@"Quit" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self.delegate roundVCRequestedNewGame:self];
        }];
        [actionSheet addAction:quitAction];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}

#pragma mark - Helpers
- (void)setRound:(int)roundNumber{
    self.roundNumber = roundNumber;
    
    NSDictionary *roundInfo = [self.roundsInfo objectForKey:[NSNumber numberWithInt:roundNumber]];
    
    self.title = [NSString stringWithFormat:@"Round: %i", roundNumber];
    
    self.previousRoundButton.enabled = (self.roundNumber > 1);
    self.nextRoundButton.enabled = [self.roundsInfo objectForKey:[NSNumber numberWithInt:roundNumber + 1]];
    
    // Truth Booth
    NSArray *pair = [roundInfo objectForKey:KEY_TRUTH_BOOTH];
    self.truthBoothButton.enabled = (pair == nil);
    self.pairLabel.hidden = (pair == nil);
    self.wasMatchLabel.hidden = (pair == nil);
    
    if (pair) {
        [self setTruthBoothInfoForPair:pair];
    }
    
    // Light Ceremony
    self.lightCeremonyInstructions.hidden = (pair == nil);
    self.lightCeremonyButton.hidden = (pair == nil);
    
    NSNumber *correctMatches = [roundInfo objectForKey:KEY_LIGHT_CEREMONY];
    self.lightCeremonyButton.enabled = (pair != nil) && (correctMatches == nil);
    self.perfectMatchLabel.hidden = (correctMatches == nil);
    self.perfectMatchCountLabel.hidden = (correctMatches == nil);
    self.nextRoundInstructions.hidden = (correctMatches == nil) || self.didWin;
    self.youWinLabel.hidden = (correctMatches == nil) || !self.didWin;
    
    if (correctMatches) {
        self.perfectMatchCountLabel.text = [NSString stringWithFormat:@"%@", correctMatches];
    }
    
    BOOL isGuysRound = self.roundNumber % 2 == 0;
    
    NSString *gender;
    if (isGuysRound) {
        gender = @"guys";
    }else {
        gender = @"girls";
    }
    
    int pairCount = (int)self.guys.count;
    
    self.lightCeremonyInstructions.text = [NSString stringWithFormat:@"This round, the %@ get to pick who they think their perfect match is. If all %i lights are illuminated, you're all going home with...\nONE MILLION DOLLARS!!!", gender, pairCount];
}

- (void)setTruthBoothInfoForPair:(NSArray *)pair{
    self.pairLabel.hidden = NO;
    self.wasMatchLabel.hidden = NO;
    
    self.pairLabel.text = [NSString stringWithFormat:@"%@ and %@:", pair[0], pair[1]];
    
    BOOL isMatch = [self.matches objectForKey:pair[0]] == pair[1];
    
    NSString *matchText;
    UIColor *matchColor;
    if (isMatch) {
        matchText = @"Match!";
        matchColor = [UIColor greenColor];
    }else {
        matchText = @"No Match!";
        matchColor = [UIColor redColor];
    }
    self.wasMatchLabel.text = matchText;
    self.wasMatchLabel.textColor = matchColor;
}

#pragma mark - TruthBoothDelegate methods
- (void)truthBooth:(MatchVerifierVC *)sender didRevealPair:(NSArray *)pair asMatch:(BOOL)wasMatch{
    [[self.roundsInfo objectForKey:[NSNumber numberWithInt:self.roundNumber]] setObject:pair forKey:KEY_TRUTH_BOOTH];
    
    [self setTruthBoothInfoForPair:pair];
    
    self.truthBoothButton.enabled = NO;
    self.lightCeremonyInstructions.hidden = NO;
    self.lightCeremonyButton.enabled = YES;
    self.lightCeremonyButton.hidden = NO;

    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LightCeremonyDelegate methods
- (void)lightCeremony:(LightCeremonyVC *)sender didRevealCorrectMatchCount:(int)correctMatchCount{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.didWin = (correctMatchCount == self.guys.count);
    [[self.roundsInfo objectForKey:[NSNumber numberWithInt:self.roundNumber]] setObject:[NSNumber numberWithInt:correctMatchCount] forKey:KEY_LIGHT_CEREMONY];
    
    self.lightCeremonyButton.enabled = NO;
    self.perfectMatchLabel.hidden = NO;
    self.perfectMatchCountLabel.text = [NSString stringWithFormat: @"%i", correctMatchCount];
    self.perfectMatchCountLabel.hidden = NO;
    
    self.nextRoundInstructions.hidden = self.didWin;
    self.youWinLabel.hidden = !self.didWin;
    
    if (self.didWin) {
        [self.quitButton setTitle:@"New Game" forState:UIControlStateNormal];
    }else {
        [self.roundsInfo setObject:[NSMutableDictionary dictionary] forKey:[NSNumber numberWithInt:self.roundNumber + 1]];
        self.nextRoundButton.enabled = YES;
    }
}

@end
