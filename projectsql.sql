#öncesinde eğer bir csv dosyasından veri çekmek istiyorsanız database oluşturmanız gerek sol üstün simgelerden 4 seçenek database oluşturma seçeneği çıkarır isim verirsin ve database oluturursun.
#Sonrasında Şemaları yenilediğinizde database kaşınıza çıkar üstüne sağ tıklayıp table data import wizard seçeneğine tıkladıktan sonra açılan sayfada csv uzantılı dosyanızı seçersiniz.
#ardından hiç bir tip ayarına dokunman verinizi düzgün şekilde databasenize aktarırsınız
select * from hotel_bookings;

# bu adım çok önemlidir eğer bir tabloda işlem silme güncelleme işlemi yapacaksanız yeni bir tablo açıp eski tablodaki verileri çekmelisiniz aşağıda sadece yeni bir tablo açıp eski tabloya göre veri başlıkları çeker
create table hotel_bookings_clean
like hotel_bookings;

#aşağıda yeni tablomuza eski tablodaki verileri çekeriz
select * from hotel_bookings_clean;
insert hotel_bookings_clean
select * from hotel_bookings;

# yeni oluşturduğumuz tabloyu listeleriz
select * from hotel_bookings_clean;

#aşağıda satırları distinct ile kontrol ederek hataları en kolay şekilde görmeye çalıştım
select DISTINCT hotel from hotel_bookings_clean;

select DISTINCT arrival_date_week_number from hotel_bookings_clean order by 1;

select DISTINCT hotel from hotel_bookings_clean;

select DISTINCT arrival_date_week_number , arrival_date_month from hotel_bookings_clean order by 1;

select DISTINCT country, trim(country) from hotel_bookings_clean order by 1;

select DISTINCT agent , company from hotel_bookings_clean order by 1;

select DISTINCT reservation_status_date ,  reservation_status from hotel_bookings_clean order by 1;

select DISTINCT market_segment , distribution_channel, country from hotel_bookings_clean order by 1;

select DISTINCT deposit_type from hotel_bookings_clean order by 1;

select DISTINCT reserved_room_type , assigned_room_type from hotel_bookings_clean order by 1;

select DISTINCT arrival_date_year , reservation_status_date from hotel_bookings_clean order by 1;

select trim(country), country from hotel_bookings_clean1;

# update komutu ile arrival_date_week_number da bulunan 53 haftayı yalnış yazıldığını düşündüğümden 53 haftayı 1 hafta olarak değiştirdim
update hotel_bookings_clean
set arrival_date_week_number = '1'
where arrival_date_week_number LIKE '53';

# update ile diğer hatalı haftaları düzelttim
update hotel_bookings_clean
set arrival_date_month = 'January'
where arrival_date_week_number = '1' and arrival_date_month LIKE 'December';

update hotel_bookings_clean
set arrival_date_month = 'December'
where arrival_date_week_number = '49' and arrival_date_month LIKE 'November';

update hotel_bookings_clean
set arrival_date_month = 'November'
where arrival_date_week_number = '45' and arrival_date_month LIKE 'October';

update hotel_bookings_clean
set arrival_date_month = 'September'
where arrival_date_week_number = '40' and arrival_date_month LIKE 'October';

update hotel_bookings_clean
set arrival_date_month = 'August'
where arrival_date_week_number = '36' and arrival_date_month LIKE 'September';

update hotel_bookings_clean
set arrival_date_month = 'July'
where arrival_date_week_number = '31' and arrival_date_month LIKE 'August';

update hotel_bookings_clean
set arrival_date_month = 'July'
where arrival_date_week_number = '30' and arrival_date_month LIKE 'August';

update hotel_bookings_clean
set arrival_date_month = 'August'
where arrival_date_week_number = '32' and arrival_date_month LIKE 'July';

update hotel_bookings_clean
set arrival_date_month = 'July'
where arrival_date_week_number = '27' and arrival_date_month LIKE 'June';

update hotel_bookings_clean
set arrival_date_month = 'June'
where arrival_date_week_number = '26' and arrival_date_month LIKE 'July';

update hotel_bookings_clean
set arrival_date_month = 'June'
where arrival_date_week_number = '23' and arrival_date_month LIKE 'May';

update hotel_bookings_clean
set arrival_date_month = 'May'
where arrival_date_week_number = '22' and arrival_date_month LIKE 'June';

update hotel_bookings_clean
set arrival_date_month = 'April'
where arrival_date_week_number = '14' and arrival_date_month LIKE 'March';

update hotel_bookings_clean
set arrival_date_month = 'March'
where arrival_date_week_number = '13' and arrival_date_month LIKE 'April';

update hotel_bookings_clean
set arrival_date_month = 'March'
where arrival_date_week_number = '10' and arrival_date_month LIKE 'February';

update hotel_bookings_clean
set arrival_date_month = 'February'
where arrival_date_week_number = '6' and arrival_date_month LIKE 'January';

