//
//  Utilities.h
//  TimberJim
//
//  Created by Jeremy Novak on 3/11/16.
//  Copyright © 2016 Jeremy Novak. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#pragma mark - Debug
static const BOOL kDebug = NO;


#pragma mark - Screen Size and Positon
static __inline CGSize ScreenSize() {
    return [UIScreen mainScreen].bounds.size;
}

#pragma mark - Device Type
static __inline__ BOOL DeviceIsPad() {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

#pragma mark - Math Functions
static __inline__ int RandomIntegerBetween(int min, int max) {
    return min + arc4random_uniform(max - min + 1);
}

static __inline__ CGFloat RandomFloatRange(CGFloat min, CGFloat max) {
    return ((CGFloat)arc4random() / 0xFFFFFFFFu) * (max - min) + min;
}

#endif /* Constants_h */
