# Introduction
This is an implementation of a UIView that introduces the idea of "rewinding", "toggling" and "forwarding" in animations. 

[Discussion][3]

* Rewinding allows for past animations to be played again.
* Forwarding allows playing a pre-built animation flow.
* Toggling given an animation, toggle will "rewind" and "forward" this animation for every pair call.

[Rewinding][2] | [Forwarding][4]

Rewind and Forward by extension makes "looping" between animations possible.

[Looping][5] 

# QNDAnimatedView

The QNDAnimatedView does not enforce a particular state in the animation flow, hence any "consistency" remains the responsibility of the client. This is by design so as not to pose any restrictions on the animations and make any judgements as to the said "consistency".

A series of technical posts will follow, on [how to think of UIKit Animations][1] in terms of the QNDAnimatedView and the reasoning behind its design.

# What is included

* libQNDAnimations    
The 'QNDAnimations.xcodeproj' builds a static library 'libQNDAnimations.a'

* QNDAnimationsApp    
The 'QNDAnimationsApp.xcodeproj' is the .app demoing the QNDAnimatedView.

# Cocoapods

  -> QNDAnimations (2.0)
   This is an implementation of a UIView that introduces the idea of 'rewinding' in animations.
   - Homepage: https://github.com/qnoid/QNDAnimations
   - Source:   https://github.com/qnoid/QNDAnimations.git
   - Versions: 2.0 [master repo]

# Versions
*2.0 Augment existing UIView(s). Additional support for "forwarding" and "looping" animations.  
1.0 initial version. Support for "rewind" and "toggle" animations.

# How to use

## Under Interface Builder
Drag a UIView in the xib and change its type to QNDAnimatedView.

## Under code

### Creating a new view

	UIView<QNDAnimatedView>* animatedView = [[QNDAnimations new] newViewAnimated:frame];

	[animatedView animateWithDuration:0.5 animation:^(UIView* view){ view.frame = newFrame; }];
	[animatedView rewind];

	[animatedView animateWithDuration:0.5 animation:^(UIView* view){ view.frame = newFrame; }];
	[animatedView toggle];
	[animatedView toggle];

    [animatedView addViewAnimationBlock:^(UIView *view) {
        view.frame = firstKeyFrame; }];
     
    [animatedView addViewAnimationBlock:^(UIView *view) {
        view.frame = secondKeyFrame; }];

    [self.animatedView forward];
    [self.animatedView forward];

### Augmenting an existing view

	UIView<QNDAnimatedView>* animatedView = [[QNDAnimations new] animateView:view];

# Demo

Open 'QNDAnimations.xcworkspace' and run the QNDAnimationsApp target.

## Future Work

Add support for timed animations.

[1]: http://qnoid.com
[2]: http://www.youtube.com/watch?v=Y_OuP9mpfMY&feature=youtu.be
[3]: https://plus.google.com/116431322187209993066/posts/fsXY6cVH2Vv 
[4]: http://www.youtube.com/watch?v=aijJ7nAfdvo
[5]: http://www.youtube.com/watch?v=CAOaKGn-K5g

# Licence

QNDAnimations published under the MIT license:

Copyright (C) 2013, Markos Charatzas (qnoid.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