update hotel_bookings_clean
set arrival_date_month = 'January'
where arrival_date_week_number = '5' and arrival_date_month LIKE 'February';

select * from hotel_bookings_clean;

#aşağıda where komutu ile hem agent kısmı null hem de company kısmı birlikte null ise sildim
delete from hotel_bookings_clean
where agent IS NULL
AND company IS NULL;

select * from hotel_bookings_clean;

#Aşağıda countrysi null değer olanları sildim
delete from hotel_bookings_clean
where country IS NULL;

#Aşağıda tarihleri metin tipinden gün tipine çevirdim
alter table hotel_bookings_clean
MODIFY column `reservation_status_date` DATE;

select * from hotel_bookings_clean;

#Aşağıda eğer aynı veriden başka varsa row_num versin eğer 1 den başka row_num sayısı varsa o tekrar eden veridir
select *,
row_number() over( 
partition by hotel , is_canceled,arrival_date_day_of_month,arrival_date_month,arrival_date_week_number,adults,children ,babies,meal,reserved_room_type,reservation_status,arrival_date_year,stays_in_week_nights,stays_in_weekend_nights, lead_time,country,market_segment,distribution_channel, reservation_status_date) as row_num
 from hotel_bookings_clean ;
 
 WITH dublicate_cte2 as (
 
 select *,
row_number() over( 
partition by hotel , is_canceled,arrival_date_day_of_month,arrival_date_month,arrival_date_week_number,adults,children ,babies,meal,reserved_room_type,reservation_status,arrival_date_year,stays_in_week_nights,stays_in_weekend_nights, lead_time,country,market_segment,distribution_channel, is_repeated_guest,previous_cancellations,previous_bookings_not_canceled,assigned_room_type,booking_changes,deposit_type,agent,customer_type,adr,required_car_parking_spaces,total_of_special_requests ,reservation_status_date) as row_num
 from hotel_bookings_clean 

 
 )
 
 select * from dublicate_cte2
 where row_num > 1;
 #yeni bir tablo oluşturdum ve fazladan bir satır ekledim row_num
 CREATE TABLE `hotel_bookings_clean1` (
  `hotel` text,
  `is_canceled` int DEFAULT NULL,
  `lead_time` int DEFAULT NULL,
  `arrival_date_year` int DEFAULT NULL,
  `arrival_date_month` text,
  `arrival_date_week_number` int DEFAULT NULL,
  `arrival_date_day_of_month` int DEFAULT NULL,
  `stays_in_weekend_nights` int DEFAULT NULL,
  `stays_in_week_nights` int DEFAULT NULL,
  `adults` int DEFAULT NULL,
  `children` int DEFAULT NULL,
  `babies` int DEFAULT NULL,
  `meal` text,
  `country` text,
  `market_segment` text,
  `distribution_channel` text,
  `is_repeated_guest` int DEFAULT NULL,
  `previous_cancellations` int DEFAULT NULL,
  `previous_bookings_not_canceled` int DEFAULT NULL,
  `reserved_room_type` text,
  `assigned_room_type` text,
  `booking_changes` int DEFAULT NULL,
  `deposit_type` text,
  `agent` text,
  `company` text,
  `days_in_waiting_list` int DEFAULT NULL,
  `customer_type` text,
  `adr` int DEFAULT NULL,
  `required_car_parking_spaces` int DEFAULT NULL,
  `total_of_special_requests` int DEFAULT NULL,
  `reservation_status` text,
  `reservation_status_date` text,
  `row_num` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select  * from hotel_bookings_clean1;

#oluşturduğum yeni tabloya tüm verileri ekledim ayrıca row_num larını da ekledim
insert into hotel_bookings_clean1
 select *,
row_number() over( 
partition by hotel , is_canceled,arrival_date_day_of_month,arrival_date_month,arrival_date_week_number,adults,children ,babies,meal,reserved_room_type,reservation_status,arrival_date_year,stays_in_week_nights,stays_in_weekend_nights, lead_time,country,market_segment,distribution_channel, is_repeated_guest,previous_cancellations,previous_bookings_not_canceled,assigned_room_type,booking_changes,deposit_type,agent,customer_type,adr,required_car_parking_spaces,total_of_special_requests ,reservation_status_date) as row_num
 from hotel_bookings_clean  ;
 select  * from hotel_bookings_clean1;
 

#aşağıda row_num 1 den büyük olanları sildim çünkü tekrar eden verilerdi
delete from hotel_bookings_clean1 where row_num > 1;



#Aşağıda country trim ile düzeltilmiş haliyle değiştirdim
update hotel_bookings_clean1
set country = trim(country) ;

#Aşağıda hotel trim ile düzeltilmiş haliyle değiştirdim
update hotel_bookings_clean1
set hotel = trim(hotel) ;

#aşağıda tarihi ay gün yıl olarak düzelttim
select reservation_status_date,
str_to_date(reservation_status_date, '%m/%d/%Y')
 from hotel_bookings_clean1;
 
 select * from hotel_bookings_clean1;
