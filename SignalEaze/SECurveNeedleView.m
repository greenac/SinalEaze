//
//  SECurveNeedleView.m
//  SignalEaze
//
//  Created by Andre Green on 3/6/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SECurveNeedleView.h"

@interface SECurveNeedleView()

@property (nonatomic, assign) CGFloat outerRadius;
@property (nonatomic, assign) CGFloat innerRadius;

@end

@implementation SECurveNeedleView

- (id)initWithFrame:(CGRect)frame innerRadius:(CGFloat)innerRadius
{
    self = [super initWithFrame:frame];
    if (self) {
        _innerRadius = innerRadius;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.subviews.count > 0) {
        for (UIView *subview in self.subviews) {
            [subview removeFromSuperview];
        }
    }
    
    [self drawView];
}

- (void)drawView
{
    self.backgroundColor = [UIColor clearColor];
    
    UIView *outerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                 0.0f,
                                                                 self.bounds.size.width,
                                                                 self.bounds.size.height - self.innerRadius)];
    outerView.backgroundColor = kSENeedleViewFillColor;
    
    UIView *innerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                 outerView.bounds.size.height,
                                                                 outerView.bounds.size.width,
                                                                 self.innerRadius)];
    innerView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:outerView];
    [self addSubview:innerView];
}

@end
