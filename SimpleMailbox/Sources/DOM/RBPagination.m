//
//  RBPagination.m
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "RBPagination.h"

#define RB_PER_PAGE_KEY @"per_page"
#define RB_CUR_PAGE_KEY @"current_page"
#define RB_TOTAL_PAGES_KEY @"total"

@implementation RBPagination

@synthesize perPage = _perPage;
@synthesize currentPage = _currentPage;
@synthesize totalPages = _totalPages;

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];

    if (self != nil)
    {
        if (![dict isKindOfClass:[NSDictionary class]])
            dict = nil;

        _perPage = [[dict objectForKey:RB_PER_PAGE_KEY] integerValue];
        _currentPage = [[dict objectForKey:RB_CUR_PAGE_KEY] integerValue];
        _totalPages = [[dict objectForKey:RB_TOTAL_PAGES_KEY] integerValue];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[NSNumber numberWithInt:_perPage] forKey:RB_PER_PAGE_KEY];
    [encoder encodeObject:[NSNumber numberWithInt:_currentPage] forKey:RB_CUR_PAGE_KEY];
    [encoder encodeObject:[NSNumber numberWithInt:_totalPages] forKey:RB_TOTAL_PAGES_KEY];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];

    if (self != nil)
    {
        _perPage = [[decoder decodeObjectForKey:RB_PER_PAGE_KEY] integerValue];
        _currentPage = [[decoder decodeObjectForKey:RB_CUR_PAGE_KEY] integerValue];;
        _totalPages = [[decoder decodeObjectForKey:RB_TOTAL_PAGES_KEY] integerValue];;
    }

    return self;
}

@end
