CREATE DATABASE [like_vs_fulltext]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'like_vs_fulltext', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\DATA\like_vs_fulltext.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'like_vs_fulltext_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQL\MSSQL\DATA\like_vs_fulltext_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [like_vs_fulltext] SET RECOVERY SIMPLE 
GO

use [like_vs_fulltext]
GO

create table partners (id bigint identity (1,1) not null, 
	[description] nvarchar(max),
	[address] nvarchar(256) not null default N'107240, Москва, Волгоградский просп., 168Д',
	[phone] nvarchar(256) not null default N'+7 (495) 111-222-33',
	[contact_name] nvarchar(256) not null default N'Николай',
	[bio] nvarchar(2048) not null default N'Диалогический контекст решительно представляет собой размер. Казуистика, следовательно, заполняет метаязык. Можно предположить, что обсценная идиома параллельна. Наш современник стал особенно чутко относиться к слову, однако даосизм рассматривается язык образов. Заимствование осознаёт катарсис, таким образом, очевидно, что в нашем языке царит дух карнавала, пародийного отстранения. Отношение к современности вязко. Моцзы, Сюнъцзы и другие считали, что освобождение кумулятивно. Наряду с этим матрица представляет собой палимпсест, учитывая опасность, которую представляли собой писания Дюринга для не окрепшего еще немецкого рабочего движения. Предмет деятельности абсурдно контролирует глубокий реформаторский пафос, при этом нельзя говорить, что это явления собственно фоники, звукописи. Отвечая на вопрос о взаимоотношении идеального ли и материального ци, Дай Чжень заявлял, что диахрония откровенна. Закон внешнего мира осмысляет культурный голос персонажа. Гений ясен не всем.')
--пользуясь случаем, передаю привет сервису Яндекс.Реферат. Спасибо ему за увлекательную биографию наших контрагентов
