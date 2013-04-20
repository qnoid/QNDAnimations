//
//  QNDCyclicAnimatedViewController.m
//  QNDAnimationsApp
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


#import "QNDCyclicAnimatedViewController.h"
#import "QNDViewAnimationKeyFrame.h"

@interface QNDCyclicAnimatedViewController ()
@property(nonatomic, weak) IBOutlet UIBarButtonItem *toggleBarButtonItem;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *rewindBarButtonItem;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *forwardBarButtonItem;
@property(nonatomic, weak) IBOutlet QNDAnimatedView *animatedView;
@property(nonatomic, strong) QNDViewAnimationKeyFrame *viewAnimationKeyFrames;
-(id)initWithBundle:(NSBundle *)nibBundleOrNil;
-(IBAction)toggle:(UIBarButtonItem*)toggleBarButtonItem;
-(IBAction)rewind:(UIBarButtonItem*)rewindBarButtonItem;
-(IBAction)forward:(UIBarButtonItem*)animateBarButtonItem;
-(IBAction)didTouchUpInsideDismiss:(UIBarButtonItem*)dismissBarButtonItem;
@end

@implementation QNDCyclicAnimatedViewController

+(instancetype)newViewController
{
    return [[QNDCyclicAnimatedViewController alloc] initWithBundle:nil];
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

    self.viewAnimationKeyFrames = [QNDViewAnimationKeyFrame newViewAnimationKeyFrame:^(UIView *view) {
        view.frame = CGRectMake(0, 44,
                wAnimatedView.frame.size.width,
                wAnimatedView.frame.size.height);
    }];
    [[[[self.viewAnimationKeyFrames addViewAnimationBlock:^(UIView *view) {
        view.frame = CGRectMake(160, 44,
                wAnimatedView.frame.size.width,
                wAnimatedView.frame.size.height);
    }] addViewAnimationBlock:^(UIView *view) {
        view.frame = CGRectMake(160, 208,
                wAnimatedView.frame.size.width,
                wAnimatedView.frame.size.height);
    }] addViewAnimationBlock:^(UIView *view) {
        view.frame = CGRectMake(0, 208,
                wAnimatedView.frame.size.width,
                wAnimatedView.frame.size.height);
    }] cycle:self.viewAnimationKeyFrames];
}

-(IBAction)toggle:(UIBarButtonItem*)toggleBarButtonItem
{
    [self.animatedView toggle];
}

-(IBAction)rewind:(UIBarButtonItem*)rewindBarButtonItem
{
    self.viewAnimationKeyFrames = self.viewAnimationKeyFrames.previousViewAnimationKeyFrame;
    self.toggleBarButtonItem.enabled = self.rewindBarButtonItem.enabled = self.forwardBarButtonItem.enabled = self.viewAnimationKeyFrames != nil;
    
    [self.animatedView rewind];
}

-(IBAction)forward:(UIBarButtonItem*)animateBarButtonItem
{
    [self.animatedView animateWithDuration:0.5 animation:self.viewAnimationKeyFrames.viewAnimationBlock];
    self.viewAnimationKeyFrames = self.viewAnimationKeyFrames.nextViewAnimationKeyFrame;
    self.toggleBarButtonItem.enabled = self.rewindBarButtonItem.enabled = self.forwardBarButtonItem.enabled = self.viewAnimationKeyFrames != nil;
}

-(IBAction)didTouchUpInsideDismiss:(UIBarButtonItem*)dismissBarButtonItem{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
