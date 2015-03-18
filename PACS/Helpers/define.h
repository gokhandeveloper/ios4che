//
//  define.h
//  PACS
//
//  Created by Gokhan Dilek on 2015-02-09.
//  Copyright (c) 2015 Gokhan Dilek. All rights reserved.
//

#ifndef PACS_define_h
#define PACS_define_h

#define FIRST_TIME @"firstTime"
#define ISLOGGED_IN @"isloggedin"
#define DicomRowCount 3

#define IS_IPHONE_4 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)667) < DBL_EPSILON)
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)736) < DBL_EPSILON)

#define ANY_DATE @"Any Date"
#define TODAY @"Today"
#define THIS_WEEK @"This Week"
#define THIS_MONTH @"This Month"
#define THIS_YEAR @"This Year"
#define CUSTOM @"Custom"

#endif
