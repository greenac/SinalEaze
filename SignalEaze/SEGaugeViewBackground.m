//
//  SEGaugeViewBackground.m
//  SignalEaze
//
//  Created by Andre Green on 2/14/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import "SEGaugeViewBackground.h"
#import "SEGaugeView.h"
#import "SESegment.h"

#define kSEGaugeBackgroundRadiusModifier  .95f

@interface SEGaugeViewBackground()

@end

@implementation SEGaugeViewBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = .5f*frame.size.width;
        self.clipsToBounds = YES;
    }
    return self;
}

- (SEGaugeView *)gaugeView
{
    if (!_gaugeView) {
        CGRect frame = CGRectMake(0.0f,
                                  0.0f,
                                  kSEGaugeBackgroundRadiusModifier*self.frame.size.width,
                                  kSEGaugeBackgroundRadiusModifier*self.frame.size.height);
        SESegment *segment = [[SESegment alloc] initWithColor:[UIColor blueColor] start:0.0f end:200.0f];
        SESegment *segment1 = [[SESegment alloc] initWithColor:[UIColor greenColor] start:110.0f end:160.0f];
        _gaugeView = [[SEGaugeView alloc] initWithFrame:frame segments:@[segment] minValue:0.0f maxValue:220.0f];
    }
    
    return _gaugeView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor yellowColor];
    
    self.gaugeView.frame = CGRectMake(.5f*(self.bounds.size.width - self.gaugeView.bounds.size.width),
                                      .5f*(self.bounds.size.height - self.gaugeView.bounds.size.height),
                                      self.gaugeView.bounds.size.width,
                                      self.gaugeView.bounds.size.height);
    if (![self.subviews containsObject:self.gaugeView]) {
        [self addSubview:self.gaugeView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
