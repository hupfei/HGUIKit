//
//  NSString+HGUI.m
//  HGUIKit
//

#import "NSString+HGUI.h"

@implementation NSString (HGUI)

//获取当前时间戳  （以秒为单位）
+(NSString *)getNowTimeTimestamp {
    NSInteger timeSp = [[NSDate date] timeIntervalSince1970];
    
    return [NSString stringWithFormat:@"%ld",(long)timeSp];
    
}

+ (NSString *)stringWithbytes:(NSUInteger)bytes {
    if (bytes < 1024) { // B
        return [NSString stringWithFormat:@"%@B", @(bytes)];
    } else if (bytes >= 1024 && bytes < 1024 * 1024) { // KB
        return [NSString stringWithFormat:@"%.2fKB", (double)bytes / 1024];
    } else if (bytes >= 1024 * 1024 && bytes < 1024 * 1024 * 1024) { // MB
        return [NSString stringWithFormat:@"%.2fMB", (double)bytes / (1024 * 1024)];
    } else { // GB
        return [NSString stringWithFormat:@"%.2fGB", (double)bytes / (1024 * 1024 * 1024)];
    }
}

+ (NSString *)formatTimeInterval:(NSTimeInterval)secs {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:date];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc ] init];
    if (nowCmps.day==myCmps.day) {
        dateFmt.dateFormat = @"HH:mm";
    } else if((nowCmps.day-myCmps.day) == 1) {
        dateFmt.dateFormat = @"昨天 HH:mm";
    }  else if((nowCmps.day-myCmps.day) == 2) {
        dateFmt.dateFormat = @"前天 HH:mm";
    } else {
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    return [dateFmt stringFromDate:date];
}

+ (NSString *)formatTimeInterval:(NSTimeInterval)secs dateFormat:(NSString *)dateFormat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secs];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (dateFormat.length <= 0) {
        dateFormat = @"yyyy-MM-dd HH:mm";
    }
    [formatter setDateFormat:dateFormat];
    return [formatter stringFromDate:date];
}

@end
