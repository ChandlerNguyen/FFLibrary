//
//  NLLunarCalendarHelper.m
//  MyApp
//
//  Created by Nguyen Nang on 5/7/15.
//  Copyright (c) 2015 Nguyen Nang. All rights reserved.
//

#import "NLLunarCalendarHelper.h"
#import "NSDate+FFAdditions.h"

static NSString *const NgayBatDauChi = @"1924-02-15";
static NSString *const NgayBatDauCan = @"1924-02-15";
static NSString *const NgayBatDauNam = @"1924-02-15";
static const double kTimeZoneVietNam = 7.0;
static dispatch_once_t NLLunarCalendarCanIdentifierLock_onceToken;
static dispatch_once_t NLLunarCalendarChiIdentifierLock_onceToken;
static dispatch_once_t NLLunarCalendarKhoangGioIdentifierLock_onceToken;

@implementation NLLunarCalendarHelper

+ (NSArray *)Chi
{
    static NSArray *_Chi;
    dispatch_once(&NLLunarCalendarCanIdentifierLock_onceToken, ^{
        _Chi = @[@"Tý", @"Sửu", @"Dần", @"Mão", @"Thìn", @"Tỵ", @"Ngọ", @"Mùi", @"Thân", @"Dậu", @"Tuất", @"Hợi"];
    });
    return _Chi;
}

+ (NSArray *)Can
{
    static NSArray *_Can;
    dispatch_once(&NLLunarCalendarChiIdentifierLock_onceToken, ^{
        _Can = @[@"Giáp", @"Ất", @"Bính", @"Đinh", @"Mậu", @"Kỷ", @"Canh", @"Tân", @"Nhâm", @"Quý"];
    });
    return _Can;
}

+ (NSArray *)KhoangGio
{
    static NSArray *_KhoangGio;
    dispatch_once(&NLLunarCalendarKhoangGioIdentifierLock_onceToken, ^{
        _KhoangGio = @[@"23h-1h", @"1h-3h", @"3h-5h", @"5h-7h", @"7h-9h", @"9h-11h", @"11h-13h", @"13h-15h", @"15h-17h", @"17h-19h", @"19h-21h", @"21h-23h"];
    });
    return _KhoangGio;
}

/**
*
* @param dd
* @param mm
* @param yy
* @return the number of days since 1 January 4713 BC (Julian calendar)
*/
+ (NSInteger)jdFromDate:(NSInteger)dd month:(NSInteger)mm year:(NSInteger)yy {
    NSInteger a = (14 - mm) / 12;
    NSInteger y = yy + 4800 - a;
    NSInteger m = mm + 12 * a - 3;
    NSInteger jd = dd + (153 * m + 2) / 5 + 365 * y + y / 4 - y / 100 + y / 400
            - 32045;
    if (jd < 2299161) {
        jd = dd + (153 * m + 2) / 5 + 365 * y + y / 4 - 32083;
    }
    return jd;
}

+ (NSArray *)jdToDate:(NSInteger)jd {
    NSInteger a, b, c;
    if (jd > 2299160) { // sau 5/10/1582, lich Gregorian
        a = jd + 32044;
        b = (4 * a + 3) / 146097;
        c = a - (b * 146097) / 4;
    } else {
        b = 0;
        c = jd + 32082;
    }
    NSInteger d = (4 * c + 3) / 1461;
    NSInteger e = c - (1461 * d) / 4;
    NSInteger m = (5 * e + 2) / 153;
    NSInteger day = e - (153 * m + 2) / 5 + 1;
    NSInteger month = m + 3 - 12 * (m / 10);
    NSInteger year = b * 100 + d - 4800 + m / 10;
    NSArray *tmpl = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld", (long)day], [NSString stringWithFormat:@"%ld", (long)month], [NSString stringWithFormat:@"%ld", (long)year], nil];
    // khi dùng phải đổi lại các objects thành NSInteger
    return tmpl;
}

+ (double) NewMoonAA98:(NSInteger)k {
    double T = k / 1236.85;
    double T2 = T * T;
    double T3 = T2 * T;
    double dr = M_PI / 180;
    double Jd1 = 2415020.75933 + 29.53058868 * k + 0.0001178 * T2
            - 0.000000155 * T3;
    Jd1 = Jd1 + 0.00033 * sin((166.56 + 132.87 * T - 0.009173 * T2) * dr);
    double M = 359.2242 + 29.10535608 * k - 0.0000333 * T2 - 0.00000347 * T3;
    double Mpr = 306.0253 + 385.81691806 * k + 0.0107306 * T2 + 0.00001236 * T3;
    double F = 21.2964 + 390.67050646 * k - 0.0016528 * T2 - 0.00000239 * T3;
    double C1 = (0.1734 - 0.000393 * T) * sin(M * dr) + 0.0021 * sin(2 * dr * M);
    C1 = C1 - 0.4068 * sin(Mpr * dr) + 0.0161 * sin(dr * 2 * Mpr);
    C1 = C1 - 0.0004 * sin(dr * 3 * Mpr);
    C1 = C1 + 0.0104 * sin(dr * 2 * F) - 0.0051 * sin(dr * (M + Mpr));
    C1 = C1 - 0.0074 * sin(dr * (M - Mpr)) + 0.0004 * sin(dr * (2 * F + M));
    C1 = C1 - 0.0004 * sin(dr * (2 * F - M)) - 0.0006 * sin(dr * (2 * F + Mpr));
    C1 = C1 + 0.0010 * sin(dr * (2 * F - Mpr)) + 0.0005 * sin(dr * (2 * Mpr + M));
    double deltat;
    if (T < -11) {
        deltat = 0.001 + 0.000839 * T + 0.0002261 * T2 - 0.00000845 * T3
                - 0.000000081 * T * T3;
    } else {
        deltat = -0.000278 + 0.000265 * T + 0.000262 * T2;
    }

    double JdNew = Jd1 + C1 - deltat;

    return JdNew;
}

+ (NSInteger)INT:(double)d {
    return (int)floor(d);
}

+ (NSInteger)getNewMoonDay:(NSInteger)k TimeZone:(double)timeZone {
    double jd = [[self class] NewMoonAA98:k];
    return [[self class] INT:(jd + 0.5 + timeZone / 24)];
}

+ (double)SunLongitude:(double)jdn {
    return [[self class] SunLongitudeAA98:jdn];
}

+ (double)SunLongitudeAA98:(double)jdn {
    double T = (jdn - 2451545.0) / 36525;
    double T2 = T * T;
    double dr = M_PI / 180;
    double M = 357.52910 + 35999.05030 * T - 0.0001559 * T2 - 0.00000048 * T * T2;
    double L0 = 280.46645 + 36000.76983 * T + 0.0003032 * T2;
    double DL = (1.914600 - 0.004817 * T - 0.000014 * T2) * sin(dr * M);
    DL = DL + (0.019993 - 0.000101 * T) * sin(dr * 2 * M) + 0.000290 * sin(dr * 3 * M);
    double L = L0 + DL;
    L = L - 360 * [[self class] INT:(L / 360)];
    return L;
}

+ (double)getSunLongitude:(NSInteger)dayNumber TimeZone:(double)timeZone {
    return [[self class] SunLongitude:(dayNumber - 0.5 - timeZone / 24)];
}

