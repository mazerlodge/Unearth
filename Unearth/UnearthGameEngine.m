//
//  UnearthGameEngine.m
//  Unearth
//
//  Created by mazerlodge on 7/1/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "UnearthGameEngine.h"

@implementation UnearthGameEngine

- (id) init {
    cli = [[CommandLineInterface alloc] init];
    
    return self;
    
}

- (int) go {
    
    [cli put:@"Inside of UnearthGameEngine.\n"];
    
    return 0;
    
}


@end
