//
//  QNDAnimationsViewController.m
//  QNDAnimationsApp
//
//  Created by Markos Charatzas on 20/04/2013.
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


#import "QNDAnimationsViewController.h"
#import "QNDOneWayAnimatedViewController.h"
#import "QNDLoopAnimatedViewController.h"
#import "QNDAnimations.h"
#import "QNDAnimatedView.h"

@interface QNDAnimationsViewController ()
@property(nonatomic, weak) IBOutlet UIView* oneWayView;
@property(nonatomic, weak) IBOutlet UIView* loopView;
@property(nonatomic, assign) CGRect oneWayViewFrame;
@property(nonatomic, assign) CGRect loopViewFrame;
@property(nonatomic, strong) UIView<QNDAnimatedView>* oneWayAnimatedView;
@property(nonatomic, strong) UIView<QNDAnimatedView>* loopAnimatedView;
-(IBAction)didTouchUpInsideOneWayButton:(UIButton*)sender;
-(IBAction)didTouchUpInsideLoopButton:(UIButton*)sender;
@end

@implementation QNDAnimationsViewController

+(UINavigationController*)newViewController
{
    QNDAnimationsViewController *animationsViewController = [[QNDAnimationsViewController alloc] initWithBundle:nil];
    
    animationsViewController.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"animate"
                                     style:UIBarButtonItemStylePlain
                                    target:animationsViewController
                                    action:@selector(didTouchUpInsideAnimateButton:)];
    
    return [[UINavigationController alloc] initWithRootViewController:animationsViewController];
}

-(id)initWithBundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nibBundleOrNil];
    if (!self) {
        return nil;
    }
    
    self.title = @"QNDAnimatedView";
    
    return self;
}

-(void)viewDidLoad
{
    self.oneWayAnimatedView = [[QNDAnimations new] animateView:self.oneWayView];
    self.loopAnimatedView = [[QNDAnimations new] animateView:self.loopView];
    self.oneWayViewFrame = self.oneWayView.frame;
    self.loopViewFrame = self.loopView.frame;

    __weak QNDAnimationsViewController *wSelf = self;
    [self.oneWayAnimatedView addViewAnimationBlock:^(UIView *view) {
        view.frame = wSelf.loopViewFrame;
    }];
    
    [self.loopAnimatedView addViewAnimationBlock:^(UIView *view) {
        view.frame = wSelf.oneWayViewFrame;
    }];
}

-(void)didTouchUpInsideAnimateButton:(UIBarButtonItem*)sender
{
    [self.oneWayAnimatedView toggle];
    [self.loopAnimatedView toggle];
}

-(IBAction)didTouchUpInsideOneWayButton:(UIButton*)sender
{
    [self presentViewController:[QNDOneWayAnimatedViewController newViewController] animated:YES completion:nil];
}

-(IBAction)didTouchUpInsideLoopButton:(UIButton*)sender
{
    [self presentViewController:[QNDLoopAnimatedViewController newViewController] animated:YES completion:nil];
}

@end
