//
//  LGAlertViewButton.m
//  LGAlertView
//
//
//  The MIT License (MIT)
//
//  Copyright © 2015 Grigory Lutkov <Friend.LGA@gmail.com>
//  (https://github.com/Friend-LGA/LGAlertView)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "LGAlertViewButton.h"
#import "LGAlertViewHelper.h"

@implementation LGAlertViewButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.titleLabel.backgroundColor = UIColor.clearColor;
        self.imageView.backgroundColor = UIColor.clearColor;

        if (@available(iOS 15.0, *)) {
            UIButtonConfiguration *config = self.configuration;
            config.contentInsets = NSDirectionalEdgeInsetsMake(LGAlertViewPaddingHeight,
                                                           LGAlertViewPaddingWidth,
                                                           LGAlertViewPaddingHeight,
                                                           LGAlertViewPaddingWidth);
            self.configuration = config;
            /* Not sure why but this was not working. It was making the title
            disappear. Okay with the default appearance changes in iOS 15 and newer.
            self.configurationUpdateHandler = ^(__kindof UIButton *button) {
                if (button.state & UIControlStateHighlighted) {
                    // Prevent default dimming effect when button is highlighted
                    // button.imageView.alpha = 1.0;
                } else if (button.state & UIControlStateDisabled) {
                    // Prevent the button from graying out its image when disabled
                    // button.imageView.alpha = 1.0;
                } else {
                    // Reset to default appearance for other states
                    // button.imageView.alpha = 1.0;
                }
            }; */

            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        } else {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            self.contentEdgeInsets = UIEdgeInsetsMake(LGAlertViewPaddingHeight,
                                                              LGAlertViewPaddingWidth,
                                                              LGAlertViewPaddingHeight,
                                                              LGAlertViewPaddingWidth);

            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;

            self.adjustsImageWhenHighlighted = NO;
            self.adjustsImageWhenDisabled = NO;
            #pragma clang diagnostic pop
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!self.imageView.image || !self.titleLabel.text.length) {
        return;
    }

    CGRect imageViewFrame = self.imageView.frame;
    CGRect titleLabelFrame = self.titleLabel.frame;

    if (@available(iOS 15.0, *)) {
        NSDirectionalEdgeInsets insets = self.configuration.contentInsets;

        if (self.iconPosition == LGAlertViewButtonIconPositionLeft) {
            if (self.titleLabel.textAlignment == NSTextAlignmentLeft) {
                imageViewFrame.origin.x = insets.leading;
                titleLabelFrame.origin.x = CGRectGetMaxX(imageViewFrame) + LGAlertViewButtonImageOffsetFromTitle;
            }
            else if (self.titleLabel.textAlignment == NSTextAlignmentRight) {
                imageViewFrame.origin.x = insets.leading;
                titleLabelFrame.origin.x = CGRectGetWidth(self.bounds) - insets.trailing;
            }
            else {
                imageViewFrame.origin.x -= LGAlertViewButtonImageOffsetFromTitle / 2.0;
                titleLabelFrame.origin.x += LGAlertViewButtonImageOffsetFromTitle / 2.0;
            }
        }
        else {
            if (self.titleLabel.textAlignment == NSTextAlignmentLeft) {
                titleLabelFrame.origin.x = insets.leading;
                imageViewFrame.origin.x = CGRectGetWidth(self.bounds) - insets.trailing - CGRectGetWidth(imageViewFrame);
            }
            else if (self.titleLabel.textAlignment == NSTextAlignmentRight) {
                imageViewFrame.origin.x = CGRectGetWidth(self.bounds) - insets.trailing - CGRectGetWidth(imageViewFrame);
                titleLabelFrame.origin.x = CGRectGetMinX(imageViewFrame) - LGAlertViewButtonImageOffsetFromTitle - CGRectGetWidth(titleLabelFrame);
            }
            else {
                imageViewFrame.origin.x += CGRectGetWidth(titleLabelFrame) + (LGAlertViewButtonImageOffsetFromTitle / 2.0);
                titleLabelFrame.origin.x -= CGRectGetWidth(imageViewFrame) + (LGAlertViewButtonImageOffsetFromTitle / 2.0);
            }
        }
    } else {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if (self.iconPosition == LGAlertViewButtonIconPositionLeft) {
            if (self.titleLabel.textAlignment == NSTextAlignmentLeft) {
                imageViewFrame.origin.x = self.contentEdgeInsets.left;
                titleLabelFrame.origin.x = CGRectGetMaxX(imageViewFrame) + LGAlertViewButtonImageOffsetFromTitle;
            }
            else if (self.titleLabel.textAlignment == NSTextAlignmentRight) {
                imageViewFrame.origin.x = self.contentEdgeInsets.left;
                titleLabelFrame.origin.x = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right;
            }
            else {
                imageViewFrame.origin.x -= LGAlertViewButtonImageOffsetFromTitle / 2.0;
                titleLabelFrame.origin.x += LGAlertViewButtonImageOffsetFromTitle / 2.0;
            }
        }
        else {
            if (self.titleLabel.textAlignment == NSTextAlignmentLeft) {
                titleLabelFrame.origin.x = self.contentEdgeInsets.left;
                imageViewFrame.origin.x = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - CGRectGetWidth(imageViewFrame);
            }
            else if (self.titleLabel.textAlignment == NSTextAlignmentRight) {
                imageViewFrame.origin.x = CGRectGetWidth(self.bounds) - self.contentEdgeInsets.right - CGRectGetWidth(imageViewFrame);
                titleLabelFrame.origin.x = CGRectGetMinX(imageViewFrame) - LGAlertViewButtonImageOffsetFromTitle - CGRectGetWidth(titleLabelFrame);
            }
            else {
                imageViewFrame.origin.x += CGRectGetWidth(titleLabelFrame) + (LGAlertViewButtonImageOffsetFromTitle / 2.0);
                titleLabelFrame.origin.x -= CGRectGetWidth(imageViewFrame) + (LGAlertViewButtonImageOffsetFromTitle / 2.0);
            }
        }
        #pragma clang diagnostic pop
    }

    if (LGAlertViewHelper.isNotRetina) {
        imageViewFrame = CGRectIntegral(imageViewFrame);
    }

    self.imageView.frame = imageViewFrame;

    if (LGAlertViewHelper.isNotRetina) {
        titleLabelFrame = CGRectIntegral(titleLabelFrame);
    }

    self.titleLabel.frame = titleLabelFrame;
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
    [self setBackgroundImage:[LGAlertViewHelper image1x1WithColor:color] forState:state];
}

@end
