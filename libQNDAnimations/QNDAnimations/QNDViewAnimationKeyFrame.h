//
//  QNDViewAnimationKeyFrame.h
//  QNDAnimations
//
//  Created by Markos Charatzas on 20/04/2013.
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

#import <Foundation/Foundation.h>
#import "QNDAnimatedView.h"

@interface QNDViewAnimationKeyFrame : NSObject
@property (nonatomic, copy) QNDViewAnimationBlock viewAnimationBlock;
@property (nonatomic, strong) QNDViewAnimationKeyFrame *previousViewAnimationKeyFrame;
@property (nonatomic, strong) QNDViewAnimationKeyFrame *nextViewAnimationKeyFrame;

/**
 
 */
+(instancetype)newViewAnimationKeyFrame:(QNDViewAnimationBlock)viewAnimationBlock;

/**
 
 */
-(QNDViewAnimationKeyFrame *)addViewAnimationBlock:(QNDViewAnimationBlock)viewAnimationBlock;

-(void)cycle:(QNDViewAnimationKeyFrame *)viewAnimationKeyFrame;
@end
