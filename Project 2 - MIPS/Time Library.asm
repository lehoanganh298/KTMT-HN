.globl main

main:	
	.data 
	time:	.asciiz "03/04/2018"
	.align 4
	day_promt:	.asciiz "Nhap ngay DAY:"
	.align 5
	month_promt:	.asciiz "\nNhap thang MONTH:"
	.align 5
	year_promt:	.asciiz "\nNhap nam YEAR:"
	.align 5
	new_line:	.asciiz "\n"
	.align 2
	day_str:	.space 3
	.align 2
	month_str:	.space 3
	.align 2
	year_str:	.space 5
	.align 3
	week_day:	.space 3
	.align 2
	#------------------------------
	month:             .space 4
	day:		   .space 2
	year:		   .space 4
	convertedDate:     .space 10

	#------------------------------
	#------------------------------
	demand: .asciiz "-----Ban hay chon 1 trong cac yeu cau sau day: -----\n"
	demand0: .asciiz "0. Thoat\n"
	demand1: .asciiz "1. Xuat chuoi TIME theo dinh dang DD/MM/YYYY\n"
	demand2: .asciiz "2.Chuyen doi chuoi TIME thanh mot trong cac dinh dang sau:\n A.MM/DD/YYYY\n B.Month DD, YYYY\n C.DD Month, YYYY\n"
	demand3: .asciiz "3.Cho biet ngay vua nhap la thu may?\n"
	demand4: .asciiz "4.Kiem tra nam trong chuoi TIME co phai nam nhuan khong?\n"
	demand5: .asciiz "5.Cho biet khoang thoi gian giua 2 chuoi TIME_1, TIME_2\n"
	demand6: .asciiz "6. Cho biet 2 nam nhuan gan nhat voi nam trong chuoi\n"
	
	str_choice: .asciiz "Lua chon: \n"
	str_result: .asciiz "Ket qua: \n"
	
	.text
LoopforChoice: 
	#Goi ham nhap 
	jal Input
	
	printMENU:
		la $a0, demand
		addi $v0, $zero, 4
		syscall
		
		la $a0, demand0
		addi $v0, $zero, 4
		syscall
		
		la $a0, demand1
		addi $v0, $zero, 4
		syscall
		
		la $a0, demand2
		addi $v0, $zero, 4
		syscall
		
		la $a0, demand3
		addi $v0, $zero, 4
		syscall
		
		
		la $a0, demand4
		addi $v0, $zero, 4
		syscall
		
		la $a0, demand5
		addi $v0, $zero, 4
		syscall
		
		la $a0, demand6
		addi $v0, $zero, 4
		syscall
		
		la $a0, str_choice 
		add $v0, $zero, 4
		syscall
		
		add $v0, $zero, 5 	#Input lua chon cua nguoi nhap	
		syscall 
		add $s0, $v0, 0 	#luu lua chon vao $s0
		
	beq $s0, 1, Cau1
	beq $s0, 2, Cau2
	beq $s0, 3, Cau3
	beq $s0, 4, Cau4
	beq $s0, 5, Cau5
	beq $s0, 6, Cau6
	j exitLoop
	Cau1: 
	Cau2:
	Cau3:
	Cau4:
	Cau5:
	Cau6:
	
	j LoopforChoice
exitLoop: 

#exit
end_main:
	addi $v0,$zero,10
	syscall


# Ham nhap ngay, thang, nam
Input:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	
while_input:
while_input_day:
	# In chuoi "Nhap ngay DAY:"
	la $a0,day_promt
	addi $v0, $zero, 4
	syscall
	
	# Nhap ngay vao bien day
	addi $a1,$zero,3
	la $a0,day_str
	addi $v0, $zero, 8
	syscall
	
	# Kiem tra chuoi ngay co toan la chu so hay khong
	addi $a1,$zero,2
	jal Check_all_digit
	beq $v0,$zero, while_input_day

while_input_month:	
	# In chuoi "Nhap thang MONTH:"
	la $a0,month_promt
	addi $v0, $zero, 4
	syscall
	
	# Nhap thang vao bien month
	addi $a1,$zero,3
	la $a0,month_str
	addi $v0, $zero, 8
	
	#la $s0, time_1
	#la $s1, time_2
	
	#addi $a0, $s0, 0
	#addi $a1, $zero, 'C'
	#jal Convert

	#addi $a0, $v0, 0
	#addi $v0, $zero, 1
	#syscall
	
	# Kiem tra chuoi ngay co toan la chu so hay khong
	addi $a1,$zero,2
	jal Check_all_digit
	beq $v0,$zero, while_input_month
	
	
