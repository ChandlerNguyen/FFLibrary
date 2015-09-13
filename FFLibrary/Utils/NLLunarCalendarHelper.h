//
//  NLLunarCalendarHelper.h
//  MyApp
//
//  Created by Nguyen Nang on 5/7/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

@interface NLLunarCalendarHelper : NSObject

+ (NSArray *)convertSolar2Lunar:(NSInteger)dd month:(NSInteger)mm year:(NSInteger)yy timeZone:(double)timeZone;

+ (NSArray *)convertLunar2Solar:(NSInteger)lunarDay LunaMonth:(NSInteger)lunarMonth LunaYear:(NSInteger)lunarYear LunaLeap:(NSInteger)lunarLeap TimeZone:(double)timeZone;

+ (NSArray *)TinhChiNgay:(NSString *)_NgayDuong;

+ (NSString *)NgayCanChiWithDate:(NSDate *)date;
+ (NSString *)NamCanChiWithDate:(NSDate *)date;
+ (NSString *)ThangCanChiWithDate:(NSDate *)date;
+ (NSString *)GioCanChiWithDate:(NSDate *)date;

+ (NSString *)NgayCanChi:(NSString *)ngayDuong;
+ (NSString *)NamCanChi:(NSString *)ngayDuong;
+ (NSString *)ThangCanChi:(NSString *)ngayDuong;

+ (NSArray*)TinhTrucWithDate:(NSDate*)date;

+ (NSString *)GioCanChi:(NSString *)ngayDuong;

+ (NSArray *)LayGioHoangDaoWithDate:(NSDate *)date;

+ (NSArray *)LayGioHoangDao:(NSString *)_NgayDuong;
+ (NSArray *)LayGioHoangDao2:(NSString *)_NgayDuong;

+ (BOOL)TinhNgayHoangDao:(NSString *)_NgayDuong ThangAm:(NSInteger)_ThangAm;

+ (BOOL)TinhNgayHoangDao:(NSString *)ngayDuong;

+ (BOOL)isHoangDao:(NSDate *)date;

+ (NSArray *)TinhMenhNguHanh:(NSString *)_NgayDuong NamHoacNgay:(NSString *)NamHoacNgay;

+ (NSArray *)LayTietKhi:(NSDate *)date;

+ (NSArray *)TinhTietKhi:(NSString *)_NgayDuong;

+ (NSString *)getTietKhi:(NSInteger)d Month:(NSInteger)m Year:(NSInteger)y Hour:(NSInteger)hour Minute:(NSInteger)min;

+ (NSInteger)getTietKhiInt:(NSInteger)d Month:(NSInteger)m Year:(NSInteger)y Hour:(NSInteger)hour Minute:(NSInteger)min;

+ (NSArray *)TinhTruc:(NSString *)_NgayDuong;

+ (int)getDayCountOfaMonth:(NSInteger)month Year:(NSInteger)year;

+ (NSString *)GetDayOfWeekWithDate:(NSDate *)date;

+ (NSString *)GetDayOfWeek:(NSInteger)ngay thang:(NSInteger)thang nam:(NSInteger)nam;

+ (NSString *)GetThangAm:(NSInteger)Number;

+ (NSString *)HyThan:(NSInteger)dd Mounth:(NSInteger)mm Year:(NSInteger)yy;
+ (NSString *)TaiThan:(NSInteger)dd Month:(NSInteger)mm Year:(NSInteger)yy;
+ (BOOL)isTetDL:(NSDate *)ddate;
+ (BOOL)isTetAL:(NSDate *)ddate;

// Lấy thông tin ngày âm (lunar day)
+ (NSDictionary*)getLunarInfoWithSolarDate:(NSDate*)date;
+ (NSString*)GetAnhConGiapTheoNgay:(NSString*)_ChiNgay;

+ (NSInteger)isLunarLeapYear:(int)lunarYear;
@end
