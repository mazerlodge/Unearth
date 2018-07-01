//
//  UnearthGameEngine.h
//  Unearth
//
//  Created by mazerlodge on 7/1/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnearthGameEngine : NSObject {
    
    NSArray *delverDeck;
    
}

/*
 
 > UnearthGameEngine
 - delverDeck        // 38x, each one of 11 possible types
 - ruinsDeck            // 25x
 - namedWonders         // named wonders selected for this game run.
 - ruinsStack        // ruins selected for this game run.
 - ruinsActive         // current face up ruins available for delving.
 - endOfAgeCard      // the end card for this game run
 - stoneBag            // initial stones for this game run (randomized)
 - players             // player objects for this game run.
 
 */

- (int) go;

@end
