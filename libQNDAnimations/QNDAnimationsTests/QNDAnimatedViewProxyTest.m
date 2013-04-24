//
//  QNDAnimatedViewProxyTest.m
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

#import <OCMock/OCMock.h>
#import "QNDAnimatedViewProxy.h"
#import "QNDAnimatedView.h"
#import <Kiwi/Kiwi.h>

@interface QNDAnimatedViewProxy (Testing)
-(id)initWith:(UIView *)view animatedView:(UIView<QNDAnimatedView> *)animatedView;
@end


@interface QNDAnimatedViewProxyTest : SenTestCase

@end

@implementation QNDAnimatedViewProxyTest

-(void)testGivenViewCallAtAnyMethodAssertForwardingTarget
{
    id mockedView = [OCMockObject niceMockForClass:[UIView class]];
    UIView<QNDAnimatedView>* animatedView = [QNDAnimatedViewProxy newAnimatedViewProxy:mockedView];
    [[mockedView expect] addSubview:nil];
    
    [animatedView addSubview:nil];
    
    [mockedView verify];
}

-(void)testGivenMockedViewAssertDelegation
{
    id mockedView = [OCMockObject niceMockForProtocol:@protocol(QNDAnimatedView)];
    id animatedView = [[QNDAnimatedViewProxy alloc] initWith:nil animatedView:mockedView];

    [[mockedView expect] cycle:nil];
    [[mockedView expect] play];
    [[mockedView expect] play:nil];
    [[mockedView expect] forward];
    [[mockedView expect] forward:nil];
    [[mockedView expect] rewind];
    [[mockedView expect] rewind:nil];
    [[mockedView expect] toggle];

    [animatedView cycle:nil];
    [animatedView play];
    [animatedView play:nil];
    [animatedView forward];
    [animatedView forward:nil];
    [animatedView rewind];
    [animatedView rewind:nil];
    [animatedView toggle];
    
    [mockedView verify];
}
@end

SPEC_BEGIN(QNDAnimatedViewProxySpec)

describe(@"QNDAnimatedViewProxy", ^{
    context(@"when addViewAnimationBlock", ^{
        it(@"should pass view", ^{
            id mockedView = [OCMockObject niceMockForClass:[UIView class]];
            UIView<QNDAnimatedView>* animatedView = [QNDAnimatedViewProxy newAnimatedViewProxy:mockedView];

            [animatedView addViewAnimationBlock:^(UIView *view) {
                [[view should] equal:mockedView];
            }];
        });
    });
    context(@"when addViewAnimationBlock", ^{
        it(@"should pass view", ^{
            id mockedView = [OCMockObject niceMockForClass:[UIView class]];
            UIView<QNDAnimatedView>* animatedView = [QNDAnimatedViewProxy newAnimatedViewProxy:mockedView];
            float any = 0.0;
            
            [animatedView addViewAnimationBlockWithDuration:any animation:^(UIView *view) {
                [[view should] equal:mockedView];
            }];
        });
    });
});
SPEC_END
