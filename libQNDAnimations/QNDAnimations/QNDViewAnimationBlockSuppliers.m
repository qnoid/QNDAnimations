//
//  QNDViewAnimationBlockSupplier.m
//  QNDAnimations
//
//  Created by Markos Charatzas on 24/04/2013.
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

#import "QNDViewAnimationBlockSuppliers.h"

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

@interface QNDViewAnimationBlockSupplier : NSObject <QNDViewAnimationBlockSupplier>
@property(nonatomic, copy) QNDViewAnimationBlock viewAnimationBlock;
+(instancetype)of:(QNDViewAnimationBlock)viewAmnimationBlock;
@end

@implementation QNDViewAnimationBlockSupplier
+(instancetype)of:(QNDViewAnimationBlock)viewAnimationBlock
{
    QNDViewAnimationBlockSupplier *viewAnimationBlockSupplier = [QNDViewAnimationBlockSupplier new];
    viewAnimationBlockSupplier.viewAnimationBlock = viewAnimationBlock;
    
return viewAnimationBlockSupplier;
}
-(QNDViewAnimationBlock)get{
    return self.viewAnimationBlock;
}
@end

@interface QNDViewAnimationBlockSupplierInjectsView : NSObject <QNDViewAnimationBlockSupplier>
@property(nonatomic, weak) UIView* view;
@property(nonatomic, copy) QNDViewAnimationBlock viewAnimationBlock;
+(instancetype)of:(QNDViewAnimationBlock)viewAmnimationBlock onView:(UIView*)view;
@end

@implementation QNDViewAnimationBlockSupplierInjectsView
+(instancetype)of:(QNDViewAnimationBlock)viewAnimationBlock onView:(UIView*)view
{
    QNDViewAnimationBlockSupplierInjectsView *viewAnimationBlockSupplier = [QNDViewAnimationBlockSupplierInjectsView new];
    viewAnimationBlockSupplier.viewAnimationBlock = viewAnimationBlock;
    viewAnimationBlockSupplier.view = view;
    
return viewAnimationBlockSupplier;
}
-(QNDViewAnimationBlock)get
{
    return ^(UIView* view){
        self.viewAnimationBlock(self.view);
    };
}
@end

@implementation QNDViewAnimationBlockSuppliers

+(NSObject<QNDViewAnimationBlockSupplier>*)of:(QNDViewAnimationBlock)viewAmnimationBlock{
    return [QNDViewAnimationBlockSupplier of:viewAmnimationBlock];
}

+(NSObject<QNDViewAnimationBlockSupplier>*)of:(QNDViewAnimationBlock)viewAmnimationBlock onView:(UIView*)view{
    return [QNDViewAnimationBlockSupplierInjectsView of:viewAmnimationBlock onView:view];
}

@end
