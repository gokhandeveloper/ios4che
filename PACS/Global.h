//
//  Global.h
//  PACS
//
//  Created by Gokhan Dilek on 2015-01-28.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#import <foundation/Foundation.h>

@interface Global : NSObject

@property (nonatomic) NSString *strPatientId;
@property (nonatomic) NSString *strPatientName;
@property (nonatomic) NSString *strStartdDate;
@property (nonatomic) NSString *strEndDate;
@property (nonatomic) NSString *strModality;
@property (nonatomic) NSMutableArray *arrDicomData;
@property (nonatomic) NSString *stIDNum;

//filtering breaks if I passed the above parameters; that's why the properties had to be set
@property (nonatomic) NSString *patientNameTobePassedToOtherViewers;
@property (nonatomic) NSString *patientIDTobePassedToOtherViewers;
@property (nonatomic) int nStudyIDNum;
@property (nonatomic) int nDicomIndex;
@property (nonatomic) int imageNumber;
//@property (nonatomic) NSString *wadoUrl;
//@property (nonatomic) BOOL isFromModalityPickerToFilter;

@property (nonatomic) BOOL isFromStartDatePickerToDateSelect;
@property (nonatomic) BOOL isFromEndDatePickerToDateSelect;

@property (nonatomic) NSString *filterDateType;


+ (Global *)sharedGlobal;

@end