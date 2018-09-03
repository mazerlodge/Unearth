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
    
    // How to scan for strings, fails with large strings.
    // This is OK: upercalafragileistice
    // This isn't: upercalafragileisticex
    // This causes 'illegal instruction': upercalafragileisticexpealli
    char inputVal;// = "NOT_SET";
    printf("%s", [msg cStringUsingEncoding:NSUTF8StringEncoding]);
    scanf("%s", &inputVal);
    NSString *inMessage = [NSString stringWithCString:&inputVal encoding:NSUTF8StringEncoding];

    rval = inMessage;
    
    return rval;
    
}

- (int) getInt: (NSString *) msg  {
    
    int rval = -1;

    printf("%s", [msg cStringUsingEncoding:NSUTF8StringEncoding]);
    scanf("%i",&rval);
    
    return rval;
    
}

- (float) getFloat: (NSString *) msg {
    
    float rval = 0.0;

    printf("%s", [msg cStringUsingEncoding:NSUTF8StringEncoding]);
    scanf("%f",&rval);

    return rval;
    
}


- (void) put: (NSString *) msg {
    
    printf("%s\n", [msg cStringUsingEncoding:NSUTF8StringEncoding]);
    
    
}

- (void) drawMap: (UnearthPlayer *) player {
    
    // TODO: Implement drawMap.
}


@end
