
set nocount on

create table #todo (_id int, number nvarchar(12))

create clustered index ndx1 on #todo(_id)

declare @offset int = 0

while 1=1
begin
	
	truncate table #todo
	
	insert into #todo
	select doc.id, doc.number
	from document doc
	where number_parts = N''
	order by doc.id
	offset @offset rows fetch next 10000 rows only

	if @@ROWCOUNT = 0
		break

	set @offset = @offset + 10000


	;with parts (part, _id) as
	(
		SELECT SUBSTRING(number, 1, 3) part
			,_id AS id
		FROM #todo
	
	
		UNION ALL
	
		SELECT SUBSTRING(number, 2, 3)
			,_id AS id
		FROM #todo
	
		UNION ALL
	
		SELECT SUBSTRING(number, 3, 3)
			,_id AS id
		FROM #todo
	
		UNION ALL
	
		SELECT SUBSTRING(number, 4, 3)
			,_id AS id
		FROM #todo
	
		UNION ALL
	
		SELECT SUBSTRING(number, 5, 3)
			,_id AS id
		FROM #todo
	
		UNION ALL
	
		SELECT SUBSTRING(number, 6, 3)
			,_id AS id
		FROM #todo
	
		UNION ALL
	
		SELECT SUBSTRING(number, 7, 3)
			,_id AS id
		FROM #todo
	
		UNION ALL
	
		SELECT SUBSTRING(number, 8, 3)
			,_id AS id
		FROM #todo
	
		UNION ALL
	
		SELECT SUBSTRING(number, 9, 3)
			,_id AS id
		FROM #todo
		) ,
	unique_parts (part, id) as
	(select distinct part, _id 
	from parts)

	update document 
	set number_parts = glue.combined_parts
	from 

		(select distinct
			 pt1.id as _id,
			(select pt2.part + ' ' as [text()]
			 from unique_parts  pt2
			 where pt2.id = pt1.id
			 for xml path('')
			)combined_parts
		from unique_parts  pt1) as glue
	where id = glue._id

			
end

drop table #todo
