//
//  RBDataProvider.m
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "RBDataProvider.h"
#import "RBNetworking.h"
#import "RBPagination.h"

static RBDataProvider *sSharedProvider = nil;

@interface RBDataProvider (Private)
- (void)_getEmailsForPage:(NSInteger)page;
@end

@implementation RBDataProvider

- (id)init
{
    self = [super init];

    if (self != nil)
    {
        _emails = [[NSMutableArray alloc] initWithCapacity:0];
        _networking = [[RBNetworking alloc] init];
    }

    return self;
}

#pragma mark -
#pragma mark *** Public Interface ***
#pragma mark -

+ (RBDataProvider *)sharedProvider
{
    if (sSharedProvider == nil)
        sSharedProvider = [[[self class] alloc] init];

    return sSharedProvider;
}

- (NSArray *)emailsForState:(RBEmailState)state
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state == %d", state];
    NSArray *emails = [_emails filteredArrayUsingPredicate:predicate];

    return emails;
}

- (void)getEmails
{
    [self _getEmailsForPage:0];
}

- (void)loadMore
{
    if (_pagination.currentPage < _pagination.totalPages)
        [self _getEmailsForPage:(_pagination.currentPage + 1)];
}

- (void)reset
{
    [_emails removeAllObjects];
}

#pragma mark -
#pragma mark *** Private Interface ***
#pragma mark -

- (void)_getEmailsForPage:(NSInteger)page
{
    [_networking getEmailsForPage:page completionBlock:^(NSDictionary *result) {
        if (page == 0)
        {
            [_emails removeAllObjects];
            _pagination = nil;
        }

        for (NSDictionary* dict in [result objectForKey:@"emails"])
        {
            RBEmail *email = [[RBEmail alloc] initWithDict:dict];
            [_emails addObject:email];
        }

        _pagination = [[RBPagination alloc] initWithDict:[result objectForKey:@"pagination"]];

        if ([self.delegate conformsToProtocol:@protocol(RBDataProviderDelegate)])
            [self.delegate emailsDidFetched];
    } errorBlock:^(NSError *error) {
        if ([self.delegate conformsToProtocol:@protocol(RBDataProviderDelegate)])
            [self.delegate emailsFetchingFailedWithError:error];
    }];
}

@end
