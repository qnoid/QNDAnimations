//
//  QNDCyclicAnimatedViewController.m
//  QNDAnimationsApp
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


#import "QNDLoopAnimatedViewController.h"

@interface QNDLoopAnimatedViewController ()
@property(nonatomic, weak) IBOutlet QNDAnimatedView *animatedView;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil;
-(IBAction)toggle:(UIBarButtonItem*)toggleBarButtonItem;
-(IBAction)rewind:(UIBarButtonItem*)rewindBarButtonItem;
-(IBAction)forward:(UIBarButtonItem*)animateBarButtonItem;
-(IBAction)didTouchUpInsideDismiss:(UIBarButtonItem*)dismissBarButtonItem;
@end

@implementation QNDLoopAnimatedViewController

+(instancetype)newViewController
{
    return [[QNDLoopAnimatedViewController alloc] initWithBundle:nil];
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nibBundleOrNil];
    if (!self) {
        return nil;
    }
        
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak QNDAnimatedView* wAnimatedView = self.animatedView;
    
    QNDViewAnimation* viewAnimation = [self.animatedView addViewAnimationBlock:^(UIView *view) {
        view.frame = CGRectMake(0, 44,
                                wAnimatedView.frame.size.width,
                                wAnimatedView.frame.size.height);
    }];
     
    [self.animatedView addViewAnimationBlock:^(UIView *view) {
        view.frame = CGRectMake(160, 44,
                                wAnimatedView.frame.size.width,
                                wAnimatedView.frame.size.height);
    }];
     
    [self.animatedView addViewAnimationBlock:^(UIView *view) {
        view.frame = CGRectMake(160, 208,
                                wAnimatedView.frame.size.width,
                                wAnimatedView.frame.size.height);
    }];
     
    [self.animatedView addViewAnimationBlock:^(UIView *view) {
        view.frame = CGRectMake(0, 208,
                                wAnimatedView.frame.size.width,
                                wAnimatedView.frame.size.height);
    }];

    [self.animatedView cycle:viewAnimation];
}

-(IBAction)toggle:(UIBarButtonItem*)toggleBarButtonItem
{
    [self.animatedView toggle];
}

-(IBAction)rewind:(UIBarButtonItem*)rewindBarButtonItem
{
    [self.animatedView rewind];
}

-(IBAction)forward:(UIBarButtonItem*)animateBarButtonItem
{
    [self.animatedView forward];
}

-(IBAction)didTouchUpInsideDismiss:(UIBarButtonItem*)dismissBarButtonItem{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
