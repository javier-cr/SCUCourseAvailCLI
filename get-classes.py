import requests
import pandas as pd
import time

while True:
    #Get data from tables on legacy CourseAvail
    #Term=4100 specifies Fall 2019 quarter
    url = 'https://legacy.scu.edu/courseavail/search/index.cfm?fuseAction=search&StartRow=1&MaxRow=10000&acad_career=all&school=&subject=&catalog_num=&instructor_name1=&days1=&start_time1=&start_time2=23&header=yes&footer=yes&term=4100'

    html = requests.get(url).content
    df_list = pd.read_html(html, header=0)
    df = df_list[-1]

    #Set NaN values to "0" so rounding can happen
    df[['Number', 'Session']] = df[['Number','Session']].fillna(value=0)

    #Remove trailing .0 from columns
    df.Number = df.Number.round(0).astype(int)
    df.Session = df.Session.round(0).astype(int)

    #Export out to CSV
    df.to_csv('./classes-export.csv', index=False, sep='\t')

    #Sleep for 20 seconds so as not to hammer server
    time.sleep(20)
