//
//  RBViewController.h
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 15.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RBViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
@private
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
