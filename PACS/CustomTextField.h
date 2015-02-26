//
//  CustomTextField.h
//  PACS
//
//  Created by Gokhan Dilek on 2015-02-11.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CustomTextField;
@protocol CustomTextFieldDelegate <NSObject>

@optional
- (void) TapEvent:(int) tag;
@end

@interface CustomTextField : UITextField

{
    
}

@property (nonatomic,assign) id<CustomTextFieldDelegate> delegate;


@end
