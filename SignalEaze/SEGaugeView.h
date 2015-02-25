//
//  SEGaugeView.h
//  SignalEaze
//
//  Created by Andre Green on 2/12/15.
//  Copyright (c) 2015 Andre Green. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SEGaugeView : UIView

- (id)initWithFrame:(CGRect)frame segments:(NSArray *)segments minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue;

@end
