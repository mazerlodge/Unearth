//
//  DelverDie.h
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RandomEngine.h"

typedef enum DelverDieColor : NSUInteger {
    DelverDieColorOrange = 0,
    DelverDieColorYellow = 1,
    DelverDieColorGreen = 2,
    DelverDieColorBlue = 3
} DelverDieColor;

typedef enum DelverDieSize : NSUInteger {
	DelverDieSizeNotSet = 0,
    DelverDieSize4 = 4,
    DelverDieSize6 = 6,
    DelverDieSize8 = 8
} DelverDieSize;

@interface DelverDie : NSObject {

	RandomEngine *re;
	int baseID;
    DelverDieColor color;
    DelverDieSize size;
	int dieValue;
    
}

+ (NSString *) DelverDieColorToString: (DelverDieColor) color;
+ (int) DelverDieSizeToNumber: (DelverDieSize) size;
+ (NSString *) DelverDieSizeToString: (DelverDieSize) size;
+ (NSInteger) DelverDieStringToNumber: (NSString *) dieString;
+ (DelverDieSize) DelverDieStringToSize: (NSString *) dieString;
+ (NSArray *) GetDieWords;

- (id) initWithColor: (DelverDieColor) dieColor size:(DelverDieSize) dieSize
		   dieBaseID: (int) dieID randomEngine: (RandomEngine *) randEngine;

- (int) getDieID;
- (DelverDieSize) getDieSize;
- (int) getDieValue;
- (int) roll;
- (int) setDieValue: (int) value;

- (NSString *) toString;

@property (readwrite, assign) int dieID;
@property (readwrite, assign) DelverDieColor dieColor;
@property (readwrite, assign) DelverDieSize dieSize;


/*
 Method list from [Object Library.txt]
 > DelverDie
 - color                // indicates which player gets stones or die back when ruin claimed. org, yel, green, blue
 - size                // 4, 6, 8 (aka number of sides)
 
 */

@end