while_input_year:	
	# In chuoi "Nhap nam YEAR:"
	la $a0,year_promt
	addi $v0, $zero, 4
	syscall
	
	# Nhap nam vao bien year
	addi $a1,$zero,5
	la $a0,year_str
	addi $v0, $zero, 8
	syscall
	
	# Kiem tra chuoi ngay co toan la chu so hay khong
	addi $a1,$zero,4
	jal Check_all_digit
	beq $v0,$zero, while_input_year
	
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
# ham lay ki tu thu $a1 cua string co dia chi $a0, tra gia tri ve $v0
Getchar:	
	# Vi lw chi lay gia tri trong cac dia chi la boi cua 4
	# nen ta load word o dia chi $a0 + ($a1 - $a1 % 4), sau do lay byte thu $a1 %4 cua word do
	
	# $t2 = $a1 % 4
	# $t1 = $a1 - $t2
	addi $t0,$zero,4	# $t0 = 4
	div $a1,$t0		
	mflo $t1		# $t1 = $a1 div 4
	sll $t1,$t1,2		# $t1 = ($a1 div 4) * 4 = $a1 - a1 % 4
	mfhi $t2		# $t1 = $a1 %4
	
	# Load word o dia chi $a0 + ($a1 - $a1 % 4)
	add $t3,$a0,$t1		 
	lw $v0,0($t3)		# $v0 = lw($a0 + $t1)
	
	# Lay byte o vi tri $a1 % 4 = $t2
	# Dich phai word ($t2-1)*4 don vi, sau do and voi 0000 0000 0000 0000 0000 0000 1111 1111
	addi $t4,$zero,0x00ff	# $t4 = 0000 0000 0000 0000 0000 0000 1111 1111
while_getchar:
	slt $t5,$zero,$t2	# $t5 = t2
	beq $t5,$zero,end_while_getchar	# while (t5>0) {
	srl $v0,$v0,8		#	$v0>>8;
	addi $t2,$t2,-1		#	$t5--;
	j while_getchar		# }
end_while_getchar:
	and $v0,$v0,$t4		# $v0 = $v0 & 0000 0000 0000 0000 0000 0000 1111 1111
	jr $ra
	
#----------------------------------------------------------	
# Ham chuyen $a0 tu ki tu sang so
# Neu $a0 la chu so, tra ve $v1 = 1, $v0 la gia tri so duoc chuyen thanh
# Neu #a0 khong la chu so, tra ve $v1 = 0
	
	# if (a0 < '0' || a0 > '9')
	#	$v1 = 0;
	# else {
	# 	$v1=0;
	#	$v0=$a0-48 (48= '0' - 0)
	# }
Char_to_number:
	addi $t1,$zero,'0'
	addi $t2,$zero,'9'
	slt $t3,$a0,$t1
	bne $t3,$zero,not_digit
	slt $t3,$t2,$a0
	bne $t3,$zero,not_digit
	addi $v1,$zero,1
	addi $v0,$v0,-48
	j end_Char_to_number
not_digit:
	addi $v1,$zero,0
end_Char_to_number:
	jr $ra

#----------------------------------------------------------
# Ham ket hop Getchar va Char_to_number
# Lay ki tu thu $a1 cua chuoi co dia chia $a0, doi ki tu do sang so, tra ve gia tri trong $v0
# Neu co the doi ki tu sang so, $v1 = 1, neu khong, $v1 = 0
Getchar_Char_to_number:
	# Luu $ra va $a0 vao stack
	add $sp,$sp,-8
	sw $ra,4($sp)
	sw $a0,0($sp)
	
	jal Getchar	# Tham so $a0 cua Getchar chinh la $a0 cua Getchar_Char_to_number nen khong can gan lai
	lw $a0,0($sp)	# Tra lai gia tri $a0 trong stack
	
	addi $a0,$v0,0	# Lay gia tri tra ve cua ham Getchar lam tham so $a0 cho ham Char_to_number
	
	jal Char_to_number
	lw $a0,0($sp)	# Tra lai gia tri $a0 trong stack
	
	#Khoi phuc stack
	lw $ra,4($sp)	
	add $sp,$sp,8
	jr $ra	

# Ham kiem tra chuoi co toan la ki tu chu so hay khong
# Chuoi co dia chi luu trong $a0, do dai $a1
# Tra ve $v0 = 1 neu dung, $v0 = 0 neu co ki tu khong phai la chu so
Check_all_digit:
	addi $sp,$sp,-12
	sw $ra,8($sp)
	sw $a1,4($sp)
	
	addi $t1,$zero,0
	
