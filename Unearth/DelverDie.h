//
//  DelverDie.h
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum DelverDieColor : NSUInteger {
    DelverDieColorOrange = 0,
    DelverDieColorYellow = 1,
    DelverDieColorGreen = 2,
    DelverDieColorBlue = 3
} DelverDieColor;

typedef enum DelverDieSize : NSUInteger {
    DelverDieSize4 = 0,
    DelverDieSize6 = 1,
    DelverDieSize8 = 2
} DelverDieSize;

@interface DelverDie : NSObject {
    DelverDieColor color;
    DelverDieSize size;
    
}


/*
 Method list from [Object Library.txt]
 > DelverDie
 - color                // indicates which player gets stones or die back when ruin claimed. org, yel, green, blue
 - size                // 4, 6, 8 (aka number of sides)
 
 */

@end