+ (NSInteger)getLunarMonth11:(NSInteger)yy TimeZone:(double)timeZone {
    double off = [[self class] jdFromDate:31 month:12 year:yy] - 2415021.076998695;
    NSInteger k = [[self class] INT:(off / 29.530588853)];
    NSInteger nm = [[self class] getNewMoonDay:k TimeZone:timeZone];
    NSInteger sunLong = [[self class] INT:([self getSunLongitude:nm TimeZone:timeZone] / 30)];
    if (sunLong >= 9) {
        nm = [[self class] getNewMoonDay:k-1 TimeZone:timeZone];
    }
    return nm;
}

+ (NSInteger)getLeapMonthOffset:(NSInteger)a11 TimeZone:(double)timeZone {
    NSInteger k = [[self class] INT:(0.5 + (a11 - 2415021.076998695) / 29.530588853)];
    NSInteger last;
    NSInteger i = 1;

    NSInteger arc = [[self class] INT:([[self class] getSunLongitude:[[self class] getNewMoonDay:(k+1) TimeZone:timeZone] TimeZone:timeZone] / 30)];

    do {
        last = arc;
        i++;
        arc = [[self class] INT:([self getSunLongitude:([[self class] getNewMoonDay:(k+i) TimeZone:timeZone]) TimeZone:timeZone] / 30)];
    } while (arc != last && i < 14);
    return i - 1;
}

+ (NSArray *)convertSolar2Lunar:(NSInteger)dd month:(NSInteger)mm year:(NSInteger)yy timeZone:(double)timeZone {
    NSInteger lunarDay, lunarMonth, lunarYear, lunarLeap;
    NSInteger dayNumber = [[self class] jdFromDate:dd month:mm year:yy];
    NSInteger k = [[self class] INT:((dayNumber - 2415021.076998695) / 29.530588853)];
    NSInteger monthStart = [[self class] getNewMoonDay:(k+1) TimeZone:timeZone];
    if (monthStart > dayNumber) {
        monthStart = [[self class] getNewMoonDay:k TimeZone:timeZone];
    }
    NSInteger a11 = [[self class] getLunarMonth11:yy TimeZone:timeZone];
    NSInteger b11 = a11;
    if (a11 >= monthStart) {
        lunarYear = yy;
        a11 = [[self class] getLunarMonth11:(yy-1) TimeZone:timeZone];
    } else {
        lunarYear = yy + 1;
        b11 = [[self class] getLunarMonth11:(yy+1) TimeZone:timeZone];
    }
    lunarDay = dayNumber - monthStart + 1;
    NSInteger diff = [[self class] INT:((monthStart - a11) / 29)];
    lunarLeap = 0;
    lunarMonth = diff + 11;
    if (b11 - a11 > 365) {
        NSInteger leapMonthDiff = [[self class] getLunarMonth11:a11 TimeZone:timeZone];
        if (diff >= leapMonthDiff) {
            lunarMonth = diff + 10;
            if (diff == leapMonthDiff) {
                lunarLeap = 1;
            }
        }
    }
    if (lunarMonth > 12) {
        lunarMonth = lunarMonth - 12;
    }
    if (lunarMonth >= 11 && diff < 4) {
        lunarYear -= 1;
    }

    NSArray *tmpl = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld", (long)lunarDay], [NSString stringWithFormat:@"%ld", (long)lunarMonth], [NSString stringWithFormat:@"%ld", (long)lunarYear], nil];
    // khi dùng phải đổi lại các objects thành NSInteger
    return tmpl;

    //return new short[] { (short) lunarDay, (short) lunarMonth, (short) lunarYear };
    // return new int[]{lunarDay, lunarMonth, lunarYear, lunarLeap};
}

+ (NSArray *)convertLunar2Solar:(NSInteger)lunarDay LunaMonth:(NSInteger)lunarMonth LunaYear:(NSInteger)lunarYear LunaLeap:(NSInteger)lunarLeap TimeZone:(double)timeZone {
    NSInteger a11, b11;
    if (lunarMonth < 11) {
        a11 = [[self class] getLunarMonth11:(lunarYear-1) TimeZone:timeZone];// getLunarMonth11(lunarYear - 1, timeZone);
        b11 = [[self class] getLunarMonth11:lunarYear TimeZone:timeZone];// getLunarMonth11(lunarYear, timeZone);
    } else {
        a11 = [[self class] getLunarMonth11:lunarYear TimeZone:timeZone]; //getLunarMonth11(lunarYear, timeZone);
        b11 = [[self class] getLunarMonth11:(lunarYear+1) TimeZone:timeZone]; //getLunarMonth11(lunarYear + 1, timeZone);
    }
    NSInteger k = [[self class] INT:(0.5 + (a11 - 2415021.076998695) / 29.530588853)];
    NSInteger off = lunarMonth - 11;
    if (off < 0) {
        off += 12;
    }
    if (b11 - a11 > 365) {
        NSInteger leapOff = [[self class] getLeapMonthOffset:a11 TimeZone:timeZone];// getLeapMonthOffset(a11, timeZone);
        NSInteger leapMonth = leapOff - 2;
        if (leapMonth < 0) {
            leapMonth += 12;
        }
        if (lunarLeap != 0 && lunarMonth != leapMonth) {
            //return new int[] { 0, 0, 0};
            NSArray *tmp1 = [NSArray arrayWithObjects:@"0", @"0", @"0", nil];
            return tmp1;
        } else if (lunarLeap != 0 || off >= leapOff)
            off += 1;
    }

    NSInteger monthStart = [[self class] getNewMoonDay:(k+off) TimeZone:timeZone];// getNewMoonDay(k + off, timeZone);
    //int[] s = jdToDate(monthStart + lunarDay - 1);
    //return new int[] { s[0], s[1], s[2] };
    // return jdToDate(monthStart+lunarDay-1);
    return [[self class] jdToDate:(monthStart + lunarDay - 1)];
}

// date with format yyyy-mm-dd
+ (NSInteger) DateDiff:(NSString*)StartDate EndDate:(NSString*)EndDate DiffType:(NSString*)DiffType {
    NSDate *Date1 = [NSDate dateFromString:StartDate withFormat:[NSDate dateFormatString]]; //new Date(StartDate);
    NSDate * Date2 = [NSDate dateFromString:EndDate withFormat:[NSDate dateFormatString]]; //new Date(EndDate);
    
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:Date1];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:Date2];
    
    NSInteger NumberDiff;
    if ([DiffType is:@"Nam"]) {
        NSDateComponents *difference = [calendar components:NSCalendarUnitYear
                                                   fromDate:fromDate toDate:toDate options:0];
        NumberDiff = [difference year];
    } else if ([DiffType is:@"Ngay"]) {
        NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                                   fromDate:fromDate toDate:toDate options:0];
        NumberDiff = [difference day];
    } else {
        NSAssert(true, @"UNDEFINED");
    }
    
    return NumberDiff;
}

+ (NSArray*)TinhCanNgay:(NSString*)_NgayDuong {
    NSInteger Index = [[self class] DateDiff:NgayBatDauCan EndDate:_NgayDuong DiffType:@"Ngay"];
    Index = (10 + Index % 10) % 10;
    
    return @[[[self class] Can][Index], @(Index)];
}

+ (NSArray*)TinhChiNgay:(NSString*)_NgayDuong {
    NSInteger Index = [[self class] DateDiff:NgayBatDauChi EndDate:_NgayDuong DiffType:@"Ngay"];
    Index = (12 + Index % 12) % 12;
    return @[[[self class] Chi][Index], @(Index)];
}

