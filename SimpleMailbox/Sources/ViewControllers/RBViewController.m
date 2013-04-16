//
//  RBViewController.m
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 15.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "RBViewController.h"
#import "SVPullToRefresh.h"

@interface RBViewController (Private)
@end

@implementation RBViewController

- (void)dealloc
{
    [RBDataProvider sharedProvider].delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _selectedState = kRBEmailStateInbox;

    [RBDataProvider sharedProvider].delegate = self;

    self.tableView.hidden = YES;
    [self.tableView addInfiniteScrollingWithActionHandler:^{ [[RBDataProvider sharedProvider] loadMore]; }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [[RBDataProvider sharedProvider] getEmails];
}

- (void)viewDidUnload
{
    [RBDataProvider sharedProvider].delegate = nil;

    [super viewDidUnload];
}

#pragma mark -
#pragma mark *** Public Interface ***
#pragma mark -

- (IBAction)refreshAction:(id)sender
{
    [[RBDataProvider sharedProvider] reset];
    [self.tableView reloadData];
    [[RBDataProvider sharedProvider] getEmails];    
}

#pragma mark -
#pragma mark *** RBDataProvider Delegate Interface ***
#pragma mark -

- (void)emailsDidFetched:(BOOL)hasMore
{
    self.tableView.hidden = NO;
    [self.tableView.infiniteScrollingView stopAnimating];
    self.tableView.showsInfiniteScrolling = hasMore;
    [self.tableView reloadData];
}

- (void)emailsFetchingFailedWithError:(NSError *)error
{
    NSString *messageText = [[error userInfo] objectForKey:NSLocalizedDescriptionKey];
    if (messageText == nil)
        messageText = [NSString stringWithFormat:@"%@ - %d", [error domain], [error code]];

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:messageText message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil];
    [alertView show];
}

#pragma mark -
#pragma mark *** UITableView Delegate / DataSource Interface ***
#pragma mark -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[RBDataProvider sharedProvider] emailsForState:_selectedState] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    RBCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil)
        cell = [[RBCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];

    cell.delegate = self;

    RBEmail *email = [[[RBDataProvider sharedProvider] emailsForState:_selectedState] objectAtIndex:indexPath.row];
    cell.textLabel.text = email.from;
    cell.detailTextLabel.text = email.subject;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}

#pragma mark -
#pragma mark *** MCSwipeTableViewCell Delegate Interface ***
#pragma mark -

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    RBEmail *email = [[[RBDataProvider sharedProvider] emailsForState:_selectedState] objectAtIndex:indexPath.row];
    email.state = (RBEmailState)state;
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
