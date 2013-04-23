//
//  QNDAnimatedView.m
//  QNDAnimations
//
//  Created by Markos Charatzas on 19/04/2013.
//  Copyright (c) 2013 Markos Charatzas (qnoid.com).
//
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

float const QND_VIEW_ANIMATION_DEFAULT_ANIMATION_DURATION = 0.5;

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

@interface QNDViewAnimation ()
@property (nonatomic, copy) QNDViewAnimationBlock viewAnimationBlock;
@property (nonatomic, assign) double duration;
@property (nonatomic, strong) QNDViewAnimation *previous;
@property (nonatomic, strong) QNDViewAnimation *next;
@end

@implementation QNDViewAnimation

+(QNDViewAnimation *)newViewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock
{
    QNDViewAnimation *viewAnimation = [[QNDViewAnimation alloc] init];
    viewAnimation.viewAnimationBlock = viewAnimationBlock;
    viewAnimation.duration = QND_VIEW_ANIMATION_DEFAULT_ANIMATION_DURATION;

return viewAnimation;
}

-(QNDViewAnimation*)animate:(UIView*)view completion:(QNDViewAnimationCompletionBlock)completion
{
    if(!self.viewAnimationBlock){
        return self;
    }
    
    __weak UIView *wView = view;
    
    [UIView animateWithDuration:self.duration animations:^{
        self.viewAnimationBlock(wView);
    } completion:completion];
    
return self;
}

-(QNDViewAnimation*)addViewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock{
    return [self addViewAnimationBlockWithDuration:QND_VIEW_ANIMATION_DEFAULT_ANIMATION_DURATION animation:viewAnimationBlock];
}

-(QNDViewAnimation*)addViewAnimationBlockWithDuration:(NSTimeInterval)duration animation:(QNDViewAnimationBlock)viewAnimationBlock
{
    QNDViewAnimation *viewAnimation =
    [[[[[QNDViewAnimationBuilder alloc] initWithViewAnimationBlock:viewAnimationBlock]
                previous:self]
                duration:duration]
                newViewAnimation];
    
    self.next = viewAnimation;
    
return self.next;
}


-(void)cycle:(QNDViewAnimation *)viewAnimation
{
    self.next = viewAnimation;
    viewAnimation.previous = self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"%@", self.previous];
}

@end

@interface QNDViewAnimationBuilder()
@property(nonatomic, copy) QNDViewAnimationBlock viewAnimationBlock;
@property(nonatomic, strong) QNDViewAnimation* previous;
@property(nonatomic, strong) QNDViewAnimation* next;
@property(nonatomic, assign) NSTimeInterval duration;
@end

@implementation QNDViewAnimationBuilder

-(id)initWithViewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.viewAnimationBlock = viewAnimationBlock;
    self.duration = QND_VIEW_ANIMATION_DEFAULT_ANIMATION_DURATION;
    
return self;
}

-(instancetype)previous:(QNDViewAnimation*)previous{
    self.previous = previous;
return self;
}

-(instancetype)next:(QNDViewAnimation*)next {
    self.next = next;
return self;
}

-(instancetype)duration:(NSTimeInterval)duration{
    self.duration = duration;
return self;
}

-(QNDViewAnimation*)newViewAnimation{

    QNDViewAnimation *viewAnimation = [QNDViewAnimation newViewAnimationBlock:self.viewAnimationBlock];
    viewAnimation.duration = self.duration;
    viewAnimation.previous = self.previous;
    viewAnimation.next = self.next;

return viewAnimation;
}

@end

@interface QNDAnimatedView ()
@property(nonatomic, strong) QNDViewAnimation *animations;

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
-(QNDViewAnimation*)animate:(QNDViewAnimation*)viewAnimation;

@end

@implementation QNDAnimatedView

//testing
-(id)initWithFrame:(CGRect)frame animations:(QNDViewAnimation*)animations
{
    self = [super initWithFrame:frame];
    
    if(!self) {
        return nil;
    }
    
    self.animations = animations;
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(!self) {
        return nil;
    }

    self.animations = [QNDViewAnimation newViewAnimationBlock:QNDViewAnimationBlockOnFrame(self.frame)];
    
return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(!self) {
        return nil;
    }
    
    self.animations = [QNDViewAnimation newViewAnimationBlock:QNDViewAnimationBlockOnFrame(self.frame)];
    
return self;
}

-(QNDViewAnimation*)addViewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock {
    return [self addViewAnimationBlockWithDuration:QND_VIEW_ANIMATION_DEFAULT_ANIMATION_DURATION animation:viewAnimationBlock];
}

-(QNDViewAnimation*)addViewAnimationBlockWithDuration:(NSTimeInterval)duration animation:(QNDViewAnimationBlock)viewAnimationBlock
{
    QNDViewAnimation *viewAnimation =
        [[[[QNDViewAnimationBuilder alloc] initWithViewAnimationBlock:viewAnimationBlock]
            duration:duration]
            newViewAnimation];

return [self addAnimation:viewAnimation];
}

- (QNDViewAnimation*)addAnimation:(QNDViewAnimation*)viewAnimation
{
    self.animations.next = viewAnimation;
    viewAnimation.previous = self.animations;
    self.animations = viewAnimation;
    
return self.animations;
}

-(void)cycle:(QNDViewAnimation *)viewAnimation
{
    self.animations.next = viewAnimation;
    viewAnimation.previous = self.animations;
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

-(QNDViewAnimation*)animate:(QNDViewAnimation*)viewAnimation
{
    return [self animate:viewAnimation completion:nil];
}

-(QNDViewAnimation*)animate:(QNDViewAnimation*)viewAnimation completion:(QNDViewAnimationCompletionBlock)completion
{
    return [viewAnimation animate:self completion:completion];
}

- (QNDViewAnimation*)animateWithDuration:(NSTimeInterval)duration animation:(QNDViewAnimationBlock)viewAnimationBlock
{
    QNDViewAnimation *viewAnimation = [self addViewAnimationBlockWithDuration:duration animation:viewAnimationBlock];
    return [self animate:viewAnimation];
}

-(QNDViewAnimation*)forward{
    return [self forward:nil];
}

-(QNDViewAnimation*)forward:(QNDViewAnimationCompletionBlock)completion
{
    QNDViewAnimation *next = self.animations.next;
    [self animate:next completion:completion];
    self.animations = next;
    
return self.animations;
}

-(QNDViewAnimation*)rewind {
return [self rewind:nil];
}

-(QNDViewAnimation*)rewind:(QNDViewAnimationCompletionBlock)completion
{
    QNDViewAnimation *previousAnimation = self.animations.previous;
    [self animate:previousAnimation completion:completion];
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