+ (NSString *)NgayCanChiWithDate:(NSDate *)date {
    NSString *strDate = [date stringWithDateFormat:[NSDate dateFormatString]];
    return [[self class] NgayCanChi:strDate];
}

+ (NSString*)NgayCanChi:(NSString*)ngayDuong {
    NSArray *can = [[self class] TinhCanNgay:ngayDuong];
    NSArray *chi = [[self class] TinhChiNgay:ngayDuong];
    return [NSString stringWithFormat:@"Ngày %@ %@", can[0], chi[0]];
}

+ (NSArray*)TinhCanNam:(NSString*)_NgayDuong {
    NSInteger Index = [[self class] DateDiff:NgayBatDauNam EndDate:_NgayDuong DiffType:@"Nam"];
    Index = (10 + Index % 10) % 10;
    
    return @[[[self class] Can][Index], @(Index)];
    
}

+ (NSArray*)TinhChiNam:(NSString*)_NgayDuong {
    NSInteger Index = [[self class] DateDiff:NgayBatDauNam EndDate:_NgayDuong DiffType:@"Nam"];
    Index = (12 + Index % 12) % 12;
    return @[[[self class] Chi][Index], @(Index)];
    
}

+ (NSString *)NamCanChiWithDate:(NSDate *)date {
    NSString *strDate = [date stringWithDateFormat:[NSDate dateFormatString]];
    return [[self class] NamCanChi:strDate];
}

+ (NSString*)NamCanChi:(NSString*)ngayDuong {
    NSArray *can = [[self class] TinhCanNam:ngayDuong];
    NSArray *chi = [[self class] TinhChiNam:ngayDuong];
    return [NSString stringWithFormat:@"Năm %@ %@", can[0], chi[0]];
}

+ (NSArray*)TinhCanThang:(NSInteger)_ThangAm namAm:(NSInteger)_NamAm {
    NSInteger Index = (12 * _NamAm + _ThangAm + 3) % 10;
    return @[[[self class] Can][Index], @(Index)];
}

+ (NSArray*)TinhChiThang:(NSInteger)_ThangAm {
    NSInteger Index = (_ThangAm + 1) % 12;
    return @[[[self class] Chi][Index], @(Index)];
}

+ (NSString *)ThangCanChiWithDate:(NSDate *)date {
    NSString *strDate = [date stringWithDateFormat:[NSDate dateFormatString]];
    return [[self class] ThangCanChi:strDate];
}

+ (NSString*)ThangCanChi:(NSString*)ngayDuong {
    NSDate *date = [NSDate dateFromString:ngayDuong withFormat:[NSDate dateFormatString]];

    NSArray *NgayThangNamAm = [[self class] convertSolar2Lunar:date.day month:date.month year:date.year timeZone:kTimeZoneVietNam];
    NSInteger ThangAm = [NgayThangNamAm[1] integerValue];
    NSInteger NamAm = [NgayThangNamAm[2] integerValue];
    //NSInteger NgayAm = [NgayThangNamAm[0] integerValue];

    NSArray *CanThang = [[self class] TinhCanThang:ThangAm namAm:NamAm];// TinhCanThang(ThangAm, NamAm);
    NSArray *ChiThang = [[self class] TinhChiThang:ThangAm];// TinhChiThang(ThangAm);
    return [NSString stringWithFormat:@"Tháng %@ %@", CanThang[0], ChiThang[0]];
}

+(NSArray *)TinhCanGio:(NSString *)_NgayDuong GioXem:(NSInteger)_GioXem {

    NSArray * ChiGio = [[self class] TinhChiGio:_GioXem];
    NSInteger IndexChi = [ChiGio[1] integerValue];
    NSInteger Index = [[self class] DateDiff:NgayBatDauCan EndDate:_NgayDuong DiffType:@"Ngay"];
    Index = (10 + Index % 10) % 10; Index = 2 * Index % 10;
    if (IndexChi > 0) { Index = (Index + IndexChi) % 10; }
    return @[[[self class] Can][Index], @(Index)];
    //return new Array(Can[Index], Index);
}

+(NSArray *)TinhChiGio:(NSInteger )GioXem {
    NSInteger Index;
    if (GioXem >= 23 || GioXem < 1) { Index = 0; }
    else if (GioXem >= 1 && GioXem < 3) { Index = 1; }
    else if (GioXem >= 3 && GioXem < 5) { Index = 2; }
    else if (GioXem >= 5 && GioXem < 7) { Index = 3; }
    else if (GioXem >= 7 && GioXem < 9) { Index = 4; }
    else if (GioXem >= 9 && GioXem < 11) { Index = 5; }
    else if (GioXem >= 11 && GioXem < 13) { Index = 6; }
    else if (GioXem >= 13 && GioXem < 15) { Index = 7; }
    else if (GioXem >= 15 && GioXem < 17) { Index = 8; }
    else if (GioXem >= 17 && GioXem < 19) { Index = 9; }
    else if (GioXem >= 19 && GioXem < 21) { Index = 10; }
    else if (GioXem >= 21 && GioXem < 23) { Index = 11; }

    return @[[[self class] Chi][Index], @(Index)];
}

+ (NSString *)GioCanChiWithDate:(NSDate *)date {
    NSString *ngayDuong = [date stringWithDateFormat:[NSDate dateFormatString]];
    NSDate * GioHienTai = [NSDate now];

    NSArray * CanGio = [[self class] TinhCanGio:ngayDuong GioXem:GioHienTai.hour];
    NSArray * ChiGio = [[self class] TinhChiGio:GioHienTai.hour];

    return [NSString stringWithFormat:@"Giờ %@ %@", CanGio[0], ChiGio[0]];
}

+ (NSString *)GioCanChi:(NSString *)ngayDuong {
    NSDate * GioHienTai = [NSDate now];

    NSArray * CanGio = [[self class] TinhCanGio:ngayDuong GioXem:GioHienTai.hour];
    NSArray * ChiGio = [[self class] TinhChiGio:GioHienTai.hour];

    return [NSString stringWithFormat:@"Giờ %@ %@", CanGio[0], ChiGio[0]];
}

+ (BOOL) TinhGioHoangDao:(NSString *)_NgayDuong GioXem:(NSInteger) GioXem {

    NSArray *GioHoangDao = @[
            @[@(1), @(1), @(0), @(1), @(0), @(0), @(1), @(0), @(1), @(1), @(0), @(0)],
            @[@(0), @(0), @(1), @(1), @(0), @(1), @(0), @(0), @(1), @(0), @(1), @(1)],
            @[@(1), @(1), @(0), @(0), @(1), @(1), @(0), @(1), @(0), @(0), @(1), @(0)],
            @[@(1), @(0), @(1), @(1), @(0), @(0), @(1), @(1), @(0), @(1), @(0), @(0)],
            @[@(0), @(0), @(1), @(0), @(1), @(1), @(0), @(0), @(1), @(1), @(0), @(1)],
            @[@(0), @(1), @(0), @(0), @(1), @(0), @(1), @(1), @(0), @(0), @(1), @(1)]
    ];
//    GioHoangDao[0] = [1, 1, 0, 1, 0, 0, 1, 0, 1, 1, 0, 0];
//    GioHoangDao[1] = [0, 0, 1, 1, 0, 1, 0, 0, 1, 0, 1, 1];
//    GioHoangDao[2] = [1, 1, 0, 0, 1, 1, 0, 1, 0, 0, 1, 0];
//    GioHoangDao[3] = [1, 0, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0];
//    GioHoangDao[4] = [0, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0, 1];
//    GioHoangDao[5] = [0, 1, 0, 0, 1, 0, 1, 1, 0, 0, 1, 1];

    NSArray * _ChiNgay = [[self class] TinhChiNgay:_NgayDuong]; //TinhChiNgay(_NgayDuong);
    NSInteger IndexNgay = [_ChiNgay[1] integerValue];
    IndexNgay = IndexNgay % 6;
    NSArray * _ChiGio = [[self class] TinhChiGio:GioXem]; //TinhChiGio(GioXem);
    NSInteger IndexGio = [_ChiGio[1] integerValue];
    return [GioHoangDao[IndexNgay][IndexGio] boolValue];
}

