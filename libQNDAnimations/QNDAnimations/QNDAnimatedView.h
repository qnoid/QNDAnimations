//
//  QNDAnimatedView.h
//  QNDAnimations
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


#import <UIKit/UIKit.h>

@class QNDViewAnimation;

/**
 Definition of an animation block given a UIView to operate on.
 
 @param view the view to operate the animation block on
 */
typedef void(^QNDViewAnimationBlock)(UIView* view);
typedef void(^QNDViewAnimationCompletionBlock)(BOOL finished);

extern QNDViewAnimationBlock const QNDViewAnimationBlockDockLeft;
extern QNDViewAnimationBlock QNDViewAnimationBlockOnFrame(CGRect frame);

@protocol QNDAnimatedView <NSObject>

/**
 Executes the given animation block at the given duration.
 
 @postcondition the given animation block is recorded for rewinding.
 @param duration duration the duration of the animation
 @param viewAnimationBlock viewAnimationBlock the
 @see UIView#animateWithDuration:animations:
 @see #rewind
 */
- (void)animateWithDuration:(NSTimeInterval)duration animation:(QNDViewAnimationBlock)viewAnimationBlock;

/**
 Plays the animation block that preceded the one given in the last call of #animateWithDuration:animation:
 
 @postcondion the last played animation is lost.
 @return the animation played
 */
-(QNDViewAnimation*)rewind;

/**
 Plays the animation block that preceded the one given in the last call of #animateWithDuration:animation:
 Will get a callback once the animation is finished.
 
 @postcondion the last played animation is lost.
 @param completion callback when rewind is finished
 @return the animation played
 @see UIView#animateWithDuration:animations:completion:

 */
-(QNDViewAnimation*)rewind:(QNDViewAnimationCompletionBlock)completion;

/**
 Plays the previous animation while demoting the current one behind. 
 The second call will promote it and restore the animation flow.
 
 Calls to toggle usually happen in pairs.
 */
-(void)toggle;

@end

@interface QNDAnimatedView : UIView <QNDAnimatedView>

@end