while_checkdigit:
	slt $t2,$t1,$a1
	beq $t2,$zero, end_while_checkdigit
	addi $a1,$t1,0
	
	sw $t1,0($sp)
	jal Getchar_Char_to_number
	lw $a1,4($sp)
	lw $t1,0($sp)
	
	beq $v1,$zero, check_digit_false
	addi $t1,$t1,1
	j while_checkdigit
	
end_while_checkdigit:
	addi $v0,$zero,1
	j end_check_digit
check_digit_false:
	addi $v0,$zero,0
end_check_digit:
	lw $ra,8($sp)
	addi $sp,$sp,12
	jr $ra
		
#----------------------------------------------------------
# Ham lay gia tri ngay trong chuoi TIME (DD/MM/YYYY) co dia chi $a0
# Neu co the lay gia tri ngay, tra ve $v1 = 1, $v0 la gia tri ngay
# Neu khong the lay gia tri ngay, tra ve $v1 = 0
Day:
	# Luu $ra va $a0 vao stack
	add $sp,$sp,-12
	sw $ra,8($sp)
	sw $a0,4($sp)
	
	# Lay ky tu dau tien cua chuoi va chuyen sang so
	addi $a1,$zero,0
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	
	# Neu ki tu dau tien khong phai la chu so -> incorrect
	beq $v1,$zero,incorrect_day
	
	# $t0 = $v0*10 (chu so hang chuc)
	addi $t1,$zero, 10
	mult $v0,$t1
	mflo $t0
	
	sw $t0,0($sp)	# Luu $t0 vao trong stack
	
	# Lay ky tu thu 2 cua chuoi va chuyen sang so
	addi $a1,$zero,1
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	lw $t0,0($sp)
	
	# Neu ki tu thu 2 khong phai la chu so -> incorrect
	beq $v1,$zero,incorrect_day
	
	# $t0 += $v0 (chu so hang don vi)
	add $t0,$t0,$v0
	
	addi $v1,$zero,1
	addi $v0,$t0,0
	j end_day
incorrect_day:
	addi $v1,$zero,0
end_day:
	lw $ra,8($sp)
	lw $a0,4($sp)
	add $sp,$sp,12
	jr $ra

#----------------------------------------------------------	
# Ham lay gia tri thang trong chuoi TIME (DD/MM/YYYY) co dia chi $a0
# Neu co the lay gia tri thang, tra ve $v1 = 1, $v0 la gia tri thang
# Neu khong the lay gia tri thang, tra ve $v1 = 0
Month:
	# Hoan toan tuong tu ham Day
	add $sp,$sp,-12
	sw $ra,8($sp)
	sw $a0,4($sp)
	
	# Lay ki tu thu 3, chuyen sang so
	addi $a1,$zero,3
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	
	beq $v1,$zero,incorrect_month
	
	# $t0 += $v0 *10 (chu so hang chuc)
	addi $t1,$zero, 10
	mult $v0,$t1
	mflo $t0
	
	sw $t0,0($sp)	# Luu gia tri cua $t0 vao stack
	
	# Lay ki tu thu 6, chuyen sang so
	addi $a1,$zero,4
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	lw $t0,0($sp)
	
	beq $v1,$zero,incorrect_month
	
	# $t0 += $v0 (chu so hang don vi)
	add $t0,$t0,$v0
	
	addi $v1,$zero,1
	addi $v0,$t0,0
	j end_month
incorrect_month:
	addi $v1,$zero,0
end_month:
	
	lw $ra,8($sp)
	add $sp,$sp,12
	jr $ra
	
#--------------------------------------------------------	
# Ham lay gia tri ngay trong chuoi TIME (DD/MM/YYYY) co dia chi $a0
# Neu co the lay gia tri ngay, tra ve $v1 = 1, $v0 la gia tri ngay
# Neu khong the lay gia tri ngay, tra ve $v1 = 0
Year:
	# Tuong tu ham Day
	add $sp,$sp,-12
	sw $ra,8($sp)
	sw $a0,4($sp)
	
	# Lay ki tu thu 6, chuyen sang so
	addi $a1,$zero,6
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	
	beq $v1,$zero,incorrect_year
	
	# $t0 = $v0 *1000 (chu so hang nghin)
	addi $t1,$zero, 1000
	mult $v0,$t1
	mflo $t0
	
	sw $t0,0($sp)	# Luu gia tri cua $t0 vao stack
	
	# Lay ki tu thu 7, chuyen sang so
	addi $a1,$zero,7
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	lw $t0,0($sp)
	
	beq $v1,$zero,incorrect_year
	
	# $t0 += $v0 *100 (chu so hang tram)
	addi $t1,$zero, 100
	mult $v0,$t1
	mflo $t2
	add $t0,$t0,$t2
	
	sw $t0,0($sp)	# Cap nhat gia tri cua $t0 vao stack
	
	# Lay ki tu thu 8, chuyen sang so
	addi $a1,$zero,8
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	lw $t0,0($sp)
	
	beq $v1,$zero,incorrect_year
	
	# $t0 += $v0 *10 (chu so hang chuc)
	addi $t1,$zero, 10
	mult $v0,$t1
	mflo $t2
	add $t0,$t0,$t2
	
	sw $t0,0($sp)	# Cap nhat gia tri cua $t0 vao stack
	
	# Lay ki tu thu 9, chuyen sang so
	addi $a1,$zero,9
	jal Getchar_Char_to_number
	lw $a0,4($sp)
	lw $t0,0($sp)
	
	beq $v1,$zero,incorrect_year
	
	# $t0 += $v0 (chu so hang don vi)
	add $t0,$t0,$v0
	
	addi $v1,$zero,1
	addi $v0,$t0,0
	j end_year