+ (NSArray *)LayGioHoangDaoWithDate:(NSDate *)date {
    NSString *_NgayDuong = [date stringWithDateFormat:[NSDate dateFormatString]];
    return [[self class] LayGioHoangDao:_NgayDuong];
}

+ (NSArray *)LayGioHoangDaoWithDate2:(NSDate *)date {
    NSString *_NgayDuong = [date stringWithDateFormat:[NSDate dateFormatString]];
    return [[self class] LayGioHoangDao2:_NgayDuong];
}

+ (NSArray *)LayGioHoangDao2:(NSString *)_NgayDuong {
    NSMutableArray * _DanhSachGio = [NSMutableArray new];
    for (NSInteger index = 0; index < 24; index += 2) {
        BOOL gioHoangDao = [[self class] TinhGioHoangDao:_NgayDuong GioXem:index];
        if (gioHoangDao) {
            
            NSArray *chiGio = [[self class] TinhChiGio:index];
            NSString *result = [NSString stringWithFormat:@"%@", chiGio[0]];
            [_DanhSachGio addObject:result];
        }
    }
    return _DanhSachGio;
}

+ (NSArray *)LayGioHoangDao:(NSString *)_NgayDuong {
    NSMutableArray * _DanhSachGio = [NSMutableArray new];
    for (NSInteger index = 0; index < 24; index += 2) {
        BOOL gioHoangDao = [[self class] TinhGioHoangDao:_NgayDuong GioXem:index];
        if (gioHoangDao) {

            NSArray *chiGio = [[self class] TinhChiGio:index];
            //NSArray *canGio = [[self class] TinhCanGio:_NgayDuong GioXem:index]; //TinhCanGio(_NgayDuong, index)[0];
            NSString *khoangGio = [[self class] KhoangGio][index/2];
            //NSString *result = [NSString stringWithFormat:@"%@ %@ (%@)", canGio[0], chiGio[0], khoangGio];
            NSString *result = [NSString stringWithFormat:@"%@ (%@)", chiGio[0], khoangGio];
            [_DanhSachGio addObject:result];
        }
    }
    return _DanhSachGio;
}

+ (BOOL)TinhNgayHoangDao:(NSString *)_NgayDuong ThangAm:(NSInteger)_ThangAm {
    NSArray * NgayHoangDao = @[@(1), @(1), @(0), @(0), @(1), @(1), @(0), @(1), @(0), @(0), @(1), @(0)];
    NSInteger Index = [[self class] DateDiff:NgayBatDauChi EndDate:_NgayDuong DiffType:@"Ngay"];
    Index = (12 + Index % 12) % 12; Index = (24 + Index - (_ThangAm - 1) * 2) % 12;
    return [NgayHoangDao[Index] boolValue];
}

+ (BOOL)TinhNgayHoangDao:(NSString *)ngayDuong {
    NSDate *date = [NSDate dateFromString:ngayDuong withFormat:[NSDate dateFormatString]];

    NSArray *NgayThangNamAm = [[self class] convertSolar2Lunar:date.day month:date.month year:date.year timeZone:kTimeZoneVietNam];
    NSInteger ThangAm = [NgayThangNamAm[1] integerValue];

    return [[self class] TinhNgayHoangDao:ngayDuong ThangAm:ThangAm];
}

+ (BOOL)isHoangDao:(NSDate *)date {
    NSArray *NgayThangNamAm = [[self class] convertSolar2Lunar:date.day month:date.month year:date.year timeZone:kTimeZoneVietNam];
    NSInteger ThangAm = [NgayThangNamAm[1] integerValue];
    NSString *ngayDuong = [date stringWithDateFormat:[NSDate dateFormatString]];
    return [[self class] TinhNgayHoangDao:ngayDuong ThangAm:ThangAm];
}

+ (NSArray *) TinhMenhNguHanh:(NSString *)_NgayDuong NamHoacNgay:(NSString *)NamHoacNgay {
    NSArray * MenhNguHanh = @[@"Hải Trung Kim", @"Lư Trung Hỏa", @"Đại Lâm Mộc", @"Lộ Bàng Thổ", @"Kiếm Phong Kim", @"Sơn Đầu Hỏa",
            @"Giản Hạ Thủy", @"Thành Đầu Thổ", @"Bạch Lạp Kim", @"Dương Liễu Mộc", @"Tuyền Trung Thủy", @"Ốc Thượng Thổ", @"Tích Lịch Hỏa",
            @"Tùng Bách Mộc", @"Trường Lưu Thủy", @"Sa Trung Kim", @"Sơn Hạ Hỏa", @"Bình Địa Mộc", @"Bích Thượng Thổ", @"Kim Bạch Kim", @"Phú Đăng Hỏa",
            @"Thiên Hà Thủy", @"Đại Trạch Thổ", @"Thoa Xuyến Kim", @"Tang Đồ Mộc", @"Đại Khê Thủy", @"Sa Trung Thổ", @"Thiên Thượng Hỏa",
            @"Thạch Lựu Mộc ", @"Đại Hải Thủy"];

    NSArray * MenhNguHanh2 = @[@"Vàng trong biển", @"Lửa trong lò", @"Cây rừng lớn", @"Đất ven đường", @"Vàng đầu kiếm", @"Lửa trên núi", @"Nước dưới sông",
            @"Đất trên thành", @"Vàng chân đèn", @"Cây dương liễu", @"Nước trong giếng", @"Đất mái nhà", @"Lửa sấm chớp", @"Cây tùng bách",
            @"Nước giữa dòng", @"Vàng trong cát", @"Lửa chân núi", @"Cây đất bằng", @"Đất trên vách", @"Vàng lá trắng", @"Lửa đèn to",
            @"Nước trên trời", @"Đất đầm lầy", @"Vàng trang sức", @"Gỗ cây dâu", @"Nước giữa khe lớn", @"Đất trong cát", @"Lửa trên trời",
            @"Gỗ Thạch Lựu", @"Nước biển lớn"];

    NSInteger Index = [[self class] DateDiff:NgayBatDauChi EndDate:_NgayDuong DiffType:NamHoacNgay];
    Index = (60 + Index) % 60;
    Index = floor(Index / 2);
    return @[MenhNguHanh[Index], MenhNguHanh2[Index], @(Index)];
}

// dan mao thin ty ngo mui than dau tuat hoi tys suu
//private static final byte[] ngayxau = new byte[] { 5, 14, 23,// Nguyệt kỵ
//    3, 7, 13, 18, 22, 27 // Tam nương
//};// Các ngày trên thì không nên làm những việc quan trọng
// tuy nhiên có thể chọn giờ tốt để thực hiện các việc khác

