//
//  CommandLineInterface.h
//  Unearth
//
//  Created by mazerlodge on 9/2/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandLineInterface : NSObject

- (NSString *) getStr: (NSString *) msg;
- (int) getInt: (NSString *) msg;
- (float) getFloat: (NSString *) msg;

- (void) put: (NSString *) msg;

@end