incorrect_year:
	addi $v1,$zero,0
end_year:
	lw $ra,8($sp)
	add $sp,$sp,12
	jr $ra

#----------------------------------------------------
# Kiem tra xem nam trong chuoi "DD/MM/YYYY" co phai la nam nhuan hay khong
# Neu co tra ve 1, nguoc lai tra ve 0
LeapYear:
	add $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	jal Year
	addi $a0, $v0, 0  # Lay nam trong chuoi luu vao $a0
	jal isLeapYear
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	jr $ra
#--------------------------------------------------
# Cho biet nam do thuoc the ki nao
getCentury:
	add $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	addi $t0, $a0, 0  # Year
	# Cong thuc tinh the ki tong quat la: century = (year + 99) / 100
	addi $t0, $t0, 99  # year + 99
	addi $t1, $zero, 100  
	div $t0, $t1
	mflo $t2      # (year + 99) / 100
	addi $v0, $t2, 0
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra
#------------------------------------------------
# Lenh tao chuoi mang ten thu trong tuan
getWeekDayString:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	la $t0, week_day    # week_day la chuoi tra ve
	beq $a0, $zero, Saturday
	addi $t2, $a0, -1
	beq $t2, $zero, Sunday
	addi $t2, $a0, -2
	beq $t2, $zero, Monday
	addi $t2, $a0, -3
	beq $t2, $zero, Tuesday
	addi $t2, $a0, -4
	beq $t2, $zero, Wednesday
	addi $t2, $a0, -5
	beq $t2, $zero, Thursday
	addi $t2, $a0, -6
	beq $t2, $zero, Friday
	#Tao cac chuoi tuong ung voi cac thu trong tuan
	Monday:
		addi $t1, $zero, 77
		sb $t1, 0($t0)
		addi $t1, $zero, 111
		sb $t1, 1($t0)
		addi $t1, $zero, 110
		sb $t1, 2($t0)
		j endGetWeekDayString
	Tuesday:
		addi $t1, $zero, 84
		sb $t1, 0($t0)
		addi $t1, $zero, 117
		sb $t1, 1($t0)
		addi $t1, $zero, 101
		sb $t1, 2($t0)
		j endGetWeekDayString
	Wednesday:
		addi $t1, $zero, 87
		sb $t1, 0($t0)
		addi $t1, $zero, 101
		sb $t1, 1($t0)
		addi $t1, $zero, 100
		sb $t1, 2($t0)
		j endGetWeekDayString
	Thursday:
		addi $t1, $zero, 84
		sb $t1, 0($t0)
		addi $t1, $zero, 104
		sb $t1, 1($t0)
		addi $t1, $zero, 117
		sb $t1, 2($t0)
		j endGetWeekDayString
	Friday:
		addi $t1, $zero, 70
		sb $t1, 0($t0)
		addi $t1, $zero, 114
		sb $t1, 1($t0)
		addi $t1, $zero, 105
		sb  $t1, 2($t0)
		j endGetWeekDayString
	Saturday:
		addi $t1, $zero, 83
		sb $t1, 0($t0)
		addi $t1, $zero, 97
		sb $t1, 1($t0)
		addi $t1, $zero, 116
		sb $t1, 2($t0)
		j endGetWeekDayString
	Sunday:	
		addi $t1, $zero, 83
		sb $t1, 0($t0)
		addi $t1, $zero, 117
		sb $t1, 1($t0)
		addi $t1, $zero, 110
		sb $t1, 2($t0)
		j endGetWeekDayString
	endGetWeekDayString:
		addi $v0, $t0, 0
		lw $a0, 0($sp)
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		jr $ra		
		
