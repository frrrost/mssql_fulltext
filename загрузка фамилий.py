from selenium import webdriver
import pandas as pd
from sqlalchemy import create_engine


names = pd.Series()

url = 'https://ru.wikipedia.org/w/index.php?title=%D0%9A%D0%B0%D1%82%D0%B5%D0%B3%D0%BE%D1%80%D0%B8%D1%8F:%D0%A1%D1%82%D1%80%D0%B0%D0%BD%D0%B8%D1%86%D1%8B,_%D1%81%D0%BE%D0%B4%D0%B5%D1%80%D0%B6%D0%B0%D1%89%D0%B8%D0%B5_%D1%81%D0%BF%D0%B8%D1%81%D0%BA%D0%B8_%D0%BE%D0%B4%D0%BD%D0%BE%D1%84%D0%B0%D0%BC%D0%B8%D0%BB%D1%8C%D1%86%D0%B5%D0%B2&from=%D0%90'


names = pd.Series()

#with webdriver.Firefox() as driver:
driver = webdriver.Firefox()
while True:
    driver.get(url)
    time.sleep(1) #чтобы страница успела прогрузиться

    c_names = [nm.text for nm in driver.find_elements_by_xpath('//*[@class="mw-category-group"]/ul/li')  ]
    names = names.append(pd.Series (c_names), ignore_index= True)

    next_page_link = driver.find_elements_by_xpath('//*[@id="mw-pages"]/a[.="Следующая страница"]')
    if len(next_page_link) == 0:
        break

    url = next_page_link[0].get_attribute('href')


x = pd.DataFrame(names)
x.columns = ['name']

x['cut'] = x['name'].apply(lambda x: x.split(' ')[0])
unique = x.drop_duplicates('cut')
unique['sex'] = unique['cut'].apply(lambda x: x[-1] == 'а')


mssql = create_engine('mssql+pyodbc://<логин>:<пароль>@<хост>/like_vs_fulltext?driver=ODBC+Driver+13+for+SQL+Server')
unique.to_sql(name= 'wiki_snames', con = mssql, if_exists = 'append', chunksize=1000 )
