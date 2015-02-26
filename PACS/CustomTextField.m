//
//  CustomTextField.m
//  PACS
//
//  Created by Gokhan Dilek on 2015-02-11.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
 
    [self.delegate TapEvent:(int)self.tag];

}

@end