# Lenh lay so m tuong ung voi cac thang
getM:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	jal Month
	addi $t8, $v0, 0             # Month
	jal LeapYear
	addi $t1, $v0, 0             # Kiem tra nam nhuan
	beq $t1, $zero, notLeapYear
	addi $t0, $t8, -1
	beq $t0, $zero, return6
	addi $t0, $t8, -2
	beq $t0, $zero, return2
notLeapYear:
	addi $t0, $t8, -1
	beq $t0, $zero, return0
	addi $t0, $t8, -2
	beq $t0, $zero, return3
	addi $t0, $t8, -3
	beq $t0, $zero, return3
	addi $t0, $t8, -4
	beq $t0, $zero, return6
	addi $t0, $t8, -5
	beq $t0, $zero, return1
	addi $t0, $t8, -6
	beq $t0, $zero, return4
	addi $t0, $t8, -7
	beq $t0, $zero, return6
	addi $t0, $t8, -8
	beq $t0, $zero, return2
	addi $t0, $t8, -9
	beq $t0, $zero, return5
	addi $t0, $t8, -10
	beq $t0, $zero, return0
	addi $t0, $t8, -11
	beq $t0, $zero, return3
	addi $t0, $t8, -12
	beq $t0, $zero, return5
	return0:
		addi $v0, $zero, 0
		j exitGetM
	return1:
		addi $v0, $zero, 1
		j exitGetM
	return2:
		addi $v0, $zero, 2
		j exitGetM
	return3:
		addi $v0, $zero, 3
		j exitGetM
	return4:
		addi $v0, $zero, 4
		j exitGetM
	return5:
		addi $v0, $zero, 5
		j exitGetM
	return6:
		addi $v0, $zero, 6
		j exitGetM
	exitGetM:
		lw $ra, 4($sp)
		lw $a0, 0($sp)
		addi $sp, $sp, 8
		jr $ra
#--------------------------------------
# Cho biet ngay do la thu may trong tuan
WeekDay:
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	jal Day               # $s0 = d
	addi $s0, $v0, 0
	jal getM
	addi $s1, $v0, 0      #  $s1 = m
	jal Year
	addi $s2, $v0, 0
	addi $t0, $zero, 100
	div $s2, $t0
	mfhi $s2              # $s2 = y
	addi $a0, $v0, 0
	jal getCentury
	addi $s3, $v0, 0        # $s3 = c
	add $s4, $s1, $s0      # d + m
	add $s4, $s3, $s4   # + c
	add $s4, $s2, $s4    # + y
	addi $t5, $zero, 4     # = 4
	div $s2, $t5           # y / 4
	mflo $s6
	add $s4, $s6, $s4   # d + m + y + y/4 + c
	addi $t0, $zero, 7
	div $s4, $t0
	mfhi $t1
	addi $a0, $t1, 0
	jal getWeekDayString
	lw $a0, 0($sp)
	lw $ra, 4($sp)
	addi $sp, $sp,  8
	jr $ra

#-------------------------------------------
#Ham kiem tra nam nhuan
#$v0 giu gia tri 1 la nam nhuan
isLeapYear:
	..text
	#Luu du lieu
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	#Kiem tra year % 400 == 0
	lw $a0, 0($sp)
	addi $t0, $zero, 400
	rem $t1, $a0, $t0
	beq	$t1, $zero, returnTrue

	#Kiem tra chia het cho 4
	lw $a0, 0($sp)
	addi $t0, $zero, 4
	rem $t1, $a0, $t0
	bne $t1, $zero, returnFalse

	#Kiem tra chia het cho 100
	lw $a0, 0($sp)
	addi $t0, $zero, 100
	rem $t1, $a0, $t0
	beq $t1, $zero, returnFalse

returnTrue:
	addi $v0, $zero, 1
	j exitLeapYear
returnFalse:
	addi $v0, $zero, 0
	
exitLeapYear: 	
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra

#--------------------------------------
#Xuat 2 nam nhuan lien ke
#Tham so truyen vao la char* TIME
next2LeapYear:
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $a0,	4($sp) #dia chi chua chuoi TIME

	#Lay year ra
	lw $a0, 4($sp)
	jal Year
	addi $a0, $v0, 0
	
	addi $a1, $zero, 0 #bien dem so nam nhuan da tim duoc
findLeapYear:
	addi $a0, $a0, 1  #tang year len
	
	jal isLeapYear 		#Kiem tra nam nhuan
	addi $t0, $v0, 0
	
	beq $t0, $0, findLeapYear 	#Neu khong phai, tim tiep
	addi $a1, $a1, 1 		#Tang bien dem len 1 

	addi $t0, $zero, 4		#Xac dinh vi tri cua ket qua de luu vao stack
	sll $t1, $a1, 2
	add $t0, $t0, $t1
	
	add $sp, $sp, $t0		#Luu ket qua
	sw $a0, 0($sp)			
	sub $sp, $sp, $t0

	bne $a1, 2, findLeapYear

