set nocount on

create table #name_mask (id int)
create table #secname_mask (id int)
create table #stat (cnt int)

create table #prefix (px nvarchar(128), id int identity(1,1))
insert into #prefix (px) values ('Договор с ')
insert into #prefix (px) values ('Дог. с ')
insert into #prefix (px) values ('Договор № 123 с ')



declare @i int,
	@limit int, --число комбинаций ФИО, которое мы загрузим для текущей фамилии
	@bucket_size int, --общее число имен или отчеств делится на "@limit" частей 
					  --и из каждой части будет вытаскиваться случайное имя или отчество
					  --так мы растянем распределение вытаскиваемых имен и отчеств "вправо"
	@last_id int	  

declare @surname nvarchar(64),
	@sex int,
	@prev_letter nchar(1) = '',
	@prefix_id int

declare surnames cursor for 
select [name], [sex] from dbo.wiki_snames

open surnames
while 1=1
begin

	fetch next from surnames into @surname , @sex
	if @@FETCH_STATUS != 0 
		break


	if left(@surname,1) != @prev_letter 
	begin
		set @prev_letter = left(@surname,1)
		print(@prev_letter) --чтобы хоть как-то было видно прогресс
	end


	--имена
	select @limit = RAND() * 17 + 5,
		@i = 1,
		@last_id = 0,
		@prefix_id = rand()*3+1
	
	select @bucket_size = 
		case when @sex =  0 
			then  108 / @limit
		else 83 / @limit --женских имен в базе меньше
	end
	
	truncate table #name_mask
	while @i <= @limit
	begin
		set @last_id = rand() * @bucket_size + @last_id +1

		insert into #name_mask
		values (@last_id )
		
		set @i = @i+1

	end
	
	--теперь отчества
	select @limit = RAND() * 8 + 4,
		@i = 1,
		@last_id = 0
	
	select @bucket_size = 108 / @limit
		
	truncate table #secname_mask
	while @i <= @limit
	begin
		set @last_id = rand() * @bucket_size + @last_id +1

		insert into #secname_mask
		values (@last_id )
		
		set @i = @i+1

	end
	

	insert into #stat (cnt)
	select (select count(*) from #name_mask) * 
	  (select count(*) from #secname_mask)

	--собираем все вместе
	if @sex = 0
		
		insert into partners with (tablockx) ([description]) 
		select prfx.px +    @surname + N' '+ nms.[name] + N' '+ snms.[name]
		from m_names nms
			inner join #name_mask nmsk
				on nms.id = nmsk.id
			left join dbo.m_secnames snms 
				inner join #secname_mask snmsk
					on snms.id = snmsk.id
				on 1=1
			left join #prefix prfx
				on prfx.id = @prefix_id;
				


	else
		insert into partners with (tablockx) ([description]) 
		select prfx.px +     @surname + N' '+ nms.[name] + N' '+ snms.[name]
		from dbo.f_names nms
			inner join #name_mask nmsk
				on nms.id = nmsk.id
			left join f_secnames snms 
				inner join #secname_mask snmsk
					on snms.id = snmsk.id
				on 1=1
			left join #prefix prfx
				on prfx.id = @prefix_id;
				



end
close surnames
deallocate surnames

drop table #name_mask
drop table #secname_mask
drop table #prefix


select min(cnt) [минимум], max(cnt) [максмум], avg(cnt) [среднее], STDEV (cnt) [стд. отклонение]
from #stat

drop table #stat
