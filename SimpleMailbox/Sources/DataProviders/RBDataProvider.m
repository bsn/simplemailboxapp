//
//  RBDataProvider.m
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "RBDataProvider.h"
#import "RBNetworking.h"

static RBDataProvider *sSharedProvider = nil;

@implementation RBDataProvider

@synthesize networking = _networking;

#pragma mark -
#pragma mark *** Public Interface ***
#pragma mark -

+ (RBDataProvider *)sharedProvider
{
    if (sSharedProvider == nil)
        sSharedProvider = [[[self class] alloc] init];

    return sSharedProvider;
}

- (id)init
{
    self = [super init];

    if (self != nil)
    {
        _networking = [[RBNetworking alloc] init];
    }

    return self;
}

@end
