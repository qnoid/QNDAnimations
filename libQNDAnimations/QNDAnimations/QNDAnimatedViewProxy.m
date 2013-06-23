//
//  QNDAnimatedViewProxy.m
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

#import "QNDAnimatedViewProxy.h"
#import "QNDViewAnimationBlockSuppliers.h"

@interface QNDAnimatedView ()
-(id)initWithFrame:(CGRect)frame animations:(QNDViewAnimation*)animations;
@end

@interface QNDAnimatedViewProxy()
@property(nonatomic, weak) UIView* view;
@property(nonatomic, strong) UIView<QNDAnimatedView>* animatedView;
-(id)initWith:(UIView*)view animatedView:(UIView<QNDAnimatedView>*) animatedView;
@end

@implementation QNDAnimatedViewProxy

+(UIView<QNDAnimatedView>*)newAnimatedViewProxy:(UIView*)view
{
    NSObject<QNDViewAnimationBlockSupplier> *supplierWillIjectViewInBlock =
    [QNDViewAnimationBlockSuppliers of:QNDViewAnimationBlockOnFrame(view.frame) onView:view];
    
    UIView<QNDAnimatedView>* animatedView = [[QNDAnimatedView alloc] initWithFrame:view.frame animations:[QNDViewAnimation newViewAnimationBlock:[supplierWillIjectViewInBlock get]]];
    
    id animatedViewProxy = [[QNDAnimatedViewProxy alloc] initWith:view animatedView:animatedView];
    
return animatedViewProxy;
}

-(id)initWith:(UIView *)view animatedView:(UIView<QNDAnimatedView> *)animatedView
{
    self.view = view;
    self.animatedView = animatedView;
return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    return self.view;
}

-(QNDViewAnimation*)addViewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock
{
   NSObject<QNDViewAnimationBlockSupplier> *supplierWillIjectViewInBlock =
        [QNDViewAnimationBlockSuppliers of:viewAnimationBlock onView:self.view];
    return [self.animatedView addViewAnimationBlock:[supplierWillIjectViewInBlock get]];
}

-(QNDViewAnimation*)addViewAnimationBlockWithDuration:(NSTimeInterval)duration animation:(QNDViewAnimationBlock)viewAnimationBlock
{
    NSObject<QNDViewAnimationBlockSupplier> *supplierWillIjectViewInBlock =
        [QNDViewAnimationBlockSuppliers of:viewAnimationBlock onView:self.view];

   return [self.animatedView addViewAnimationBlockWithDuration:duration animation:[supplierWillIjectViewInBlock get]];
}

-(void)cycle:(QNDViewAnimation *)viewAnimation{
    [self.animatedView cycle:viewAnimation];
}

-(QNDViewAnimation*)animateWithDuration:(NSTimeInterval)duration animation:(QNDViewAnimationBlock)viewAnimationBlock
{
    NSObject<QNDViewAnimationBlockSupplier> *supplierWillIjectViewInBlock =
        [QNDViewAnimationBlockSuppliers of:viewAnimationBlock onView:self.view];

    return [self.animatedView animateWithDuration:duration animation:[supplierWillIjectViewInBlock get]];
}

-(QNDViewAnimation *)play{
    return [self.animatedView play];
}

-(QNDViewAnimation *)play:(QNDViewAnimationCompletionBlock)completion{
    return [self.animatedView play:completion];
}

-(QNDViewAnimation *)forward{
    return [self.animatedView forward];
}

-(QNDViewAnimation *)forward:(QNDViewAnimationCompletionBlock)completion{
    return [self.animatedView forward:completion];
}

-(QNDViewAnimation *)rewind{
    return [self.animatedView rewind];
}

-(QNDViewAnimation *)rewind:(QNDViewAnimationCompletionBlock)completion{
    return [self.animatedView rewind:completion];
}

-(void)toggle{
    [self.animatedView toggle];
}

-(NSUInteger)hash{
    return [self.view hash];
}

-(BOOL)isEqual:(id)object{
    return [self.view isEqual:object];
}

@end
