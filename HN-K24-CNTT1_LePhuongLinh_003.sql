create database final;
use final;

-- PHẦN 1
-- bảng khách 
create table Guests(
	guest_id int auto_increment primary key,
     full_name varchar(255) not null,
     email varchar(255) not null unique,
     phone varchar(20),
     points decimal(10,2) default 0 check(points >= 0)
);
 
-- hồ sơ chi tiết khách
create table Guest_Profiles (
    profile_id int auto_increment primary key,
    guest_id int not null,
    address varchar(255),
    birthday date,
    national_id varchar(20) not null unique,
    
    foreign key (guest_id) references guests(guest_id)
);

-- phòng
create table Rooms (
    room_id int auto_increment primary key,
    room_name varchar(50) not null,
    room_type enum('Standard','Deluxe','Suite') not null,
    price_per_night decimal(12,2) check(price_per_night > 0),
    room_status enum('Available','Occupied','Maintenance') not null
);

-- giao dịch đặt phòng
create table Bookings (
    booking_id int auto_increment primary key,
    guest_id int not null,
    room_id int not null,
    check_in_date datetime,
    check_out_date datetime,
    total_charge decimal(15,2) check (total_charge > 0),
    booking_status enum('Pending','Completed','Cancelled') not null,
    created_at datetime default now(),
    
    foreign key (guest_id) references guests(guest_id),
    foreign key (room_id) references rooms(room_id)
);


-- nhật kí biến động phòng
create table Room_log (
    log_id int auto_increment primary key,
    room_id int not null,
    action_type enum('Check-in','Check-out','Maintenance','Cancelled'),
    change_note varchar(255),
    logged_at datetime default now(),
    
    foreign key (room_id) references rooms(room_id)
);


insert into Guests(guest_id, full_name, email, phone, points) values
	(1,	'Nguyen Van A',	'anv@gmail.com', '901234567', 150),
	(2,	'Tran Thi B', 'btt@gmail.com',	'912345678', 500),
	(3,	'Le Van C', 'cle@yahoo.com', '922334455', 0),
	(4,	'Pham Minh D', 'dpham@hotmail.com', '933445566', 1000),
	(5,	'Hoang Anh E', 'ehoang@gmail.com', '944556677', 20);
    
insert into Guest_Profiles(profile_id, guest_id, address, birthday,national_id) values
	('101', 1, '123 Le Loi, Q1, HCM', '1990-05-15', '12345'),
	('102', 2,	'456 Nguyen Hue, Q1, HCM', '1985-10-20', '2345'),	
	('103', 3,	'789 Phan Chu Trinh, Da Nang', '1995-12-01', '34567'),	
	('104',	4,	'101 Hoang Hoa Tham, Ha Noi', '1988-03-25', '45678'),	
	('105',	5,	'202 Tran Hung Dao, Can Tho', '2000-07-10', '56789');	
    
insert into Rooms(room_id, room_name, room_type, price_per_night, room_status) values
	(1, 'Room 101',	'Standard', 10, 'Available'),
	(2,	'Room 202',	'Deluxe', 5, 'Occupied'),
	(3,	'Room 303',	'Suite', 50, 'Available'),
	(4,	'Room 104',	'Standard', 1, 'Occupied'),
	(5,	'Room 205',	'Deluxe', 20, 'Maintenance');
    
insert into Bookings(booking_id, guest_id, room_id, check_in_date, check_out_date, total_charge, booking_status) values
	(1001, 1, 1, '2023-11-18 10:10', '2023-11-18 12:00', 35500000, 'Completed'),
	(1002, 2, 2, '2023-01-12 14:20', '2023-12-04 12:00', 28000000, 'Completed'),
	(1003, 1, 3, '2024-01-10 9:15', '2024-01-11 12:00', 500000, 'Pending'),
	(1004, 3, 4, '2023-05-20 16:45', '2023-05-22 12:00', 7000000, 'Cancelled'),
	(1005, 4, 5, '2024-01-18 11:00', '2024-01-24 12:00', 1200000, 'Completed');


insert into Room_log(log_id, room_id, action_type, change_note, logged_at) values
	(1,	1,	'Check-in',	'Guest checked in', '2023-10-01	8:00'),
	(2,	1,	'Check-out', 'Guest checked out', '2023-11-15 10:35'),
	(3,	4,	'Maintenance',	'Room reported as damaged', '2023-11-20 15:00'),	
	(4,	2,	'Check-in', 'New guest arrival', '2023-11-25 9:00'),	
	(5,	3,	'Maintenance',	'Schedule maintenance', '2023-12-01 13:00');	
    
select * from Guests;
select * from Guest_Profiles;
select * from Bookings;
select * from Rooms;
select * from Room_log;

-- Viết câu lệnh UPDATE cộng 200 điểm tích lũy cho các khách hàng có email là đuôi '@gmail.com'
update Guests
set points = points + 200 where email like '%@gmail.com';

-- Viết câu lệnh DELETE xóa các bản ghi trong Room_Log có logged_at trước ngày 10/11/2023
delete from Room_log where logged_at < '2023-11-10';

-- PHẦN 2
-- Lấy danh sách phòng (room_name, price_per_night, room_status) có giá thuê > 1.000.000 hoặc room_status = 'Maintenance' hoặc room_type = 'Suite'
select room_name, price_per_night, room_status from Rooms
where price_per_night > 1000000 or room_status = 'Maintenance' or room_type = 'Suite';