exitNext2LeapYear:
	lw $ra, 0($sp)
	
	lw $a0, 8($sp)		#In ket qua 1
	addi $v0, $zero, 1
	syscall

	lw $a0, 12($sp)		#ket qua 2
	addi $v0, $zero, 1
	syscall

	lw $a0, 4($sp) 	
	
	addi $sp, $sp, 16	
	jr $ra

# Convert Day sang chuoi
DayToString:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	la $t4, day
	addi $s0, $a0, 0
	addi $t0, $zero, 10
	div $s0, $t0
	mfhi $t1             # So Hang Don Vi
	mflo $t2             # So Hang Chuc
	# Chuyen tung ki tu sang char roi luu vao chuoi
	addi $t3, $t1, 48
	sb $t3, 1($t4)
	addi $t3, $t2, 48
	sb $t3, 0($t4)
	addi $v0, ,$t4, 0
	# exit
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra

# Convert Month sang chuoi
MonthToString:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	addi $s0, $a0, 0
	addi $t0, $a1, -65
	beq $t0, $zero, numConvert
	addi $t0, $a1, -66
	beq $t0, $zero, nameConvert
	addi $t0, $a1, -67
	beq $t0, $zero, nameConvert
numConvert:
	la $t4, month
	addi $s0, $a0, 0
	addi $t0, $zero, 10
	div $s0, $t0
	mfhi $t1             # So Hang Don Vi
	mflo $t2             # So Hang Chuc
	# Chuyen tung ki tu sang char roi luu vao chuoi
	addi $t3, $t1, 48
	sb $t3, 1($t4)
	addi $t3, $t2, 48
	sb $t3, 0($t4)
	addi $v0, ,$t4, 0
	j exitMonthToString
nameConvert:
	addi $t0, $a0, -1
	beq $t0, $zero, getJan
	addi $t0, $a0, -2
	beq $t0, $zero, getFeb
	addi $t0, $a0, -3
	beq $t0, $zero, getMar
	addi $t0, $a0, -4
	beq $t0, $zero, getApr
	addi $t0, $a0, -5
	beq $t0, $zero, getMay
	addi $t0, $a0, -6
	beq $t0, $zero, getJun
	addi $t0, $a0, -7
	beq $t0, $zero, getJul
	addi $t0, $a0, -8
	beq $t0, $zero, getAug
	addi $t0, $a0, -9
	beq $t0, $zero, getSep
	addi $t0, $a0, -10
	beq $t0, $zero, getOct
	addi $t0, $a0, -11
	beq $t0, $zero, getNov
	addi $t0, $a0, -12
	beq $t0, $zero, getDec
getJan:
	addi $a0, $zero, 'J'
	addi $a1, $zero, 'a'
	addi $a2, $zero, 'n'
	jal getNameOfMonth
	j exitMonthToString
getFeb:
	addi $a0, $zero, 'F'
	addi $a1, $zero, 'e'
	addi $a2, $zero, 'b'
	jal getNameOfMonth
	j exitMonthToString
getMar:
	addi $a0, $zero, 'M'
	addi $a1, $zero, 'a'
	addi $a2, $zero, 'r'
	jal getNameOfMonth
	j exitMonthToString
getApr:
	addi $a0, $zero, 'A'
	addi $a1, $zero, 'p'
	addi $a2, $zero, 'r'
	jal getNameOfMonth
	j exitMonthToString
getMay:
	addi $a0, $zero, 'M'
	addi $a1, $zero, 'a'
	addi $a2, $zero, 'y'
	jal getNameOfMonth
	j exitMonthToString
getJun:
	addi $a0, $zero, 'J'
	addi $a1, $zero, 'u'
	addi $a2, $zero, 'n'
	jal getNameOfMonth
	j exitMonthToString
getJul:
	addi $a0, $zero, 'J'
	addi $a1, $zero, 'u'
	addi $a2, $zero, 'l'
	jal getNameOfMonth
	j exitMonthToString
getAug:
	addi $a0, $zero, 'A'
	addi $a1, $zero, 'u'
	addi $a2, $zero, 'g'
	jal getNameOfMonth
	j exitMonthToString
getSep:
	addi $a0, $zero, 'S'
	addi $a1, $zero, 'e'
	addi $a2, $zero, 'p'
	jal getNameOfMonth
	j exitMonthToString
getOct:
	addi $a0, $zero, 'O'
	addi $a1, $zero, 'c'
	addi $a2, $zero, 't'
	jal getNameOfMonth
	j exitMonthToString
