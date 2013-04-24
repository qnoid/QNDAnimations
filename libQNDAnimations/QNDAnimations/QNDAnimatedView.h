//
//  QNDAnimatedView.h
//  QNDAnimations
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


#import <UIKit/UIKit.h>
#import "QNDViewAnimationBlockSuppliers.h"

@class QNDAnimatedView;

extern float const QND_VIEW_ANIMATION_DEFAULT_ANIMATION_DURATION;

typedef void(^QNDViewAnimationCompletionBlock)(BOOL finished);

/**
 
 @see #newViewAnimationBlock:
 @see #animate:completion: to execute an animation
 */
@interface QNDViewAnimation : NSObject

//The animation block
@property (nonatomic, copy, readonly) QNDViewAnimationBlock viewAnimationBlock;

//The duration of the animation as passed in UIView animateWithDuration:animations:
@property (nonatomic, assign, readonly) NSTimeInterval duration;

//The previous animation
//@nillable
@property (nonatomic, strong, readonly) QNDViewAnimation *previous;

//The next animation
//@nillable
@property (nonatomic, strong, readonly) QNDViewAnimation *next;

/**
 
 @see QNDViewAnimationBuilder to create a new QNDViewAnimation with optional attributes
 */
+(QNDViewAnimation*)newViewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock;

/**
 Animates the given view based on the viewAnimationBlock used to create self.
 
 @param view the view to execute the viewAnimationBlock used to create self
 @param @nillable completion will get a callback when the animation completes
 @return self for chaining
 @see UIView#animateWithDuration:animations:completion:
 */
-(QNDViewAnimation*)animate:(UIView*)view completion:(QNDViewAnimationCompletionBlock)completion;

-(QNDViewAnimation*)addViewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock;

-(QNDViewAnimation*)addViewAnimationBlockWithDuration:(NSTimeInterval)duration animation:(QNDViewAnimationBlock)viewAnimationBlock;

-(void)cycle:(QNDViewAnimation *)viewAnimation;
@end


/**
 Creates QNDViewAnimation(s) providing reasonable default values for optional arguments.

 Default values
    duration = 0.5
    previous = nil;
    next = nil;
 */
@interface QNDViewAnimationBuilder : NSObject

/**
 Creates a new QNDViewAnimation given an animation block.
 
 @param viewAnimationBlock the animation block
 */
-(instancetype)initWithViewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock;

/**
 Sets the previous animation to the animation that will be created by #newViewAnimation
 
 @returns self for chaining
 @see QNDViewAnimation#newViewAnimationBlock: to create a QNDViewAnimation
*/
-(instancetype)previous:(QNDViewAnimation*)previous;

/**
 Sets the next animation to the animation that will be created by #newViewAnimation
 
 @returns self for chaining
 @see QNDViewAnimation#newViewAnimationBlock: to create a QNDViewAnimation
 */
-(instancetype)next:(QNDViewAnimation*)next;

/**
 Sets the duration of the animation
 
 @returns self for chaining
 */
-(instancetype)duration:(NSTimeInterval)duration;

/**
 @returns a new instance of a QNDViewAnimation based on any values used in self. 
 */
-(QNDViewAnimation*)newViewAnimation;

@end

/**
 Implementations of this protocol support the notion of "rewinding", "toggling" and "forwarding" animations.
 
 @see QNDAnimations on creating QNDAnimatedView(s)
 @see #rewind
 @see #toggle
 @see #forward
 */
@protocol QNDAnimatedView <NSObject>

/**
 Adds the animation to the animated view.
 
 The current animation become a previous one to the given viewAnimation.
 
 @param duration the duration of the animation
 @param viewAnimationBlock the view animation block to add
 */
-(QNDViewAnimation*)addViewAnimationBlockWithDuration:(NSTimeInterval)duration animation:(QNDViewAnimationBlock)viewAnimationBlock;

/**
 Creates a circle between the given viewAnimation and the one given in the last call of #animateWithDuration:animation:
 
 Effectively the animation flow will be represented as
 
   current animation (forward)> viewAnimation
   current animation <(rewind) viewAnimation
 
 @param viewAnimation the view animation to cycle with. 
 */
-(void)cycle:(QNDViewAnimation *)viewAnimation;

/**
 
 */
-(QNDViewAnimation*)addViewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock;

/**
 Executes the given animation block at the given duration.
 
 @postcondition the given animation block is recorded for rewinding.
 @param duration duration the duration of the animation
 @param viewAnimationBlock viewAnimationBlock the
 @return the QNDViewAnimation animated
 @see UIView#animateWithDuration:animations:
 @see #rewind
 */
-(QNDViewAnimation*)animateWithDuration:(NSTimeInterval)duration animation:(QNDViewAnimationBlock)viewAnimationBlock;

/**
 
 */
-(QNDViewAnimation*)play;

/**
 
 */
-(QNDViewAnimation*)play:(QNDViewAnimationCompletionBlock)completion;

/**
 Plays the animation block that comes after the one given in the last call of #animateWithDuration:animation:
 
 @postcondion the last played animation is lost.
 @return the animation played
 */
-(QNDViewAnimation*)forward;

/**
 Plays the animation block that comes after the one given in the last call of #animateWithDuration:animation:

 Given a completion block, will get a callback once the animation is finished.
 
 @postcondion the last played animation is lost.
 @param @nilable completion callback when rewind is finished
 @return the animation played
 @see UIView#animateWithDuration:animations:completion:
 
 */
-(QNDViewAnimation*)forward:(QNDViewAnimationCompletionBlock)completion;

/**
 Plays the animation block that preceded the one given in the last call of #animateWithDuration:animation:
 
 @postcondion the last played animation is lost.
 @return the animation played
 */
-(QNDViewAnimation*)rewind;

/**
 Plays the animation block that preceded the one given in the last call of #animateWithDuration:animation:

 Given a completion block, will get a callback once the animation is finished.

 @postcondion the last played animation is lost.
 @param @nilable completion callback when rewind is finished
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

/**
 An UIVIew implementation that supports the QNDAnimatedView protocol.
 
 Calls to #forward and #rewind are O(1) in time.
 
 This implementation does not enforce a particular state in the animation flow. 
 Hence, any "consistency" remains the responsibility of the client code.
 
 This animated view comes with a starting animation, which always sets the frame of the view
 to the one given when created.
 
 @nonThreadSafe(MainThread) use this class only from the main thread.
 @final subclassing is not supported.
 @see QNDAnimatedViewProxy#newAnimatedViewProxy: on how to create an QNDAnimatedView, given an UIView instance.
 */
@interface QNDAnimatedView : UIView <QNDAnimatedView>

@end
