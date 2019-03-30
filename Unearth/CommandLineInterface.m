//
//  CommandLineInterface.m
//  Unearth
//
//  Created by mazerlodge on 9/2/18.
//  Copyright © 2018 mazerlodge. All rights reserved.
//

#import "CommandLineInterface.h"

@implementation CommandLineInterface

- (NSString * ) getStr: (NSString *) msg {
    NSString *rval = @"NOT_SET";
    
    // TODO: How to scan for strings, fails with large strings.
    // This is OK: upercalafragileistice
    // This isn't: upercalafragileisticex
    // Before makin ginputVal to an array, this caused 'illegal instruction': upercalafragileisticexpealli
    //    NSString *inMessage = [NSString stringWithCString:&inputVal encoding:NSUTF8StringEncoding];

    char inputVal[255] = {0};// = "NOT_SET";
    printf("%s", [msg UTF8String]);
    scanf("%s", inputVal);
    NSString *inMessage = [[NSString alloc] initWithUTF8String:inputVal];

    rval = inMessage;
    
    return rval;
    
}

- (int) getInt: (NSString *) msg  {
    
    int rval = -1;

    printf("%s", [msg UTF8String]);
    scanf("%i",&rval);
    
    return rval;
    
}

- (float) getFloat: (NSString *) msg {
    
    float rval = 0.0;

    printf("%s", [msg UTF8String]);
    scanf("%f",&rval);

    return rval;
    
}


- (void) put: (NSString *) msg {
    
    printf("%s", [msg UTF8String]);
    
    
}


@end
