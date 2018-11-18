//
//  DelverCard.h
//  Unearth
//
//  Created by mazerlodge on 8/19/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DelverCard : NSObject {
    NSString *rawData;
    
    
}


- (id) initWithString: (NSString *) cardData;

/*
 Method list from [Object Library.txt]
 > DelverCard
 - type                 // used to access name, text, and rule impact

 */

@end
