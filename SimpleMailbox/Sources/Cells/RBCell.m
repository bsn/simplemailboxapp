//
//  RBCell.m
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "RBCell.h"
#import "RBEmail.h"
#import <QuartzCore/QuartzCore.h>

#define RB_ARCHIVE_COLOR [UIColor colorWithRed:0.38f green:0.85f blue:0.38f alpha:1.00f]
#define RB_DELETED_COLOR [UIColor colorWithRed:1.00f green:0.87f blue:0.27f alpha:1.00f]
#define RB_MAILBOX_COLOR [UIColor colorWithRed:0.32f green:0.73f blue:0.86f alpha:1.00f]

#define RB_TOP_LABEL_COLOR [UIColor colorWithRed:0.25f green:0.25f blue:0.25f alpha:1.00f]
#define RB_SUBJ_LABEL_COLOR [UIColor colorWithRed:0.07f green:0.07f blue:0.07f alpha:1.00f]
#define RB_BODY_LABEL_COLOR [UIColor colorWithRed:0.56f green:0.56f blue:0.56f alpha:1.00f]
#define RB_DATE_LABEL_COLOR [UIColor colorWithRed:0.48f green:0.48f blue:0.48f alpha:1.00f];
#define RB_COUNTER_LABEL_TEXT_COLOR [UIColor whiteColor]
#define RB_COUNTER_LABEL_BG_COLOR [UIColor colorWithRed:0.53f green:0.53f blue:0.53f alpha:1.00f]
#define RB_SEPARATOR_COLOR [UIColor colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.00f]

@implementation RBCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self != nil)
    {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self setMode:MCSwipeTableViewCellModeExit];

        _topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _topLabel.backgroundColor = [UIColor clearColor];
        _topLabel.numberOfLines = 1;
        _topLabel.font = [UIFont fontWithName:@"ChevinCyrillic-Light" size:15.];
        _topLabel.textColor = RB_TOP_LABEL_COLOR;
        [self.contentView addSubview:_topLabel];

        _subjLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subjLabel.backgroundColor = [UIColor clearColor];
        _subjLabel.numberOfLines = 1;
        _subjLabel.font = [UIFont fontWithName:@"ChevinCyrillic-Bold" size:16.];
        _subjLabel.textColor = RB_SUBJ_LABEL_COLOR;
        [self.contentView addSubview:_subjLabel];

        _bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _bodyLabel.backgroundColor = [UIColor clearColor];
        _bodyLabel.numberOfLines = 2;
        _bodyLabel.lineBreakMode = UILineBreakModeWordWrap;
        _bodyLabel.font = [UIFont fontWithName:@"ChevinCyrillic-Light" size:16.];
        _bodyLabel.textColor = RB_BODY_LABEL_COLOR;
        [self.contentView addSubview:_bodyLabel];

        _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.numberOfLines = 1;
        _dateLabel.textAlignment = UITextAlignmentRight;
        _dateLabel.font = [UIFont fontWithName:@"ChevinCyrillic-Light" size:15.];
        _dateLabel.textColor = RB_DATE_LABEL_COLOR;
        [self.contentView addSubview:_dateLabel];

        _counterLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _counterLabel.backgroundColor = RB_COUNTER_LABEL_BG_COLOR;
        _counterLabel.numberOfLines = 1;
        _counterLabel.font = [UIFont fontWithName:@"ChevinCyrillic-Bold" size:13.];
        _counterLabel.textColor = RB_COUNTER_LABEL_TEXT_COLOR;
        _counterLabel.textAlignment = UITextAlignmentCenter;
        _counterLabel.opaque = YES;
        _counterLabel.layer.cornerRadius = 4.;
        [self.contentView addSubview:_counterLabel];

        _favImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fav-icon"]];
        _favImageView.hidden = YES;
        [self.contentView addSubview:_favImageView];

        _rightIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        [self.contentView addSubview:_rightIconView];

        _separatorLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _separatorLineView.backgroundColor = RB_SEPARATOR_COLOR;
        [self.contentView addSubview:_separatorLineView];
    }

    return self;
}

#pragma mark -
#pragma mark *** Public Interface ***
#pragma mark -

- (void)setEmail:(RBEmail *)email
{
    _topLabel.text = email.titleStr;
    _subjLabel.text = email.subject;
    _bodyLabel.text = email.body;
    _favImageView.hidden = !email.starred;
    _dateLabel.text = email.dateStr;
    _counterLabel.text = [NSString stringWithFormat:@"%d", email.messages];
    _counterLabel.hidden = (email.messages <= 1);

    [self setFirstStateIconName:(email.state == kRBEmailStateArchived) ? @"mailbox.png" : @"check.png"
                     firstColor:(email.state == kRBEmailStateArchived) ? RB_MAILBOX_COLOR : RB_ARCHIVE_COLOR
            secondStateIconName:nil
                    secondColor:nil
                  thirdIconName:(email.state == kRBEmailStateDeleted) ? @"mailbox.png" : @"cross.png"
                     thirdColor:(email.state == kRBEmailStateDeleted) ? RB_MAILBOX_COLOR : RB_DELETED_COLOR
                 fourthIconName:nil
                    fourthColor:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat marginTop = 3.;
    CGFloat textOffsetLeft = 32.;

    _favImageView.frame = CGRectMake(7., rintf((CGRectGetHeight(self.contentView.bounds) - _favImageView.image.size.height) / 2.), _favImageView.image.size.width, _favImageView.image.size.height);
    CGSize counterSize = [_counterLabel.text sizeWithFont:_counterLabel.font];
    counterSize.width += 7.; // extra padding
    counterSize.height += 2.; // extra padding
    _counterLabel.frame = CGRectMake(294. - counterSize.width, rintf((CGRectGetHeight(self.contentView.bounds) - counterSize.height) / 2.), counterSize.width, counterSize.height);
    _rightIconView.frame = CGRectMake(303., rintf((CGRectGetHeight(self.contentView.bounds) - _rightIconView.image.size.height) / 2.), _rightIconView.image.size.width, _rightIconView.image.size.height);
    _topLabel.frame = CGRectMake(textOffsetLeft, marginTop, 208., [@"A" sizeWithFont:_topLabel.font].height);
    CGFloat textWidth = !_counterLabel.hidden ? 235. : (CGRectGetMaxX(_counterLabel.frame) - textOffsetLeft);
    _subjLabel.frame = CGRectMake(textOffsetLeft, CGRectGetMaxY(_topLabel.frame) - 2., textWidth, [@"A" sizeWithFont:_subjLabel.font].height);
    _bodyLabel.frame = CGRectMake(textOffsetLeft, CGRectGetMaxY(_subjLabel.frame) - 2., textWidth, [@"A" sizeWithFont:_bodyLabel.font].height * 2.);
    _dateLabel.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds) - 80, marginTop, 63., [@"A" sizeWithFont:_dateLabel.font].height);
    _separatorLineView.frame = CGRectMake(0., CGRectGetHeight(self.contentView.bounds) - 1., CGRectGetWidth(self.contentView.bounds), 1.);
}

@end
