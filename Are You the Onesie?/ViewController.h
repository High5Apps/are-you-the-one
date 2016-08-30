//
//  ViewController.h
//  Are You the Onesie?
//
//  Created by Julian Tigler on 8/27/16.
//  Copyright © 2016 High5! Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundVC.h"

@interface ViewController : UIViewController<RoundVCDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *startButton;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *guyTable;
@property (weak, nonatomic) IBOutlet UITableView *girlTable;

- (IBAction)startPressed:(id)sender;
- (IBAction)testPressed:(id)sender;
- (IBAction)addPressed:(id)sender;
- (IBAction)nameFieldChanged:(id)sender;

@end