+ (double)jdAtVST:(NSInteger)d Month:(NSInteger)m Year:(NSInteger)y Hour:(NSInteger)hour Minute:(NSInteger)min {
    NSInteger ret = [[self class] jdFromDate:d month:m year:y];
    return (double)(ret - 0.5 + (hour - 7) / 24.0 + min / 1440.0);
}

+(NSArray *)LayTietKhi:(NSDate *)date {
    NSString *ngayDuong = [date stringWithDateFormat:[NSDate dateFormatString]];
    return [[self class] TinhTietKhi:ngayDuong];
}

+(NSArray *) TinhTietKhi:(NSString *)_NgayDuong {
    NSArray *TietKhi = @[@"Lập xuân", @"Vũ thủy", @"Kinh trập", @"Xuân phân", @"Thanh minh", @"Cốc vũ", @"Lập hạ", @"Tiểu mãn", @"Mang chủng",
            @"Hạ chí", @"Tiểu thử", @"Đại thử", @"Lập thu", @"Xử thử", @"Bạch lộ", @"Thu phân", @"Hàn lộ", @"Sương giáng", @"Lập đông", @"Tiểu tuyết",
            @"Đại tuyết", @"Đông chí", @"Tiểu hàn", @"Đại hàn"];

    NSDate * Date1 = [NSDate dateFromString:_NgayDuong withFormat:[NSDate dateFormatString]];
    NSInteger Ngay = Date1.day;
    NSInteger Thang = Date1.month;
    NSInteger Nam = Date1.year;
    NSInteger Gio =Date1.hour;
    NSInteger Phut = Date1.minute;
    NSInteger Index;

    if (Thang == 2 && Ngay >= 5 && Ngay < 19) { Index = 0; }
    else if ((Thang == 2 && Ngay >= 19) || (Thang == 3 && Ngay < 6)) { Index = 1; }
    else if (Thang == 3 && Ngay >= 7 && Ngay < 21) { Index = 2; }
    else if ((Thang == 3 && Ngay >= 22) || (Thang == 4 && Ngay < 5)) { Index = 3; }
    else if (Thang == 4 && Ngay >= 6 && Ngay < 20) { Index = 4; }
    else if ((Thang == 4 && Ngay >= 21) || (Thang == 5 && Ngay < 6)) { Index = 5; }
    else if (Thang == 5 && Ngay >= 7 && Ngay < 21) { Index = 6; }
    else if ((Thang == 5 && Ngay >= 22) || (Thang == 6 && Ngay < 5)) { Index = 7; }
    else if (Thang == 6 && Ngay >= 7 && Ngay < 21) { Index = 8; }
    else if ((Thang == 6 && Ngay >= 22) || (Thang == 7 && Ngay < 7)) { Index = 9; }
    else if (Thang == 7 && Ngay >= 8 && Ngay < 23) { Index = 10; }
    else if ((Thang == 7 && Ngay >= 24) || (Thang == 8 && Ngay < 8)) { Index = 11; }
    else if (Thang == 8 && Ngay >= 9 && Ngay < 23) { Index = 12; }
    else if ((Thang == 8 && Ngay >= 24) || (Thang == 9 && Ngay < 8)) { Index = 13; }
    else if (Thang == 9 && Ngay >= 9 && Ngay < 23) { Index = 14; }
    else if ((Thang == 9 && Ngay >= 24) || (Thang == 10 && Ngay < 8)) { Index = 15; }
    else if (Thang == 10 && Ngay >= 9 && Ngay < 23) { Index = 16; }
    else if ((Thang == 10 && Ngay >= 24) || (Thang == 11 && Ngay < 8)) { Index = 17; }
    else if (Thang == 11 && Ngay >= 9 && Ngay < 22) { Index = 18; }
    else if ((Thang == 11 && Ngay >= 23) || (Thang == 12 && Ngay < 7)) { Index = 19; }
    else if (Thang == 12 && Ngay >= 8 && Ngay < 22) { Index = 20; }
    else if ((Thang == 12 && Ngay >= 23) || (Thang == 1 && Ngay < 6)) { Index = 21; }
    else if (Thang == 1 && Ngay >= 7 && Ngay < 20) { Index = 22; }
    else if ((Thang == 1 && Ngay >= 21) || (Thang == 2 && Ngay < 4)) { Index = 23; }
    else {

        Index = [[self class] getTietKhiInt:Ngay Month:Thang Year:Nam Hour:Gio Minute:Phut] - 1;
    }
    return @[TietKhi[Index], @(Index)];

}

+ (NSString *)getTietKhi:(NSInteger)d Month:(NSInteger)m Year:(NSInteger)y Hour:(NSInteger)hour Minute:(NSInteger)min {
    double jd = [[self class] jdAtVST:d Month:m Year:y Hour:hour Minute:min];
    double s1 = [[self class] SunLongitude:jd];
    //int s2 = (int) s1;
    // Log.d("fd00", "" + s1 + " " + s2);

    switch ((int)s1) {
        case 0:
            return @"Xuân phân";
            break;

        case 15:
            return @"Thanh minh";
            break;

        case 30:
            return @"Cốc vũ";
            break;

        case 45:
            return @"Lập hạ";
            break;

        case 60:
            return @"Tiểu mãn";
            break;

        case 75:
            return @"Mang chủng";
            break;

        case 90:
            return @"Hạ chí";
            break;

        case 105:
            return @"Tiểu thử";
            break;

        case 120:
            return @"Đại thử";
            break;

        case 135:
            return @"Lập thu";
            break;

        case 150:
            return @"Xử thử";
            break;

        case 165:
            return @"Bạch lộ";
            break;

        case 180:
            return @"Thu phân";
            break;

        case 195:
            return @"Hàn lộ";
            break;

        case 210:
            return @"Sương giáng";
            break;

        case 225:
            return @"Lập đông";
            break;

        case 240:
            return @"Tiểu tuyết";
            break;

        case 255:
            return @"Đại tuyết";
            break;

        case 270:
            return @"Đông chí";
            break;

        case 285:
            return @"Tiểu hàn";
            break;

        case 300:
            return @"Đại hàn";
            break;

        case 315:
            return @"Lập xuân";
            break;

        case 330:
            return @"Vũ thuỷ";
            break;

        case 345:
            return @"Kinh trập";
            break;

        default:
            break;
    }

    if (s1 > 0.0 && s1 < 15.0) {
        return @"Giữa Xuân phân - Thanh minh";
    } else if (s1 > 15.0 && s1 < 30.0) {
        return @"Giữa Thanh minh - Cốc vũ";
    } else if (s1 > 30.0 && s1 < 45.0) {
        return @"Giữa Cốc vũ - Lập hạ";
    } else if (s1 > 45.0 && s1 < 60.0) {
        return @"Giữa Lập hạ - Tiểu mãn";
    } else if (s1 > 60.0 && s1 < 75.0) {
        return @"Giữa Tiểu mãn - Mang chủng";
    } else if (s1 > 75.0 && s1 < 90.0) {
        return @"Giữa Mang chủng- Hạ chí";
    } else if (s1 > 90.0 && s1 < 105.0) {
        return @"Giữa Hạ chí - Tiểu thử";
    } else if (s1 > 105.0 && s1 < 120.0) {
        return @"Giữa Tiểu thử - Đại thử";
    } else if (s1 > 120.0 && s1 < 135.0) {
        return @"Giữa Đại thử - Lập thu";
    } else if (s1 > 135.0 && s1 < 150.0) {
        return @"Giữa Lập thu - Xử thử";
    } else if (s1 > 150.0 && s1 < 165.0) {
        return @"Giữa Xử thử - Bạch lộ";
    } else if (s1 > 165.0 && s1 < 180.0) {
        return @"Giữa Bạch lộ - Thu phân";
    } else if (s1 > 180.0 && s1 < 195.0) {
        return @"Giữa Thu phân - Hàn lộ";
    } else if (s1 > 195.0 && s1 < 210.0) {
        return @"Gữa Hàn lộ - Sương giáng";
    } else if (s1 > 210.0 && s1 < 225.0) {
        return @"Giữa Sương giáng - Lập đông";
    } else if (s1 > 225.0 && s1 < 240.0) {
        return @"Giữa Lập đông - Tiểu tuyết";
    } else if (s1 > 240.0 && s1 < 255.0) {
        return @"Giữa Tiểu tuyết - Đại tuyết";
    } else if (s1 > 255.0 && s1 < 270.0) {
        return @"Giữa Đại tuyết - Đông chí";
    } else if (s1 > 270.0 && s1 < 285.0) {
        return @"Giữa Đông chí - Tiểu hàn";
    } else if (s1 > 285.0 && s1 < 300.0) {
        return @"Giữa Tiểu hàn - Đại hàn";
    } else if (s1 > 300.0 && s1 < 315.0) {
        return @"Giữa Đại hàn - Lập xuân";
    } else if (s1 > 315.0 && s1 < 330.0) {
        return @"Giữa Lập xuân - Vũ thuỷ";
    } else if (s1 > 330.0 && s1 < 345.0) {
        return @"Giữa Vũ thủy - Kinh trập";
    } else if (s1 > 345.0 && s1 < 360.0) {
        return @"Giữa Kinh trập - Xuân phân";
    }
    return nil;
}

