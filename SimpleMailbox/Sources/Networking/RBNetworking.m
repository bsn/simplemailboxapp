//
//  RBNetworking.m
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "RBNetworking.h"
#import "TWStatus.h"

#define RB_BASE_URL @"http://rocket-ios.herokuapp.com/emails.json?page=%d"

@implementation RBNetworking

#pragma mark -
#pragma mark *** Public Interface ***
#pragma mark -

- (void)getEmailsForPage:(NSUInteger)page completionBlock:(void (^)(NSDictionary *result))completionBlock errorBlock:(void (^)(NSError *error))errorBlock
{
    if (completionBlock == nil || errorBlock == nil)
        NSAssert(0, @"Oops, empty blocks are not allowed!");

    [TWStatus showLoadingWithStatus:NSLocalizedString(@"Fetching emails...", @"")];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        @autoreleasepool
        {
            NSError *error = nil;
            NSDictionary *responseDict = nil;
            {
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:RB_BASE_URL, page]]];
                NSHTTPURLResponse *response = nil;
                NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

                // Connection Error Handling
                if (error != nil)
                    goto bail_out;

                responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                if (error != nil)
                    goto bail_out;

                if (error != nil || ![responseDict isKindOfClass:[NSDictionary class]])
                {
                    error = [NSError errorWithDomain:@"ServerError" code:500 userInfo:nil];
                    goto bail_out;
                }

                dispatch_sync(dispatch_get_main_queue(), ^{
                    [TWStatus dismiss];
                    completionBlock(responseDict);
                });
            }

        bail_out:;
            if (error != nil)
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [TWStatus dismiss];
                    errorBlock(error);
                });
        }

    });
}

@end
