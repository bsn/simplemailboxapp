//
//  RBCustomSegmentedControl.m
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "RBCustomSegmentedControl.h"

#define RB_SHOULD_RESPOND_TO_ALL_EVENTS NO

@interface RBCustomSegmentedControl (Private)
- (UIButton *)_buttonForIndex:(NSInteger)index;
- (void)_customizeButton:(UIButton *)newButton;
@end

@implementation RBCustomSegmentedControl

- (id)initWithSegmentCount:(NSUInteger)segmentCount segmentsize:(CGSize)segmentsize dividerImage:(UIImage *)dividerImage tag:(NSInteger)objectTag delegate:(NSObject <RBCustomSegmentedControlDelegate> *)customSegmentedControlDelegate
{
    self = [super init];

    if (self != nil)
    {
        self.exclusiveTouch = YES;

        self.selectedItem = 1;
        self.segmentCount = segmentCount;

        // The tag allows callers withe multiple controls to distinguish between them
        self.tag = objectTag;

        // Set the delegate
        self.delegate = customSegmentedControlDelegate;

        // Adjust our width based on the number of segments & the width of each segment and the sepearator
        self.frame = CGRectMake(0, 0, (segmentsize.width * segmentCount) + (dividerImage.size.width * (segmentCount - 1)), segmentsize.height);

        if (segmentCount > 1)
        {
            // Initalize the array we use to store our buttons
            self.buttons = [[NSMutableArray alloc] initWithCapacity:segmentCount];

            // horizontalOffset tracks the proper x value as we add buttons as subviews
            CGFloat horizontalOffset = 0;

            // Iterate through each segment
            for (NSUInteger i = 0 ; i < segmentCount ; i++)
            {
                // Ask the delegate to create a button
                UIButton *button = [self _buttonForIndex:i];
                button.exclusiveTouch = YES;

                // Register for touch events
                [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
                if (RB_SHOULD_RESPOND_TO_ALL_EVENTS)
                {
                    [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
                    [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
                    [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
                    [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
                }

                // Add the button to our buttons array
                [self.buttons addObject:button];

                // Set the button's x offset
                button.frame = CGRectMake(horizontalOffset, 0.0, segmentsize.width, segmentsize.height);

                // Add the button as our subview
                [self addSubview:button];

                // Add the divider unless we are at the last segment
                if (i != segmentCount - 1 && dividerImage != nil)
                {
                    UIImageView *divider = [[UIImageView alloc] initWithImage:dividerImage];
                    divider.frame = CGRectMake(horizontalOffset + segmentsize.width, 0.0, dividerImage.size.width, dividerImage.size.height);
                    [self addSubview:divider];
                }

                // Advance the horizontal offset
                horizontalOffset = horizontalOffset + segmentsize.width + dividerImage.size.width;
            }
        }
    }

    return self;
}

- (void)dimAllButtonsExcept:(UIButton *)selectedButton
{
    for (UIButton *button in self.buttons)
    {
        if (button == selectedButton)
        {
            button.highlighted = YES;
        }
        else
        {
            button.highlighted = NO;
            button.selected = NO;
        }
    }
}

- (void)touchDownAction:(UIButton *)button
{
    if (button.tag == _selectedItem)
        return;

    [self dimAllButtonsExcept:button];

    if ([self.delegate respondsToSelector:@selector(touchDownAtSegmentIndex:)])
        [self.delegate touchDownAtSegmentIndex:[_buttons indexOfObject:button]];
}

- (void)touchUpInsideAction:(UIButton *)button
{
    if (button.tag == _selectedItem)
        return;
    else
        _selectedItem = button.tag;

    [self dimAllButtonsExcept:button];

    button.highlighted = NO;
    button.selected = YES;

    if ([self.delegate respondsToSelector:@selector(touchUpInsideSegmentIndex:)])
        [self.delegate touchUpInsideSegmentIndex:[_buttons indexOfObject:button]];
}

- (void)otherTouchesAction:(UIButton *)button
{
    if (button.tag == _selectedItem)
        return;

    [self dimAllButtonsExcept:button];
}

- (void)setSelectedItem:(NSInteger)selectedItem
{
    _selectedItem = selectedItem;
    
    [self dimAllButtonsExcept:(UIButton *)[self viewWithTag:selectedItem]];
}

#pragma mark -
#pragma mark *** Private Interface ***
#pragma mark -

- (UIButton *)_buttonForIndex:(NSInteger)index
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;

    if (index == 1)
        button.selected = YES;

    button.adjustsImageWhenHighlighted = NO;

    UIImage *imageNormal = [UIImage imageNamed:[NSString stringWithFormat:@"segment-%d", index]];
    UIImage *imageHighlighted = [UIImage imageNamed:[NSString stringWithFormat:@"segment-%d-active", index]];

    [button setBackgroundImage:imageNormal forState:UIControlStateNormal];
    [button setBackgroundImage:imageHighlighted forState:UIControlStateHighlighted];
    [button setBackgroundImage:imageHighlighted forState:UIControlStateSelected];

    return button;
}

@end