+ (NSInteger)getTietKhiInt:(NSInteger)d Month:(NSInteger)m Year:(NSInteger)y Hour:(NSInteger)hour Minute:(NSInteger)min {
    double jd = [[self class] jdAtVST:d Month:m Year:y Hour:hour Minute:min];// jdAtVST(d, m, y, hour, min);
    double s1 = [[self class] SunLongitude:jd];// SunLongitude(jd);
    if (s1 >= 0.0 && s1 < 15.0) {
        return 1;// return "Xuân phân";
    } else if (s1 >= 15.0 && s1 < 30.0) {
        return 2;// return "Thanh minh";---
    } else if (s1 >= 30.0 && s1 < 45.0) {
        return 3;// return "Cốc Vũ";
    } else if (s1 >= 45.0 && s1 < 60.0) {
        return 4;// return "Lập Hạ";
    } else if (s1 >= 60.0 && s1 < 75.0) {
        return 5;// return "Tiểu mãn";
    } else if (s1 >= 75.0 && s1 < 90.0) {
        return 6;// return "Mang chủng";
    } else if (s1 >= 90.0 && s1 < 105.0) {
        return 7;// return "Hạ Chí";
    } else if (s1 >= 105.0 && s1 < 120.0) {
        return 8;// return "Tiểu Thử";
    } else if (s1 >= 120.0 && s1 < 135.0) {
        return 9;// return "Đại Thử";
    } else if (s1 >= 135.0 && s1 < 150.0) {
        return 10;// return "Lập Thu";
    } else if (s1 >= 150.0 && s1 < 165.0) {
        return 11;// return "Xử Thử";
    } else if (s1 >= 165.0 && s1 < 180.0) {
        return 12;// return "Bạch Lộ";---
    } else if (s1 >= 180.0 && s1 < 195.0) {
        return 13;// return "Thu phân";
    } else if (s1 >= 195.0 && s1 < 210.0) {
        return 14;// return "Hàn Lộ";
    } else if (s1 >= 210.0 && s1 < 225.0) {
        return 15;// return "Sương Giáng";
    } else if (s1 >= 225.0 && s1 < 240.0) {
        return 16;// return "Lập Đông";
    } else if (s1 >= 240.0 && s1 < 255.0) {
        return 17;// return "Tiểu Tuyết";
    } else if (s1 >= 255.0 && s1 < 270.0) {
        return 18;// return "Đại Tuyết";
    } else if (s1 >= 270.0 && s1 < 285.0) {
        return 19;// return "Đông Chí";
    } else if (s1 >= 285.0 && s1 < 300.0) {
        return 20;// return "Tiểu Hàn";
    } else if (s1 >= 300.0 && s1 < 315.0) {
        return 21;// return "Đại Hàn";
    } else if (s1 >= 315.0 && s1 < 330.0) {
        return 22;// return "Lập Xuân";
    } else if (s1 >= 330.0 && s1 < 345.0) {
        return 23;// return "Vũ Thủy";
    } else if (s1 >= 345.0 && s1 < 360.0) {
        return 24;// return "Kinh Trập";
    }
    return 1;
}

+ (NSArray*)TinhTrucWithDate:(NSDate*)date {
    NSString *_NgayDuong = [date stringWithDateFormat:[NSDate dateFormatString]];
    return [NLLunarCalendarHelper TinhTruc:_NgayDuong];
}

+(NSArray *) TinhTruc:(NSString *)_NgayDuong {
    NSArray * Truc = @[@"Kiến (tốt)", @"Trừ (thường)", @"Mãn (tốt)", @"Bình (tốt)", @"Định (tốt)", @"Chấp (thường)", @"Phá (xấu)", @"Nguy (xấu)",
            @"Thành (tốt)", @"Thu (thường)", @"Khai (tốt)", @"Bế (xấu)"];

    NSArray * TietKhiNgay = [[self class] TinhTietKhi:_NgayDuong];
    NSInteger IndexTietKhi = [TietKhiNgay[1] integerValue];
    NSArray * _ChiNgay = [[self class] TinhChiNgay:_NgayDuong];
    NSInteger IndexChi = [_ChiNgay[1] integerValue];
    IndexTietKhi = floor(IndexTietKhi / 2);
    NSInteger Index = (12 + IndexChi - IndexTietKhi - 2) % 12;
    return @[Truc[Index], @(Index)];
}

+(int)getDayCountOfaMonth:(NSInteger)month Year:(NSInteger)year {
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            return 31;

        case 2:
            if(year%4==0 && year%100!=0)
                return 29;
            else
                return 28;
        case 4:
        case 6:
        case 9:
        case 11:
            return 30;
        default:
            return 31;
    }
}

+(NSString *)GetDayOfWeekWithDate:(NSDate *)date {
    return [[self class] GetDayOfWeek:date.day thang:date.month nam:date.year];
}

+(NSString *) GetDayOfWeek:(NSInteger)ngay thang:(NSInteger)thang nam:(NSInteger)nam {
    NSArray * TUAN = @[@"Chủ Nhật", @"Thứ Hai", @"Thứ Ba", @"Thứ Tư", @"Thứ Năm", @"Thứ Sáu", @"Thứ Bảy"];

    NSInteger jd = [[self class] jdFromDate:ngay month:thang year:nam];
    return [TUAN[(jd + 1) % 7] uppercaseString];
}

+(NSString*) GetThangAm:(NSInteger )Number {
    NSArray * THANG = @[@"Gi\u00EAng", @"Hai", @"Ba", @"T\u01B0", @"N\u0103m", @"S\u00E1u", @"B\u1EA3y", @"T\u00E1m", @"Ch\u00EDn", @"M\u01B0\u1EDDi", @"Mười Một", @"Ch\u1EA1p"];
    Number = Number - 1;
    return [NSString stringWithFormat:@"THÁNG %@", THANG[Number]];
}

