//
//  QNDAnimationTest.m
//  QNDAnimations
//
//  Created by Markos Charatzas on 22/04/2013.
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
#import "QNDAnimatedView.h"

@interface QNDViewAnimation (Testing)
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) QNDViewAnimation *previous;
@property (nonatomic, strong) QNDViewAnimation *next;
@end

@interface QNDViewAnimationTest : SenTestCase

@end

@implementation QNDViewAnimationTest

@end

SPEC_BEGIN(QNDViewAnimationSpec)

describe(@"QNDViewAnimation", ^{
    context(@"when newly created", ^{
        it(@"should have default values", ^{
            QNDViewAnimation* viewAnimation = [QNDViewAnimation newViewAnimationBlock:nil];
            
            [viewAnimation.viewAnimationBlock shouldBeNil];
            [[theValue(viewAnimation.duration) should] equal:theValue(QND_VIEW_ANIMATION_DEFAULT_ANIMATION_DURATION)];
        });        
        it(@"cycle", ^{
            QNDViewAnimation* viewAnimation = [QNDViewAnimation newViewAnimationBlock:nil];            
            QNDViewAnimation* next = [viewAnimation addViewAnimationBlock:nil];
            
            [next cycle:viewAnimation];

            [[next.next should] equal:viewAnimation];
            [[viewAnimation.previous should] equal:next];
        });
    });
});
SPEC_END
