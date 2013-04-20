//
//  QNDAnimatedView.m
//  QNDAnimations
//
//  Created by Markos Charatzas on 19/04/2013.
//  Copyright (c) 2013 Markos Charatzas (@qnoid).
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
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

#import "QNDAnimatedView.h"

/**
 Creates a new QNDViewAnimationBlock that sets the given frame as the view's frame.
 */
QNDViewAnimationBlock QNDViewAnimationBlockOnFrame(CGRect frame)
{
return ^(UIView* view){
        view.frame = frame;
    };
}

QNDViewAnimationBlock const QNDViewAnimationBlockDockLeft = ^(UIView* view){
    view.frame = CGRectMake(CGPointZero.x, view.frame.origin.y,
                            view.frame.size.width, view.frame.size.height);
};

@interface QNDViewAnimation : NSObject

//The frame in which the animation will apply
@property (nonatomic, assign) CGRect frame;

//The animation block
@property (nonatomic, copy) QNDViewAnimationBlock viewAnimationBlock;

//The duration of the animation as passed in UIView animateWithDuration:animations:
@property (nonatomic, assign) double duration;

//The previous animation that lead to self frame
//@nullable
@property (nonatomic, strong) QNDViewAnimation *previous;

/**
 
 */
+(QNDViewAnimation*)newViewAnimation:(CGRect)frame viewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock;

/**
 
 */
+(QNDViewAnimation*)newViewAnimation:(CGRect)frame viewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock previous:(QNDViewAnimation*) previous;

/**
 
 */
+(QNDViewAnimation*)newViewAnimation:(CGRect)frame viewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock previous:(QNDViewAnimation*) previous duration:(NSTimeInterval)duration;
@end

@implementation QNDViewAnimation

+(QNDViewAnimation*)newViewAnimation:(CGRect)frame viewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock {
return [self newViewAnimation:frame viewAnimationBlock:viewAnimationBlock previous:nil];
}

+(QNDViewAnimation*)newViewAnimation:(CGRect)frame viewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock previous:(QNDViewAnimation*) previous{
return [self newViewAnimation:frame viewAnimationBlock:viewAnimationBlock previous:previous duration:0.5];
}

+(QNDViewAnimation*)newViewAnimation:(CGRect)frame viewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock previous:(QNDViewAnimation*) previous duration:(NSTimeInterval)duration
{
    QNDViewAnimation *viewAnimation = [QNDViewAnimation new];
    viewAnimation.frame = frame;
    viewAnimation.viewAnimationBlock = viewAnimationBlock;
    viewAnimation.duration = duration;
    viewAnimation.previous = previous;
    
return viewAnimation;
}


-(void)animate:(UIView*)view
{
    if(!self.viewAnimationBlock){
        return;
    }
    
    __weak UIView *wView = view;
    
    [UIView animateWithDuration:self.duration animations:^{
        self.viewAnimationBlock(wView);
    }];
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@ %@", self.previous, NSStringFromCGRect(self.frame)];
}

@end

@interface QNDAnimatedView ()
@property(nonatomic, strong) QNDViewAnimation *animations;

/**
 
 @param viewAnimation viewAnimation
 */
- (void)addAnimation:(QNDViewAnimation*)viewAnimation;

/**
 Will move the given viewAnimation to the front of the animations list.
 The front of the list will fall behind.

@param viewAnimation
*/
- (void)promote:(QNDViewAnimation *)viewAnimation;

/**
 Will demote the given demotee viewAnimation, falling behind the promotee viewAnimation.
 
 @param demotee demotee
 @param promotee promotee
 */
- (void)demote:(QNDViewAnimation *)demotee promotee:(QNDViewAnimation *)promotee;

/**
 */
-(void)animate:(QNDViewAnimation*)viewAnimation;

@end

@implementation QNDAnimatedView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(!self) {
        return nil;
    }

    self.animations = [QNDViewAnimation newViewAnimation:self.frame
                                      viewAnimationBlock:QNDViewAnimationBlockOnFrame(self.frame)];
    
return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(!self) {
        return nil;
    }
    
    self.animations = [QNDViewAnimation newViewAnimation:self.frame
                                      viewAnimationBlock:QNDViewAnimationBlockOnFrame(self.frame)];
    
    return self;
}

- (void)addAnimation:(QNDViewAnimation*)viewAnimation
{
    self.animations = viewAnimation;
}

- (void)promote:(QNDViewAnimation *)promotee
{
    [self demote:self.animations promotee:promotee];
    self.animations = promotee;
}

- (void)demote:(QNDViewAnimation *)demotee promotee:(QNDViewAnimation *)promotee
{
    demotee.previous = promotee.previous;
    promotee.previous = demotee;
}


-(void)animate:(QNDViewAnimation*)viewAnimation
{
    [viewAnimation animate:self];
}

- (void)animateWithDuration:(NSTimeInterval)duration animation:(QNDViewAnimationBlock)viewAnimationBlock {
    QNDViewAnimation *viewAnimation = [QNDViewAnimation newViewAnimation:self.frame
                                    viewAnimationBlock:viewAnimationBlock
                                              previous:self.animations
                                              duration:duration];
    [self addAnimation:viewAnimation];
    [self animate:viewAnimation];
}

-(QNDViewAnimation*)rewind
{
    QNDViewAnimation *previousAnimation = self.animations.previous;
    [self animate:previousAnimation];
    self.animations = previousAnimation;
return self.animations;
}

-(void)toggle
{
    QNDViewAnimation *previousViewAnimation = self.animations.previous;
    [self promote:previousViewAnimation];
    [self animate:previousViewAnimation];
}

@end
