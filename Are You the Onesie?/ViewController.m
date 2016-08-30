//
//  ViewController.m
//  Are You the Onesie?
//
//  Created by Julian Tigler on 8/27/16.
//  Copyright © 2016 High5! Apps. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *guys;
@property (strong, nonatomic) NSMutableArray *girls;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.guys = [NSMutableArray array];
    self.girls = [NSMutableArray array];
    
    self.nameField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBActions

- (IBAction)addPressed:(id)sender {
    NSString *name = self.nameField.text;
    [self addName:name isGuy:[self shouldAddGuy]];
    
    self.nameField.text = @"";
    self.addButton.enabled = [self shouldEnableAddButton];
    
    if ([self shouldAddGuy]) {
        [self.addButton setTitle:@"Add guy" forState:UIControlStateNormal];
    }else {
        [self.addButton setTitle:@"Add girl" forState:UIControlStateNormal];
    }
}

- (IBAction)startPressed:(id)sender{
    NSDictionary *matches = [self initializeMatchesWithGuys:self.guys andGirls:self.girls];
    NSLog(@"matches: %@", matches);
    
    RoundVC *roundVC = [[RoundVC alloc] initWithGuys:self.guys girls:self.girls matches:matches];
    roundVC.delegate = self;
    [self presentViewController:roundVC animated:YES completion:nil];
}

- (IBAction)testPressed:(id)sender{
    [self.guys removeAllObjects];
    [self.girls removeAllObjects];
    
    [self.guys addObject:@"Jeb"];
    [self.guys addObject:@"Mason"];
    [self.guys addObject:@"Shane"];
    [self.guys addObject:@"Joe"];
    [self.guys addObject:@"Julian"];
    [self.guys addObject:@"Adam"];
    [self.guys addObject:@"Frank"];
    [self.guys addObject:@"John"];
    
    [self.girls addObject:@"Catherine"];
    [self.girls addObject:@"Caitlin"];
    [self.girls addObject:@"Kelly"];
    [self.girls addObject:@"Hollie"];
    [self.girls addObject:@"Nora"];
    [self.girls addObject:@"Mike"];
    [self.girls addObject:@"Laura"];
    [self.girls addObject:@"Amber"];
    
    self.startButton.enabled = [self shouldEnableStart];
    [self.guyTable reloadData];
    [self.girlTable reloadData];
}

- (IBAction)nameFieldChanged:(id)sender{
    self.addButton.enabled = [self shouldEnableAddButton];
}

#pragma mark - Helpers

- (void)addName:(NSString *)name isGuy:(BOOL)isGuy{
    if (isGuy) {
        [self.guys addObject:name];
    }else{
        [self.girls addObject:name];
    }
    
    self.startButton.enabled = [self shouldEnableStart];
    [self.guyTable reloadData];
    [self.girlTable reloadData];
}

- (BOOL)shouldEnableStart{
    return (self.guys.count >= 3) && (self.guys.count == self.girls.count);
}

- (BOOL)shouldEnableAddButton{
    NSString *name = self.nameField.text;
    return (name.length > 0) && ![self.guys containsObject:name] && ![self.girls containsObject:name] && (self.guys.count < 8);
}

- (BOOL)shouldAddGuy{
    return self.guys.count == self.girls.count;
}

- (NSDictionary *)initializeMatchesWithGuys:(NSArray *)guys andGirls:(NSArray *)girls{    
    NSArray *shuffledGuys = [self shuffleArray:guys];
    NSArray *shuffledGirls = [self shuffleArray:girls];
    
    NSMutableDictionary *matches = [NSMutableDictionary dictionaryWithCapacity:shuffledGuys.count];
    for (int i = 0; i < shuffledGuys.count; i++) {
        [matches setObject:shuffledGirls[i] forKey:shuffledGuys[i]];
    }
    
    return matches;
}

- (NSArray *)shuffleArray:(NSArray *)array{
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:array];
    
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    
    return mutableArray;
}

#pragma mark - RoundVCDelegate methods
- (void)roundVCRequestedNewGame:(RoundVC *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.guys removeAllObjects];
    [self.girls removeAllObjects];
    
    self.startButton.enabled = [self shouldEnableStart];
    [self.guyTable reloadData];
    [self.girlTable reloadData];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.guyTable) {
        return self.guys.count;
    }else if (tableView == self.girlTable){
        return self.girls.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"HighScoresCell";
    
    UITableViewCell *nameCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!nameCell) {
        nameCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    BOOL isGuyCell = (tableView == self.guyTable);
    
    NSString *name;
    if (isGuyCell) {
        name = [self.guys objectAtIndex:indexPath.row];
    }else{
        name = [self.girls objectAtIndex:indexPath.row];
    }
    
    [nameCell.textLabel setText:name];
    
    return nameCell;
}

#pragma mark - UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([self shouldEnableAddButton]) {
        [self addPressed:self.addButton];
    }
    
    return YES;
}

@end
