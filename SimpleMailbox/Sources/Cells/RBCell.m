//
//  RBCell.m
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "RBCell.h"
#import "RBEmail.h"

#define RB_ARCHIVE_COLOR [UIColor colorWithRed:85.0/255.0 green:213.0/255.0 blue:80.0/255.0 alpha:1.0]
#define RB_DELETED_COLOR [UIColor colorWithRed:232.0/255.0 green:61.0/255.0 blue:14.0/255.0 alpha:1.0]
#define RB_MAILBOX_COLOR [UIColor colorWithRed:0.32f green:0.73f blue:0.86f alpha:1.00f]

@implementation RBCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self != nil)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleGray];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self setMode:MCSwipeTableViewCellModeExit];
    }

    return self;
}

#pragma mark -
#pragma mark *** Public Interface ***
#pragma mark -

- (void)setEmail:(RBEmail *)email
{
    self.textLabel.text = email.from;
    self.detailTextLabel.text = email.subject;

    [self setFirstStateIconName:(email.state == kRBEmailStateArchived) ? @"mailbox.png" : @"check.png"
                     firstColor:(email.state == kRBEmailStateArchived) ? RB_MAILBOX_COLOR : RB_ARCHIVE_COLOR
            secondStateIconName:nil
                    secondColor:nil
                  thirdIconName:(email.state == kRBEmailStateDeleted) ? @"mailbox.png" : @"cross.png"
                     thirdColor:(email.state == kRBEmailStateDeleted) ? RB_MAILBOX_COLOR : RB_DELETED_COLOR
                 fourthIconName:nil
                    fourthColor:nil];
}

@end
