//
//  QNDViewAnimationBuilderTest.m
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

#import <OCMock/OCMock.h>
#import <Kiwi/Kiwi.h>
#import "QNDAnimatedView.h"

@interface QNDViewAnimation (Testing)
@property(nonatomic, assign) NSTimeInterval duration;
@property(nonatomic, strong) QNDViewAnimation* previous;
@property(nonatomic, strong) QNDViewAnimation* next;
@end

@interface QNDViewAnimationBuilderTest : SenTestCase

@end

@implementation QNDViewAnimationBuilderTest

@end

SPEC_BEGIN(QNDViewAnimationBuilderSpec)

describe(@"QNDAnimatedView", ^{
    context(@"when newly created", ^{
        it(@"should create a default QNDViewAnimation", ^
        {
            QNDViewAnimationBuilder* builder = [[QNDViewAnimationBuilder alloc] initWithViewAnimationBlock:nil];
            QNDViewAnimation* viewAnimation = [builder newViewAnimation];
            
            [[theValue(viewAnimation.duration) should] equal:theValue(0.5)];
            [viewAnimation.previous shouldBeNil];
            [viewAnimation.next shouldBeNil];
        });
    });
    context(@"when given all optional values", ^{
        it(@"should create a QNDViewAnimation with said values", ^
        {
            id mockedPrevious = [OCMockObject mockForClass:[QNDViewAnimation class]];
            id mockedNext = [OCMockObject mockForClass:[QNDViewAnimation class]];
            QNDViewAnimationBuilder* builder = [[QNDViewAnimationBuilder alloc] initWithViewAnimationBlock:nil];
            float anyDuration = 0.0;
            [builder duration:anyDuration];
            [builder previous:mockedPrevious];
            [builder next:mockedNext];
            
            QNDViewAnimation* viewAnimation = [builder newViewAnimation];
            
            [viewAnimation.viewAnimationBlock shouldBeNil];
            [[theValue(viewAnimation.duration) should] equal:theValue(anyDuration)];
            [[viewAnimation.previous should] equal:mockedPrevious];
            [[viewAnimation.next should] equal:mockedNext];
        });
    });    
});
SPEC_END
