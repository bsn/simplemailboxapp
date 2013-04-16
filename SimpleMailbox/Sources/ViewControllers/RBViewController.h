//
//  RBViewController.h
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 15.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBCustomSegmentedControl.h"
#import "RBDataProvider.h"
#import "RBEmail.h"
#import "RBCell.h"

@interface RBViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RBDataProviderDelegate, MCSwipeTableViewCellDelegate, RBCustomSegmentedControlDelegate>
{
@private
    RBCustomSegmentedControl *_segmentedControl;
    RBEmailState _selectedState;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *topBarView;
@property (nonatomic, strong) IBOutlet UIButton *refreshButton;

- (IBAction)refreshAction:(id)sender;

@end
