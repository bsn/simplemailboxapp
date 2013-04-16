//
//  RBCell.m
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "RBCell.h"

@implementation RBCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self != nil)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleGray];

        // We need to provide the icon names and the desired colors
        [self setFirstStateIconName:@"check.png"
                         firstColor:[UIColor colorWithRed:85.0/255.0 green:213.0/255.0 blue:80.0/255.0 alpha:1.0]
                secondStateIconName:nil
                        secondColor:nil
                      thirdIconName:@"cross.png"
                         thirdColor:[UIColor colorWithRed:232.0/255.0 green:61.0/255.0 blue:14.0/255.0 alpha:1.0]
                     fourthIconName:nil
                        fourthColor:nil];

        // We need to set a background to the content view of the cell
        [self.contentView setBackgroundColor:[UIColor whiteColor]];

        // Setting the type of the cell
        [self setMode:MCSwipeTableViewCellModeExit];
    }

    return self;
}

@end