getNov:
	addi $a0, $zero, 'N'
	addi $a1, $zero, 'o'
	addi $a2, $zero, 'v'
	jal getNameOfMonth
	j exitMonthToString
getDec:
	addi $a0, $zero, 'D'
	addi $a1, $zero, 'e'
	addi $a2, $zero, 'c'
	jal getNameOfMonth
	j exitMonthToString
exitMonthToString:
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra

# Convert Year sang chuoi
YearToString:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	addi $s0, $a0, 0
	la $t4, year
	addi $t2, $zero, 4
Loop:
	beq $s0, 0, exitYearToString
	addi $t0, $zero, 10
	div $s0, $t0
	mfhi $t3
	mflo $s0
	addi $t3, $t3, 48
	addi $t5, $t2, -4
	beq $t5, $zero, add3
	addi $t5, $t2, -3
	beq $t5, $zero, add2
	addi $t5, $t2, -2
	beq $t5, $zero, add1
	addi $t5, $t2, -1
	beq $t5, $zero, add0
add3:
	sb $t3, 3($t4)
	addi $t2, $t2, -1
	j Loop
add2:
	sb $t3, 2($t4)
	addi $t2, $t2, -1
	j Loop
add1:
	sb $t3, 1($t4)
	addi $t2, $t2, -1
	j Loop
add0:
	sb $t3, 0($t4)
	addi $t2, $t2, -1
	j Loop
exitYearToString:
	addi $v0, $t4, 0
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra

# Tao chuoi ten thang
getNameOfMonth:
	addi $sp, $sp, -16
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	sw $a1, 8($sp)
	sw $a2, 12($sp)
	
	la $t7, month
	addi $t0, $a0, 0
	sb $t0, 0($t7)
	addi $t0, $a1, 0
	sb $t0, 1($t7)
	addi $t0, $a2, 0
	sb $t0, 2($t7)
	
	addi $v0, $t7, 0
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
# Convert chuoi ngay ra kieu A MM/DD/YYYY
convertAType:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	
	la $t7, convertedDate
	jal Month
	addi $a0, $v0, 0
	addi $a1, $zero, 65
	jal MonthToString
	addi $t1, $v0, 0
	lb $t2, 0($t1)
	sb $t2, 0($t7)
	lb $t2, 1($t1)
	sb $t2, 1($t7)
	addi $t2, $zero, 47
	sb $t2, 2($t7)
	lw $a0, 0($sp)
	jal Day
	addi $a0, $v0, 0
	jal DayToString
	addi $t1, $v0, 0
	lb $t2, 0($t1)
	sb $t2, 3($t7)
	lb $t2, 1($t1)
	sb $t2, 4($t7)
	addi $t2, $zero, 47
	sb $t2, 5($t7)
	lw $a0, 0($sp)
	jal Year
	addi $a0, $v0, 0
	jal YearToString
	addi $t1, $v0, 0
	lb $t2, 0($t1)
	sb $t2, 6($t7)
	lb $t2, 1($t1)
	sb $t2, 7($t7)
	lb $t2, 2($t1)
	sb $t2, 8($t7)
	lb $t2, 3($t1)
	sb $t2, 9($t7)
	# exit
	addi $v0, $t7, 0
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	j exitMainConvert

# Convert chuoi ngay ra kiem Month DD, YYYY
convertBType:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	# Gan chuoi Month
	la $t8, convertedDate
	jal Month
	addi $a0, $v0, 0
	addi $a1, $zero, 66
	jal MonthToString
	addi $t0, $v0, 0    # Month String
	lb $t1, 0($t0)
	sb $t1, 0($t8)
	lb $t1, 1($t0)
	sb $t1, 1($t8)
	lb $t1, 2($t0)
	sb $t1, 2($t8)
	addi $t1, $zero, 32
	sb $t1, 3($t8)
	# Gan chuoi Day
	lw $a0, 0($sp)
	jal Day
	addi $a0, $v0, 0
	jal DayToString
	addi $t0, $v0, 0   # Day String
	lb $t1, 0($t0)
	sb $t1, 4($t8)
	lb $t1, 1($t0)
	sb $t1, 5($t8)
	addi $t1, $zero, 44
	sb $t1, 6($t8)
	# Gan chuoi Year
	lw $a0, 0($sp)
	jal Year
	addi $t5, $v0, 0
	addi $t2, $zero, 10
	addi $t3, $zero, 4
