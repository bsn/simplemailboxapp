//
//  RBViewController.m
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 15.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "RBViewController.h"

@interface RBViewController (Private)
@end

@implementation RBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark *** UITableView Delegate / DataSource Interface ***
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"Cell";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
