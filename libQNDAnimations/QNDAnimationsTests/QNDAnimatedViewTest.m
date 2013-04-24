//
//  QNDAnimatedViewTest.m
//  QNDAnimations
//
//  Created by Markos Charatzas on 21/04/2013.
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


#import <Kiwi/Kiwi.h>
#import <OCMock/OCMock.h>
#import "QNDAnimatedView.h"

@interface QNDViewAnimation (Testing)
@property (nonatomic, strong) QNDViewAnimation *previous;
@end

@interface QNDAnimatedView (Testing)
-(id)initWithFrame:(CGRect)frame animations:(QNDViewAnimation*)animations;
-(void)animate:(QNDViewAnimation*)viewAnimation;
@end

@interface QNDAnimatedViewTest : SenTestCase

@end

@implementation QNDAnimatedViewTest

@end


SPEC_BEGIN(QNDAnimatedViewSpec)

describe(@"QNDAnimatedView", ^{
    context(@"when newly created", ^{
        it(@"forward should return nil", ^{
            CGRect any = CGRectZero;
            UIView<QNDAnimatedView>* animatedView = [[QNDAnimatedView alloc] initWithFrame:any];
            
            id viewAnimation = [animatedView forward];
            
            [viewAnimation shouldBeNil];
        });
        it(@"rewind should return nil", ^{
            CGRect any = CGRectZero;
            UIView<QNDAnimatedView>* animatedView = [[QNDAnimatedView alloc] initWithFrame:any];
            
            id viewAnimation = [animatedView rewind];
            
            [viewAnimation shouldBeNil];
        });
        it(@"addViewAnimationBlock should be next to init animations", ^{
            CGRect any = CGRectZero;
            QNDViewAnimation* animations = [QNDViewAnimation newViewAnimationBlock:nil];
            UIView<QNDAnimatedView>* animatedView = [[QNDAnimatedView alloc] initWithFrame:any animations:animations];
            
            QNDViewAnimation *viewAnimation = [animatedView addViewAnimationBlock:nil];
            
            [[animations.next should] equal:viewAnimation];
        });
        it(@"addViewAnimationBlock's previous should be equal to init animations", ^{
            CGRect any = CGRectZero;
            QNDViewAnimation* animations = [QNDViewAnimation newViewAnimationBlock:nil];
            UIView<QNDAnimatedView>* animatedView = [[QNDAnimatedView alloc] initWithFrame:any animations:animations];
            
            QNDViewAnimation *viewAnimation = [animatedView addViewAnimationBlock:nil];
            
            [[viewAnimation.previous should] equal:animations];
        });
        it(@"addViewAnimationBlock's next should be nil", ^{
            CGRect any = CGRectZero;
            QNDViewAnimation* animations = [QNDViewAnimation newViewAnimationBlock:nil];
            UIView<QNDAnimatedView>* animatedView = [[QNDAnimatedView alloc] initWithFrame:any animations:animations];
            
            QNDViewAnimation *viewAnimation = [animatedView addViewAnimationBlock:nil];
            
            [viewAnimation.next shouldBeNil];
        });
    });
    context(@"when animateWithDuration:animation: has been called", ^ {
        it(@"forward should return nil", ^
        {
            QNDViewAnimation* animations = [QNDViewAnimation newViewAnimationBlock:nil];
            UIView<QNDAnimatedView>* animatedView = [[QNDAnimatedView alloc] initWithFrame:CGRectZero animations:animations];
            [animatedView animateWithDuration:0.0 animation:nil];
            
            QNDViewAnimation *animated = [animatedView forward];
            
            [animated shouldBeNil];
        });
        
        it(@"rewind should return initial animation", ^
        {
            QNDViewAnimation* animations = [QNDViewAnimation newViewAnimationBlock:nil];
            UIView<QNDAnimatedView>* animatedView = [[QNDAnimatedView alloc] initWithFrame:CGRectZero animations:animations];
            [animatedView animateWithDuration:0.0 animation:nil];
            
            QNDViewAnimation *animated = [animatedView rewind];
            
            [[animated should] equal:animations];
        });
    });
});
SPEC_END
