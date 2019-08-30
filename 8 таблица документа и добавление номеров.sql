set nocount on


create table document(number nvarchar(12), 
	id int identity(1,1), 
	[date] datetime2,
	comment nvarchar(1024) default N'Весьма перспективной представляется гипотеза, высказанная И.Гальпериным: линеаризация мышления безусловно просветляет механический образ. Звукопись дает газообразный экваториальный момент, так как в данном случае роль наблюдателя опосредована ролью рассказчика. Декодирование однородно аннигилирует ускоряющийся ньютонометр.')

go



declare @offset int = 0             

while @offset < 13500000
begin
	;with base(i )
	as (
	select 
		1 +@offset  as i
	union all 
	select 
		i + 1 
	from base 
	where i < 100 + @offset 
	)
	insert into document (number, [date])

	select 
		'ОРГ'+ format(base.i, 'd8') as _Number, getdate()
		
	from base

	set @offset = @offset + 100
	
end
