//
//  NSDate+Helper.m
//

#import "NSDate+Helper.h"

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

static NSDateFormatter* sImportDateFormatter = nil;
static NSDateFormatter* sExportDateFormatter1 = nil;
static NSDateFormatter* sExportDateFormatter2 = nil;

@implementation NSDate (Helper)

+ (NSDate*)dateWithString:(NSString*)string
{
    if (string == nil)
        return nil;
    
    if (sImportDateFormatter == nil)
    {
        sImportDateFormatter = [[NSDateFormatter alloc] init];
        [sImportDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    }
    
    return [sImportDateFormatter dateFromString:string];
}

+ (NSString*)dateStringWithDate:(NSDate*)date
{
    if (date == nil)
        return nil;
    
    NSDateFormatter* df = nil;
    
    if ([date isToday])
    {
        if (sExportDateFormatter2 == nil)
        {
            sExportDateFormatter2 = [[NSDateFormatter alloc] init];
            [sExportDateFormatter2 setDateStyle:NSDateFormatterNoStyle];
            [sExportDateFormatter2 setTimeStyle:NSDateFormatterShortStyle];
        }
        df = sExportDateFormatter2;
    }
    else
    {
        if (sExportDateFormatter1 == nil)
        {
            sExportDateFormatter1 = [[NSDateFormatter alloc] init];
            [sExportDateFormatter1 setDateFormat:@"MMM d"];
        }
        df = sExportDateFormatter1;
    }
    
    return [df stringFromDate:date];
}

#pragma mark -

- (BOOL)isEqualToDateIgnoringTime:(NSDate*)aDate
{
	NSDateComponents* components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents* components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return (([components1 year] == [components2 year]) && ([components1 month] == [components2 month]) && ([components1 day] == [components2 day]));
}

- (BOOL)isToday
{
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}

@end
