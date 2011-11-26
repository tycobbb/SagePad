//
//  SagePadTouchView.m
//  SagePad
//
//  Created by Matthew Cobb on 10/20/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "SagePadTouchView.h"

@implementation SagePadTouchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchCoordinates = [touch locationInView:self];
    [self.nextResponder handleNewTouch:&touchCoordinates];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchCoordinates = [touch locationInView:self];
    [self.nextResponder handleMovedTouch:&touchCoordinates];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchCoordinates = [touch locationInView:self];
    [self.nextResponder handleFinishedTouch:&touchCoordinates];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesEnded:touches withEvent:event];
}

@end
