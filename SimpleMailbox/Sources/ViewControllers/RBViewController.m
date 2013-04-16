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
- (NSArray*)_emails;
@end

@implementation RBViewController

- (void)dealloc
{
    [RBDataProvider sharedProvider].delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (_segmentedControl == nil)
    {
        _segmentedControl = [[RBCustomSegmentedControl alloc] initWithSegmentCount:3 segmentsize:CGSizeMake(53., 32.) dividerImage:nil tag:0 delegate:self];
        _segmentedControl.selectedItem = 1;
        [self.topBarView addSubview:_segmentedControl];
        _segmentedControl.center = CGPointMake(CGRectGetMidX(self.topBarView.bounds), CGRectGetMidY(self.topBarView.bounds));
    }

    _selectedState = kRBEmailStateInbox;

    [self.tableView addInfiniteScrollingWithActionHandler:^{ [[RBDataProvider sharedProvider] loadMore]; }];

    [RBDataProvider sharedProvider].delegate = self;
    [self.tableView reloadData];
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
    _segmentedControl.selectedItem = 1;
    [[RBDataProvider sharedProvider] getEmails];
}

#pragma mark -
#pragma mark *** RBDataProvider Delegate Interface ***
#pragma mark -

- (void)emailsDidFetched:(BOOL)hasMore
{
    _emails = nil;
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
    return [[self _emails] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    RBCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil)
        cell = [[RBCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(RBCell *)cell setDelegate:self];
    [(RBCell *)cell setEmail:[[self _emails] objectAtIndex:indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark *** MCSwipeTableViewCell Delegate Interface ***
#pragma mark -

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didTriggerState:(MCSwipeTableViewCellState)state withMode:(MCSwipeTableViewCellMode)mode
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    RBEmail *email = [[self _emails] objectAtIndex:indexPath.row];
    RBEmailState emailState = [RBEmail stateForTriggerState:state];
    email.state = (emailState == _selectedState) ? kRBEmailStateInbox : emailState;

    _emails = nil;
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    [[RBDataProvider sharedProvider] save];
}

#pragma mark -
#pragma mark *** RBCustomSegmentedControl Delegate Interface ***
#pragma mark -

- (void)touchUpInsideSegmentIndex:(NSUInteger)segmentIndex
{
    _emails = nil;
    _selectedState = [RBEmail stateForSegmentIndex:segmentIndex];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark *** Private Interface ***
#pragma mark -

- (NSArray*)_emails
{
    if ([_emails count] == 0)
        _emails = [[RBDataProvider sharedProvider] emailsForState:_selectedState];

    return _emails;
}

@end
