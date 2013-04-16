//
//  RBDataProvider.h
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RBEmail.h"

@class RBNetworking;
@class RBPagination;

@protocol RBDataProviderDelegate <NSObject>
@required
- (void)emailsDidFetched:(BOOL)hasMore;
- (void)emailsFetchingFailedWithError:(NSError *)error;
@end

@interface RBDataProvider : NSObject
{
@private
    __strong RBNetworking *_networking;
    __strong RBPagination *_pagination;
    __strong NSMutableArray *_emails;
    __strong NSMutableDictionary *_filteredEmails;
}

@property (nonatomic, weak) id <RBDataProviderDelegate> delegate;

+ (RBDataProvider *)sharedProvider;

- (NSArray *)emailsForState:(RBEmailState)state;

- (void)getEmails;
- (BOOL)loadMore;

- (void)save;
- (void)restore;
- (void)reset;

@end