+ (NSString *)HyThan:(NSInteger)dd Mounth:(NSInteger)mm Year:(NSInteger)yy {
    int t = ([[self class] jdFromDate:dd month:mm year:yy] + 9) % 10;// jdFromDate(dd, mm, yy) + 9) % 10;
    switch (t) {
        case 0:
        case 5:
            return @"Hỷ Thần: Đông Bắc";
        case 1:
        case 6:
            return @"Hỷ Thần: Tây Bắc";
        case 2:
        case 7:
            return @"Hỷ Thần: Tây Nam";
        case 3:
        case 8:
            return @"Hỷ Thần: Chính Nam";
        case 4:
        case 9:
            return @"Hỷ Thần: Đông Nam";
    }
    return nil;
}

+ (NSString *)TaiThan:(NSInteger)dd Month:(NSInteger)mm Year:(NSInteger)yy {
    int t = ([[self class] jdFromDate:dd month:mm year:yy] + 9) % 10;// (jdFromDate(dd, mm, yy) + 9) % 10;
    switch (t) {
        case 0:
        case 1:
            return @"Tài Thần: Đông Nam";
        case 2:
        case 3:
            return @"Tài Thần: Đông";
        case 4:
            return @"Tài Thần: Bắc";
        case 5:
            return @"Tài Thần: Nam";
        case 6:
        case 7:
            return @"Tài Thần: Tây Nam";
        case 8:
            return @"Tài Thần: Tây";
        case 9:
            return @"Tài Thần: Tây Bắc";
    }
    return nil;
}

+ (BOOL)isTetDL:(NSDate *)ddate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth) fromDate:ddate];

    NSInteger day = [weekdayComponents day];
    NSInteger month = [weekdayComponents month];

    if (day == 1 && month == 1) {
        return YES;
    }

    return NO;
}

