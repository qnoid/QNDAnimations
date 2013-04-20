# Introduction
This is an implementation of a UIView that introduces the idea of "rewinding" in animations. Rewinding allows for past animations to be played again.

[Demo][2]
<iframe width="420" height="315" src="http://www.youtube.com/embed/Y_OuP9mpfMY" frameborder="0" allowfullscreen></iframe>

The current implementation of rewinding also supports "toggling" an animation. That is, given an animation toggle will "rewind" and "playback" this animation for every pair call.

The QNDAnimatedView does not enforce a particular state in the animation flow, hence any "consistency" remains the responsibility of the client. This is by design so as not to pose any restrictions on the animations and make any judgements as to the said "consistency".

A series of technical posts will follow, on [how to think of UIKit Animations][1] in terms of the QNDAnimatedView and the reasoning behind its design.

# What is included

* libQNDAnimations
The 'QNDAnimations.xcodeproj' builds a static library 'libQNDAnimations.a'

* QNDAnimationsApp
The 'QNDAnimationsApp.xcodeproj' is the .app demoing the QNDAnimatedView.

# How to use

## Under Interface Builder
Drag a UIView in the xib and change its type to QNDAnimatedView.

## Under code

  UIView<QNDAnimatedView>* animatedView = [QNDAnimations newViewAnimated:frame];

	[animatedView animateWithDurations:0.5 animation:^(UIView* view){ view.frame = newFrame; }];

	[animatedView rewind];

	[animatedView animateWithDurations:0.5 animation:^(UIView* view){ view.frame = newFrame; }];

	[animatedView toggle];


# Demo

Open 'QNDAnimations.xcworkspace' and run the QNDAnimationsApp target.

## Future Work

Ability to augment an existing UIView as animated.

[1]: http://qnoid.com
[2]: http://www.youtube.com/watch?v=Y_OuP9mpfMY&feature=youtu.be

# Licence

QNDAnimations published under the MIT license:

Copyright (C) 2013, Markos Charatzas (qnoid.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