setYear:
	beq $t5, $zero, exitConvert
	div  $t5, $t2
	mfhi $t1
	addi $t1, $t1, 48
	addi $t4, $t3, -4
	beq $t4, $zero, add10
	addi $t4, $t3, -3
	beq $t4, $zero, add9
	addi $t4, $t3, -2
	beq $t4, $zero, add8
	addi $t4, $t3, -1
	beq $t4, $zero, add7
add10:
	sb $t1, 10($t8)
	mflo $t5
	addi $t3, $t3, -1
	j setYear
add9:
	sb $t1, 9($t8)
	mflo $t5
	addi $t3, $t3, -1
	j setYear
add8:
	sb $t1, 8($t8)
	mflo $t5
	addi $t3, $t3, -1
	j setYear
add7:
	sb $t1, 7($t8)
	mflo $t5
	addi $t3, $t3, -1
	j setYear
exitConvert:	
	addi $v0, $t8, 0
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	j exitMainConvert

# Chuyen chuoi ngay thanh dang DD Month, YYYY
convertCType:
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	# Gan chuoi Day
	la $t8, convertedDate
	jal Day
	addi $a0, $v0, 0
	jal DayToString
	addi $t0, $v0, 0   # Day String
	lb $t1, 0($t0)
	sb $t1, 0($t8)
	lb $t1, 1($t0)
	sb $t1, 1($t8)
	addi $t1, $zero, 32
	sb $t1, 2($t8)
	# Gan chuoi Month 
	lw $a0, 0($sp)
	jal Month
	addi $a0, $v0, 0
	addi $a1, $zero, 66
	jal MonthToString
	addi $t2, $v0, 0    # Month String
	lb $t1, 0($t2)
	sb $t1, 3($t8)
	lb $t1, 1($t2)
	sb $t1, 4($t8)
	lb $t1, 2($t2)
	sb $t1, 5($t8)
	addi $t1, $zero, 44
	sb $t1, 6($t8)
	# Gan chuoi Year
	lw $a0, 0($sp)
	jal Year
	addi $t5, $v0, 0
	addi $t2, $zero, 10
	addi $t3, $zero, 4
	j setYear  


Convert:
	addi $sp, $sp, -12
	sw $ra, 4($sp)
	sw $a0, 0($sp)
	sw $a1, 8($sp)
	
	addi $t0, $a1, -65
	beq $t0, $zero, convertAType
	addi $t0, $a1, -66
	beq $t0, $zero, convertBType
	addi $t0, $a1, -67
	beq $t0, $zero, convertCType
	
exitMainConvert:
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	jr $ra

#-------------------------------------
#Tinh khoang cach giua 2 chuoi TIME_1 va TIME_2
#Input vao chuoi TIME_1 phai nho hon TIME_2
#Don vi tinh: nam
distanceDate:
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $a0, 4($sp) 	#Luu chuoi TIME_1
	sw $a1, 8($sp)	#Luu chuoi TIME_2
	
	#Lay Year cua TIME_1
	lw $a0, 4($sp)
	jal Year
	sw $v0, 12($sp)
	#Lay Year cua TIME_2
	lw $a0, 8($sp)
	jal Year
	sw $v0, 16($sp)

	lw $a0, 12($sp)		#Load year cua TIME_1
	lw $a1, 16($sp)		#Load year cua TIME_2

	sub $t0, $a1, $a0	#Tinh khoang cach nam
	sw $t0, 20($sp)		
	
compareMonth:
	#Lay thang cho TIME_1
	lw $a0, 4($sp)
	jal Month
	sw $v0, 12($sp)
	#Lay thang cho TIME_2
	lw $a0, 8($sp)
	jal Month
	sw $v0, 16($sp)
	
	#Neu thang cua TIME_2 nho hon TIME_1 thi giam ket qua di 1 
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	beq $t2, $t1, compareDay 	#Neu thang bang nhau thi so sanh ngay
	slt $t0, $t2, $t1  		#So sanh gia tri $t1 < $t0
	beq $t0, 1, decrease
	j exitDistanceDate
	
compareDay:
	#Lay ngay cho TIME_1
	lw $a0, 4($sp)
	jal Day
	sw $v0, 12($sp)
	#Lay ngay cho TIME_2
	lw $a0, 8($sp)
	jal Day
	sw $v0, 16($sp)
	
	#Neu ngay cua TIME_2 nho hon TIME_1 thi tru ket qua di 1
	lw $t1, 12($sp)
	lw $t2, 16($sp)
	slt $t0, $t2, $t1
	beq $t0, 0, exitDistanceDate 
	
#Giam ket qua xuong 1 
decrease:
	lw $v0, 20($sp)
	addi $v0, $v0, -1
	sw $v0, 20($sp) 
	
	
exitDistanceDate:
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $v0, 20($sp)
	addi $sp, $sp, 24
	jr $ra

