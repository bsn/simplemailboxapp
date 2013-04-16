//
//  RBNetworking.m
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "RBNetworking.h"
#import "AFNetworking.h"
#import "TWStatus.h"

#define RB_BASE_URL @"http://rocket-ios.herokuapp.com/emails.json?page=%d"

@interface RBNetworking (Private)
- (BOOL)_isAlreadyQueued:(AFJSONRequestOperation*)opetation;
@end

@implementation RBNetworking

- (id)init
{
    self = [super init];

    if (self != nil)
    {
        _networkingQueue = [[NSOperationQueue alloc] init];
        [_networkingQueue setMaxConcurrentOperationCount:1]; // quite enough for this task
    }

    return self;
}

#pragma mark -
#pragma mark *** Public Interface ***
#pragma mark -

- (void)getEmailsForPage:(NSUInteger)page completionBlock:(void (^)(NSDictionary *result))completionBlock errorBlock:(void (^)(NSError *error))errorBlock
{
    if (completionBlock == nil || errorBlock == nil)
        NSAssert(0, @"Oops, empty blocks are not allowed!");

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:RB_BASE_URL, page]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        [TWStatus dismiss];
        if ([JSON isKindOfClass:[NSDictionary class]])
            completionBlock((NSDictionary *)JSON);
        else
            errorBlock([NSError errorWithDomain:@"ServerError" code:500 userInfo:nil]);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [TWStatus dismiss];
        errorBlock(error);
    }];

    if (![self _isAlreadyQueued:operation])
    {
        [TWStatus showLoadingWithStatus:NSLocalizedString(@"Fetching emails...", @"")];
        [_networkingQueue addOperation:operation];
    }
}

#pragma mark -
#pragma mark *** Private Interface ***
#pragma mark -

- (BOOL)_isAlreadyQueued:(AFJSONRequestOperation*)opetation
{
    for (AFJSONRequestOperation *op in [_networkingQueue operations])
        if ([[[[op request] URL] absoluteString] isEqualToString:[[[opetation request] URL] absoluteString]])
            return YES;

    return NO;
}

@end