+ (BOOL)isTetAL:(NSDate *)ddate
{
    NSArray *ngayAL = [[self class] convertSolar2Lunar:ddate.day month:ddate.month year:ddate.year timeZone:kTimeZoneVietNam];
    if ([[ngayAL objectAtIndex:0] integerValue] >= 1 && [[ngayAL objectAtIndex:0] integerValue] <= 3 && [[ngayAL objectAtIndex:1] integerValue] == 1) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isTrungThu:(NSDate *)ddate
{
    NSArray *ngayAL = [[self class] convertSolar2Lunar:ddate.day month:ddate.month year:ddate.year timeZone:kTimeZoneVietNam];

    if ([[ngayAL objectAtIndex:0] integerValue] == 15 && [[ngayAL objectAtIndex:1] integerValue] == 8) {
        return YES;
    }

    return NO;
}

// Lấy thông tin ngày âm (lunar day)
+ (NSDictionary*)getLunarInfoWithSolarDate:(NSDate*)date {
    NSString *namCanChi = [NLLunarCalendarHelper NamCanChiWithDate:date];
    NSString *thangCanChi = [NLLunarCalendarHelper ThangCanChiWithDate:date];
    NSString *ngayCanChi = [NLLunarCalendarHelper NgayCanChiWithDate:date];
    NSString *gioCanChi = [NLLunarCalendarHelper GioCanChiWithDate:date];
    
    //NSArray *listGioHoangDao = [NLLunarCalendarHelper LayGioHoangDaoWithDate:date];
    NSArray *listGioHoangDao = [NLLunarCalendarHelper LayGioHoangDaoWithDate:date];
    NSString *strGioHoangDao = [[listGioHoangDao valueForKey:@"description"] componentsJoinedByString:@", "];
    
    NSArray *listGioHoangDao2 = [NLLunarCalendarHelper LayGioHoangDaoWithDate2:date];
    NSString *strGioHoangDao2 = [[listGioHoangDao2 valueForKey:@"description"] componentsJoinedByString:@", "];

    
    NSArray *toAm = [NLLunarCalendarHelper convertSolar2Lunar:date.day month:date.month year:date.year timeZone:7.0];
    NSInteger thangAm = [toAm[1] integerValue];
    NSInteger ngayAm = [toAm[0] integerValue];
    NSInteger namAm = [toAm[2] integerValue];
    NSArray *tinhTruc = [NLLunarCalendarHelper TinhTrucWithDate:date];
    //NSArray *tinhTruc = [NLLunarCalendarHelper NgayTruc:date.day Month:date.month Year:date.year];
    
    BOOL isTrungThu = [NLLunarCalendarHelper isTrungThu:date];
    BOOL isTetAL = ((ngayAm >= 1) && (ngayAm <= 3) && (thangAm == 1));
    BOOL isNgayHoangDao = [NLLunarCalendarHelper isHoangDao:date];
    
    NSArray *chiNgay = [NLLunarCalendarHelper TinhChiNgay:[date stringWithDateFormat:[NSDate dateFormatString]]];
    NSString *anhConGiapTheoNgay = [self GetAnhConGiapTheoNgay:chiNgay[0]];
    
    NSArray *menhNgay = [NLLunarCalendarHelper TinhMenhNguHanh:[date stringWithDateFormat:[NSDate dateFormatString]] NamHoacNgay:@"Ngay"];
    NSString *strMenhNgay = [NSString stringWithFormat:@"%@\n(%@)", menhNgay[0], menhNgay[1]];
    NSString *tietKhi = [NLLunarCalendarHelper LayTietKhi:date][0];
    NSString *tietKhi2 = [NLLunarCalendarHelper getTietKhi:date.day Month:date.month Year:date.year Hour:date.hour Minute:date.minute];
    NSString *strThangAm = [[NLLunarCalendarHelper GetThangAm:thangAm] uppercaseString];
    return @{@"NamCanChi" : namCanChi,
             @"ThangCanChi" : thangCanChi,
             @"NgayCanChi" : ngayCanChi,
             @"GioCanChi" : gioCanChi,
             @"GioHoangDao" : strGioHoangDao,
             @"GioHoangDao2" : strGioHoangDao2,
             @"ThangAm" : @(thangAm),
             @"NamAm" : @(namAm),
             @"NgayAm" : @(ngayAm),
             @"TetAmLich" : @(isTetAL),
             @"TetTrungThu" : @(isTrungThu),
             @"NgayHoangDao" : @(isNgayHoangDao),
             @"MenhNgay" : strMenhNgay,
             @"TietKhi" : tietKhi,
             @"TietKhiFull" : tietKhi2,
             @"AnhConGiapTheoNgay" : anhConGiapTheoNgay,
             @"ThangAmBangChu" : strThangAm,
             //@"TinhTruc" : [[tinhTruc valueForKey:@"description"] componentsJoinedByString:@"<br/>"]
             @"TinhTruc" : tinhTruc[0]
             };
}

+ (NSString*)GetAnhConGiapTheoNgay:(NSString*)_ChiNgay {
    if ([_ChiNgay is:@"Tí"]) {_ChiNgay = @"Ty";}
    else if ([_ChiNgay is: @"Sửu"]) _ChiNgay = @"Suu";
    else if ([_ChiNgay is: @"Dần"]) _ChiNgay = @"Dan";
    else if ([_ChiNgay is: @"Mão"]) _ChiNgay = @"Mao";
    else if ([_ChiNgay is: @"Thìn"]) _ChiNgay = @"Thin";
    else if ([_ChiNgay is: @"Tỵ"]) _ChiNgay = @"Ti";
    else if ([_ChiNgay is: @"Tý"]) _ChiNgay = @"Ty";
    else if ([_ChiNgay is: @"Ngọ"]) _ChiNgay = @"Ngo";
    else if ([_ChiNgay is: @"Mùi"]) _ChiNgay = @"Mui";
    else if ([_ChiNgay is: @"Thân"]) _ChiNgay = @"Than";
    else if ([_ChiNgay is: @"Dậu"]) _ChiNgay = @"Dau";
    else if ([_ChiNgay is: @"Hợi"]) _ChiNgay = @"Hoi";
    else _ChiNgay = @"Tuat";
    NSString *imageURL = [NSString stringWithFormat:@"%@.png", _ChiNgay];
    return imageURL;
}

+ (NSArray *)NgayTruc:(NSInteger)dd Month:(NSInteger)mm Year:(NSInteger)yy {
    NSInteger truckien = [NLLunarCalendarHelper TrucKien:mm];// TrucKien(mm);
    int jd = ([NLLunarCalendarHelper jdFromDate:dd month:mm year:yy] + 11) % 12;
    if (truckien == jd)
        return [NSArray arrayWithObjects:@"Đây là ngày Trực Kiến là ngày tốt tuy nhiên nên tránh động thổ.",
                @"Tốt nhất nên làm những việc nhỏ như khởi công xây dựng. Kiến tạo và đào móng. Tốt với xuất hành hay giá thú.",
                nil];
    
    int i = 0;
    if (truckien != 0)
        i = 1;
    
    while (true) {
        if (truckien == 11) {
            truckien = 0;
            continue;
        }
        if (truckien == jd)
            break;
        truckien++;
        i++;
        
        if (truckien == jd)
            break;
    }
    
    switch (i) {
        case 1:
            return [NSArray arrayWithObjects:@"Đây là ngày Trực Trừ là ngày bình thường nên tránh cầu tài. Xuất vốn. Cho vay nợ",
                    @"Nên chữa bệnh. Hốt thuốc hoặc bắt kẻ gian.",
                    nil];
        case 2:
            return [NSArray arrayWithObjects:@"Đây là ngày Trực Mãn là ngày tốt.",
                    @"Nên cầu tài. Cầu phúc hoặc tế tự. Tốt cho việc nhập học. Bài sư hoặc ra nghề.",
                    nil];
        case 3:
            return [NSArray arrayWithObjects:@"Đây là ngày Trực Bình là ngày tốt.",
                    @"Nên giải hòa. bãi nại. Cầu minh oan hoặc ráp máy.",
                    nil];
        case 4:
            return [NSArray arrayWithObjects:@"Đây là ngày Trực Định là ngày tốt tuy nhiên tránh kiện tụng. Tranh chấp và chữa bệnh",
                    @"Tốt về cầu tài. Ký hợp đồng. Yến tiệc. Hội họp bạn bè. Dọn dẹp nhà cửa. Đi mua sắm quần áo - may mặc.",
                    nil];
        case 5:
            return [NSArray arrayWithObjects:@"Đây là ngày Trực Chấp là ngày bình thường tuy vậy kiêng xuất hành. Di chuyển. Khai trương. Dọn nhà cũ qua nhà mới.",
                    @"Nên khởi công - xây dựng. Nhận nhân công. Nhập kho hay đặt máy móc. Mở tiệc party.",
                    nil];
        case 6:
            return [NSArray arrayWithObjects:@"Đây là ngày Trực Phá là ngày xấu.",
                    @"Nên sửa chữa nhà hay dọn dẹp nhà cửa. Đi khám chữa bệnh.",
                    nil];
        case 7:
            return [NSArray arrayWithObjects:@"Đây là ngày Trực Nguy là ngày xấu.",
                    @"Tuy là ngày xấu nhưng nên chọn những công việc mang tính chất mạo hiểm hay khó khăn thì công việc sẽ tốt hơn.",
                    nil];
        case 8:
            return [NSArray arrayWithObjects:@"Đây là ngày Trực Thành là ngày tốt tuy nhiên nên tránh kiện tụng. Tranh chấp.",
                    @"Tốt cho xuất hành. Khai trương. Khuyếch trương. Giao dịch. Mưu sự. Tiếp thị quảng cáo hàng hóa. Giá thú.",
                    nil];
        case 9:
            return [NSArray arrayWithObjects:@"Đây là ngày Trực Thu là ngày bình thường nhưng kỵ khởi công. Xuất hành. An táng.",
                    @"Nên Thu tiền - đòi nợ. Nhận việc. Nhận nhân công hay Nhập kho.",
                    nil];
        case 10:
            return [NSArray arrayWithObjects:@"Đây là ngày Trực Khai là ngày tốt nhưng tránh động thổ hay an táng.",
                    @"Nên Khánh thành. Khai mạc. An vị Phật. Yến kiến.",
                    nil];
        case 11:
            return [NSArray arrayWithObjects:@"Đây là ngày Trực Bế là ngày xấu nên kiêng mọi việc.",
                    @"Nên Hành sự pháp luật. Bắt kẻ gian và trộm cắp.",
                    nil];
    }
    return [NSArray arrayWithObjects:@"", @"", nil];
}

+ (NSInteger)TrucKien:(NSInteger)mm {
    if (mm == 2)
        return 0;// dần
    if (mm == 3)
        return 1;// mão
    if (mm == 4)
        return 2;// thìn
    if (mm == 5)
        return 3;// tỵ
    if (mm == 6)
        return 4;// ngọ
    if (mm == 7)
        return 5;// mùi
    if (mm == 8)
        return 6;// thân
    if (mm == 9)
        return 7;// dậu
    if (mm == 10)
        return 8;// tuất
    if (mm == 11)
        return 9;// hợi
    if (mm == 12)
        return 10;// tý
    if (mm == 1)
        return 11;// sửu
    return -1;
}

+ (NSInteger)isLunarLeapYear:(int)lunarYear {
    NSInteger temp = [NLLunarCalendarHelper getLunarMonth11:lunarYear TimeZone:kTimeZoneVietNam];// MyDateHelper.getLunarMonth11(year, TZ);
    NSInteger tempM1 = [NLLunarCalendarHelper getLunarMonth11:lunarYear-1 TimeZone:kTimeZoneVietNam];// MyDateHelper.getLunarMonth11(year - 1, TZ);
    NSInteger z = tempM1 - temp;
    
    if (labs(z) > 355) {
        NSInteger o = [NLLunarCalendarHelper getLeapMonthOffset:tempM1 TimeZone:kTimeZoneVietNam];// MyDateHelper.getLeapMonthOffset(tempM1, TZ);
        if (o >= 3) {
            return o - 2;
        }
    }
    
    z = temp - [NLLunarCalendarHelper getLunarMonth11:lunarYear+1 TimeZone:kTimeZoneVietNam];// MyDateHelper.getLunarMonth11(year + 1, TZ);
    
    if (labs(z) > 355) {
        NSInteger o = [NLLunarCalendarHelper getLeapMonthOffset:temp TimeZone:kTimeZoneVietNam];//tMyDateHelper.getLeapMonthOffset(temp, TZ);
        if (o < 3) {
            return 10 + o;
        }
    }
    
    return 0;NSIntegerMin;// INVALID_RESULT;
}

@end
