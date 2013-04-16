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
        
        [self restore];
        
        if ([_emails count] == 0)
            [self getEmails];
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

- (BOOL)loadMore
{
    if (_pagination.currentPage < _pagination.totalPages)
    {
        [self _getEmailsForPage:(_pagination.currentPage + 1)];
        return YES;
    }
    else
        return NO;
}

- (void)save
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for (RBEmail *email in _emails)
    {
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:email];
        [array addObject:encodedObject];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"emails"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)restore
{
    [_emails removeAllObjects];
    
    for (NSData *data in [[NSUserDefaults standardUserDefaults] objectForKey:@"emails"])
    {
        RBEmail *email = (RBEmail *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        [_emails addObject:email];
    }
}

- (void)reset
{
    [_emails removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"emails"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
        
        [self save];

        _pagination = [[RBPagination alloc] initWithDict:[result objectForKey:@"pagination"]];

        // Note: Hack to deal with pagination issue, when current_page < total, but emails array is empty => no need to load more next time
        BOOL hasMore = [[result objectForKey:@"emails"] count] > 0;
        if (!hasMore)
            _pagination.currentPage = _pagination.totalPages;

        if ([self.delegate conformsToProtocol:@protocol(RBDataProviderDelegate)])
            [self.delegate emailsDidFetched:hasMore];
    } errorBlock:^(NSError *error) {
        if ([self.delegate conformsToProtocol:@protocol(RBDataProviderDelegate)])
            [self.delegate emailsFetchingFailedWithError:error];
    }];
}

@end