-- Lấy thông tin khách (full_name, email) có email thuộc domain '@gmail.com' và loyalty_points nằm trong khoảng từ 50 đến 300.
select full_name, email
from Guests
where email like '%@gmail.com' and points between 50 and 300;

-- Hiển thị 3 booking có total_charge cao nhất, sắp xếp giảm dần, và bỏ qua booking cao nhất (chỉ lấy từ booking thứ 2 → thứ 4). 
-- Yêu cầu dùng LIMIT + OFFSET
select * from Bookings order by total_charge desc limit 3 offset 1;

-- PHẦN 3: TRUY VẤN DỮ LIỆU NÂNG CAO 
-- Viết câu lệnh truy vấn lấy ra các thông tin lịch đặt phòng gồm :
--  full_name
--   - national_id
--   - booking_id
--   - check_in_date
--   - total_charge
select 
	g.full_name,
    gp.national_id,
    b.booking_id,
    b.check_in_date,
    b.total_charge
from Bookings b 
join Guests g on b.guest_id = g.guest_id
join Guest_Profiles gp on gp.guest_id = g.guest_id;

-- Tính tổng số tiền thanh toán của mỗi khách. Chỉ hiển thị các khách có tổng chi tiêu của booking đã hoàn thành > 20.000.000 VNĐ.
select 
    g.full_name,
    sum(b.total_charge) as total_spent
from Bookings b
join guests g on g.guest_id = b.guest_id
where b.booking_status = 'Completed' group by g.guest_id having total_spent > 20000000;

-- Tìm thông tin phòng có price_per_night cao nhất trong danh sách các phòng đã từng xuất hiện trong booking thành công
select * from Rooms
where room_id in (select room_id from Bookings where booking_status = 'Completed')
order by price_per_night desc limit 1;

-- PHẦN 4: INDEX VÀ VIEW
-- Tạo Composite Index tên idx_booking_status_date trên bảng Bookings gồm 2 cột:
--   - booking_status
--   - created_at
create index idx_booking_status_date on Bookings(booking_status, created_at);

-- Tạo View vw_guest_booking_stats hiển thị:
--   - Guest Name
--   - Tổng số booking đã đặt
--   - Tổng số tiền đã thanh toán (chỉ lấy booking không bị hủy)
create or replace view vw_guest_booking_stats as
select
    g.full_name,
    count(b.booking_id) as total_bookings,
    sum(b.total_charge) as total_paid
from Guests g
left join Bookings b on g.guest_id = b.guest_id and b.booking_status != 'Cancelled'
group by g.guest_id;


-- PHẦN 5: TRIGGER 
-- Tạo trigger trg_after_update_booking_status. Khi một booking chuyển trạng thái sang 'Completed', tự động ghi vào Room_Log:
-- action_type = 'Check-out'
-- change_note = 'Booking Completed'
-- room_id lấy từ booking liên quan
-- logged_at = NOW()
delimiter //
create trigger trg_after_update_booking_status after update on Bookings
for each row
begin
    if old.booking_status <> 'Completed'
       and new.booking_status = 'Completed' then
        insert into Room_log(room_id, action_type, change_note, logged_at)
        values (new.room_id, 'Check-out', 'Booking Completed', now());
    end if;
end//
delimiter ;

-- Tạo trigger trg_update_loyalty_points trên bảng Bookings. Khi thêm booking mới với trạng thái 'Completed', tự động cộng loyalty_points cho khách:
-- Cứ mỗi 1.000.000 VNĐ → cộng 2 điểm.
delimiter //
create trigger trg_update_loyalty_points after insert on Bookings
for each row
begin
    if new.booking_status = 'Completed' then
        update guests
        set points = points + floor(new.total_charge / 1000000) * 2
        where guest_id = new.guest_id;
    end if;
end//
delimiter ;


-- PHẦN 6: STORED PROCEDURE 
-- Viết Procedure sp_get_room_status nhận vào room_id. Trả về message:
--   - 'Phòng trống' nếu room_status = 'Available'
--   - 'Đang có khách' nếu room_status = 'Occupied'
--   - 'Bảo trì' nếu room_status = 'Maintenance'
delimiter //
create procedure sp_get_room_status(
    in p_room_id int,
    out p_message varchar(50)
)
begin
    declare v_status varchar(20);
    select room_status into v_status from Rooms where room_id = p_room_id;

    if v_status = 'Available' then
        set p_message = 'Phòng trống';
    elseif v_status = 'Occupied' then
        set p_message = 'Đang có khách';
    elseif v_status = 'Maintenance' then
        set p_message = 'Bảo trì';
    end if;
end//
delimiter ;

-- Viết Procedure sp_cancel_booking xử lý hủy đặt phòng an toàn:
delimiter //
create procedure sp_cancel_booking(in p_booking_id int)
begin
    declare v_room_id int;
    
-- B1: Bắt đầu giao dịch.
    start transaction;
    select room_id into v_room_id from Bookings where booking_id = p_booking_id;

-- B2: Cập nhật booking_status → 'Cancelled'
    update bookings
    set booking_status = 'Cancelled' where booking_id = p_booking_id;

-- B3: Cập nhật trạng thái phòng tương ứng về 'Available'
    update rooms
    set room_status = 'Available' where room_id = v_room_id;

-- B4: Ghi nhật ký Room_Log với action_type = 'Cancelled'
    insert into room_log(room_id, action_type, change_note) values (v_room_id, 'Cancelled', 'Booking Cancelled');
    
-- B5: thành công
    commit;
end//
delimiter ;
