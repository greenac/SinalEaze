//
//  SEGaugeView.m
//  SignalEaze
//
//  Created by Andre Green on 2/12/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEGaugeView.h"
#import <QuartzCore/QuartzCore.h>

#define kSEPropertyGagueRadiusModifier  .75f


@interface SEGaugeView()

@property(nonatomic, assign) CGFloat radius;

@end

@implementation SEGaugeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _radius = .5f*frame.size.width;
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = self.radius;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat diameter = kSEPropertyGagueRadiusModifier*rect.size.width;
    CGRect gaugeRect = CGRectMake(rect.origin.x + .5*(rect.size.width - diameter),
                                  rect.origin.y + .5*(rect.size.height - diameter),
                                  diameter,
                                  diameter);
    
    [[UIColor redColor] setFill];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.origin.x + .5*rect.size.width, rect.origin.y + .5*rect.size.height)
                                                        radius:.5*diameter
                                                    startAngle:0
                                                      endAngle:2*M_PI
                                                     clockwise:YES];
    [path fill];
    
}


@end
