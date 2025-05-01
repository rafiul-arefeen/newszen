import requests
from bs4 import BeautifulSoup
import csv
import os
from datetime import datetime
from pymongo import MongoClient
from qdrant_loader import qdrant_data_load

qdrant_loader_switch = False

article_data = []
newscount = 0

#To send data to mongdb
MONGO_URI = 'mongodb+srv://demo_user:tNwYzQbHbta4j_G@newszen.eup0l.mongodb.net/?retryWrites=true&w=majority&appName=Newszen'
COllECTION_NAME = 'news'
DATABASE_NAME = 'mydatabase'
client = MongoClient(MONGO_URI)

database = client[DATABASE_NAME]
collection = database[COllECTION_NAME]

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
}

def fetch_article_data(url, selector, description_title_selector, description_details_selector, news_source, img_source_selector, img_selector_attribute, _topic, news_language = 'en'):

    global newscount
    response = requests.get(url, headers=headers)

    if response.status_code != 200:
        print(f"Failed to retrieve data from {url}")
        return []

    soup = BeautifulSoup(response.content, 'html.parser')
    # print("the selector is ", selector)
    news = soup.select(selector)

    print("the news is ",news)
    newscount = newscount + len(news)

    for news_details in news:
            # title_link = news_details.find(title_link_selector)['href']
            title_link = news_details['href']


            if title_link.startswith("http"):  # Absolute URL
                article_details_url = title_link
            else:  # Relative URL
                if news_source == 'mzamin':
                    article_details_url = "https://mzamin.com/" + title_link + "#gsc.tab=0"
                if news_source == 'The Daily Star':
                    article_details_url = "https://www.thedailystar.net/" + title_link
                else:
                    article_details_url = url + title_link


            print("title link is ",article_details_url)

            article_details = fetch_details(article_details_url, description_title_selector, description_details_selector, news_source, img_source_selector, img_selector_attribute, _topic, news_language)

            #check for duplcate news
            if article_details: 
                print(article_details)
                article_data.append(article_details)

                if qdrant_loader_switch:
                    print("loading for qdrant")
                    print("=="*80)
                    qdrant_data_load(article_details) 
                    

            if article_details:
                title = article_details.get("title")  

                existing_news = collection.find_one({"title": title}) # Check if news already exists in the database
            
                if existing_news:
                    pass
                    # print ( "==" * 80)
                    # print(f"News article with title '{title}' already exists. Skipping insertion.")
                    # print ( "==" * 80)
                else:
                    print(f"Inserting new article: {title}")

                    # collection.insert_one(article_details)  # Insert only if not found
                    article_data.append(article_details)


    return article_data
    
def fetch_details(article_url, description_title_selector, description_details_selector, news_source, img_source_selector, img_selector_attribute, _topic, news_language = 'en'): 

    response = requests.get(article_url)
    news_details = []

    if response.status_code != 200 :
        # print(f"failed to retrieve data from {article_url}")
        return None
    
    soup = BeautifulSoup(response.content, 'html.parser')
    # print("===="*10)

    title = soup.select_one(description_title_selector).text.strip()
    # print("the title is ", title)

    topic = _topic
    # # print(title)

    pic_tag = soup.select_one(img_source_selector)

    imgsrc = ""
    # print("picture tag is ", pic_tag)

    if pic_tag:
        
        imgsrc = pic_tag[img_selector_attribute] if news_source != 'mzamin' else "https://mzamin.com/" + pic_tag[img_selector_attribute]
    else :
        imgsrc = 'https://dummyimage.com/300x300/fff/aaa'
        # print("No imgsrc")

    # # for description adding the text of all p tags

    # print_section = soup.find('div', class_='details-brief dNewsDesc print-section')
    print_section = soup.select(description_details_selector)

    full_description = ""
    if print_section :
        # description_section = print_section.find_all('p')

        for descriptions in print_section:
            # print(descriptions.get_text(strip = True))
            descriptions = descriptions.text.strip()
            full_description = full_description + "\n" + descriptions
    else :
        full_description = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        # print("No description found")

    # print(full_description)

    #adding date (fetching date will be inserted)

    now = datetime.now()
    publish_time = now.strftime("%d-%m-%y")

    import random

    # # print("===="*10)

    news_details = {
        'title' : title,
        'imageurl' : imgsrc,
        'source' : news_source,
        'description' : full_description,
        'url' : article_url,
        'dateTime' : publish_time,
        'topic' : topic,
        'language' : news_language,
        'likecount' : random.randint(50, 100), # likecount is given arbitrarily 
        'priority' : 0 
    }

    return news_details


# Categories : "national", "world", "politics", "sports", "business", "finance" , "techonology", "entertainment"

if __name__ == "__main__" :

    # prothom alo has some issues
    # final_data_prothomalo = fetch_article_data('https://www.prothomalo.com/bangladesh', '#container #container > div > div:nth-child(2) > div > div > div.two-stories-with-load-more-wrapper.hOSPD > div.stories-set.gqNK1 > div:nth-child(1) > div > div.content-area > div.card-with-image-zoom > h3 > a','#container > div > div.story-grid > div > div.story-content-wrapper.jzPe6 > div:nth-child(1) > div.story-head.NKo24 > div.story-title-info.BG103 > div:nth-child(2) > h1','','','','','')
    
    #container > div > div:nth-child(2) > div > div > div.two-stories-with-load-more-wrapper.hOSPD > div.stories-set.gqNK1 > div:nth-child(1) > div > div.content-area > div.card-with-image-zoom > h3 > a

    # BDNews 24
    
    # #world
    # final_data_world_bdnews24 = fetch_article_data('https://bdnews24.com/world', '#data-wrapper > div > div:nth-child(1) > a:nth-child(1)', 'div.details-title.print-section > div > h1', '#contentDetails > p', 'bdnews24', 'div.details-img > picture > img','src', 'world')
    # # entertainment
    # final_data_entertainment_bdnews24 = fetch_article_data('https://bdnews24.com/entertainment', '#data-wrapper > div > div:nth-child(1) > a:nth-child(1)', 'div.details-title.print-section > div > h1', '#contentDetails > p', 'bdnews24', 'div.details-img > picture > img','src', 'entertainment')

    # # sports
    # final_data_sports_bdnews24 = fetch_article_data('https://bdnews24.com/cricket', '#data-wrapper > div > div:nth-child(1) > a:nth-child(1)', 'div.details-title.print-section > div > h1', '#contentDetails > p', 'bdnews24', 'div.details-img > picture > img','src', 'sports')
    
    # #finance
    # final_data_finance_bdnews24 = fetch_article_data('https://bdnews24.com/economy', '#data-wrapper > div > div:nth-child(1) > a:nth-child(1)', 'div.details-title.print-section > div > h1', '#contentDetails > p', 'bdnews24', 'div.details-img > picture > img','src', 'finance')

    # #business
    # final_data_business_bdnews24 = fetch_article_data('https://bdnews24.com/business', '#data-wrapper > div > div:nth-child(1) > a:nth-child(1)', 'div.details-title.print-section > div > h1', '#contentDetails > p', 'bdnews24', 'div.details-img > picture > img','src', 'business')

    # #national
    # final_data_national_bdnews24 = fetch_article_data('https://bangla.bdnews24.com/samagrabangladesh', '#data-wrapper > div > div:nth-child(1) > a:nth-child(1)', 'div.details-title.print-section > div > h1', '#contentDetails > p', 'bdnews24', 'div.details-img > picture > img','src', 'national', 'bn')
    
    # #technology
    # final_data_technology_bdnews24 = fetch_article_data('https://bangla.bdnews24.com/tech', '#data-wrapper > div > div:nth-child(1) > a:nth-child(1)', 'div.details-title.print-section > div > h1', '#contentDetails > p', 'bdnews24', 'div.details-img > picture > img','src', 'technology', 'bn')



    # ManobZamin (all bangla)
    # div.gy-5:nth-child(2) > div:nth-child(1) > div:nth-child(1) > div:nth-child(2) > h4:nth-child(1) > a:nth-child(1)
    # div.col-sm-6 div.row.d-flex.flex-sm-row.flex-row-reverse div.col-sm-8.col-7 h4 a
    # techonology
    final_data_technology_mzamin = fetch_article_data('https://mzamin.com/category.php?cat=15#gsc.tab=0', 'div.gy-5:nth-child(2) > div:nth-child(1) > div:nth-child(1) > div:nth-child(2) > h4:nth-child(1) > a:nth-child(1)','h1.lh-base', 'div.col-sm-10.offset-sm-1.fs-5.lh-base.mt-4.mb-5', 'mzamin','body > div.container > article > div > div.col-sm-8 > img','data-src', 'bn')

    # finance
    # final_data_finance_mzamin = fetch_article_data('https://mzamin.com/category.php?cat=11#gsc.tab=0', 'body > div.container > section > div:nth-child(2) > div > div.row.gx-5.gy-5.mt-5 > div > div > div > h4 > a','h1.lh-base.fs-1', 'div.col-sm-10.offset-sm-1.fs-5.lh-base.mt-4.mb-5', 'mzamin','body > div.container > article > div > div.col-sm-8 > img','data-src', 'bn')

    #politics
    # final_data_politics_mzamin = fetch_article_data('https://mzamin.com/category.php?cat=24#gsc.tab=0', 'body > div.container > section > div:nth-child(2) > div > div.row.gx-5.gy-5.mt-5 > div > div > div > h4 > a','h1.lh-base.fs-1', 'div.col-sm-10.offset-sm-1.fs-5.lh-base.mt-4.mb-5', 'mzamin','body > div.container > article > div > div.col-sm-8 > img','data-src', 'bn')

    #enterainment
    # final_data_entertainment_mzamin = fetch_article_data('https://mzamin.com/category.php?cat=6#gsc.tab=0', 'body > div.container > section > div:nth-child(2) > div > div.row.gx-5.gy-5.mt-5 > div > div > div > h4 > a','h1.lh-base.fs-1', 'div.col-sm-10.offset-sm-1.fs-5.lh-base.mt-4.mb-5', 'mzamin','body > div.container > article > div > div.col-sm-8 > img','data-src', 'bn')

    #sports
    # final_data_sports_mzamin = fetch_article_data('https://mzamin.com/category.php?cat=4#gsc.tab=0', 'body > div.container > section > div:nth-child(2) > div > div.row.gx-5.gy-5.mt-5 > div > div > div > h4 > a','h1.lh-base.fs-1', 'div.col-sm-10.offset-sm-1.fs-5.lh-base.mt-4.mb-5', 'mzamin','body > div.container > article > div > div.col-sm-8 > img','data-src', 'bn')


    # daily star

    # # sports
    # final_data_dailystar_sports = fetch_article_data('https://www.thedailystar.net/sports', '#inner-wrap > div.off-canvas-content > main > div > div.block-content.content > div > div:nth-child(7) > div > div > div > div > div > div.card-content.pt-20.pb-20.pr-20 > h3 > a','article > h1', 'article > div.pb-20.clearfix > p', 'The Daily Star','div.section-media.sm-float-none.position-relative.small-full-extended.mb-30.no-margin-lr > span > picture > img','data-srcset', 'sports')
    
    # # business
    # final_data_dailystar_business = fetch_article_data('https://www.thedailystar.net/business', '#inner-wrap > div.off-canvas-content > main > div > div.block-content.content > div > div:nth-child(7) > div > div > div > div > div > div.card-content.pt-20.pb-20.pr-20 > h3 > a','article > h1', 'article > div.pb-20.clearfix > p', 'The Daily Star','div.section-media.sm-float-none.position-relative.small-full-extended.mb-30.no-margin-lr > span > picture > img','data-srcset', 'business')

    # # technology
    # final_data_dailystar_technology = fetch_article_data('https://www.thedailystar.net/tech-startup', '#inner-wrap > div.off-canvas-content > main > div > div.block-content.content > div > div:nth-child(7) > div > div > div > div > div > div.card-image.position-relative > a','article > h1', 'article > div.pb-20.clearfix > p', 'The Daily Star','div.section-media.sm-float-none.position-relative.small-full-extended.mb-30.no-margin-lr > span > picture > img','data-srcset', 'technology')

    # # entertainment
    # final_data_dailystar_entertainment = fetch_article_data('https://www.thedailystar.net/entertainment', '#inner-wrap > div.off-canvas-content > main > div > div.block-content.content > div > div.panel-pane.pane-category-load-more.no-title.block > div > div > div.columns.medium-9.small-12 > div > div.view-content > div > div.card-content.card-content.columns > h3 > a','article > h1', 'article > div.pb-20.clearfix > p', 'The Daily Star','div.section-media.sm-float-none.position-relative.small-full-extended.mb-30.no-margin-lr > span > picture > img','data-srcset', 'entertainment')

    # # politics
    # final_data_dailystar_politics = fetch_article_data('https://www.thedailystar.net/law-our-rights', '#inner-wrap > div.off-canvas-content > main > div > div.block-content.content > div > div.panel-pane.pane-category-load-more.no-title.block > div > div > div.columns.medium-9.small-12 > div > div.view-content > div > div.card-content.card-content.columns > h3 > a','article > h1', 'article > div.pb-20.clearfix > p', 'The Daily Star','div.section-media.sm-float-none.position-relative.small-full-extended.mb-30.no-margin-lr > span > picture > img','data-srcset', 'politics')

    # # world
    # final_data_dailystar_world = fetch_article_data('https://www.thedailystar.net/news/world', '#inner-wrap > div.off-canvas-content > main > div > div.block-content.content > div > div:nth-child(3) > div > div > div > div > div > div.card-content.pt-20.pb-20.pr-20 > h3 > a:nth-child(1)','article > h1', 'article > div.pb-20.clearfix > p', 'The Daily Star','div.section-media.sm-float-none.position-relative.small-full-extended.mb-30.no-margin-lr > span > picture > img','data-srcset', 'world')


    # # # ittefaq

    # #contents_459_ajax_container > div > div:nth-child(6) > div > div.info.has_ai > div.title_holder > div > h2 > a
    # final_data_ittefaq_national = fetch_article_data('https://www.ittefaq.com.bd/', 'div.info > div.title_holder > div > h2 > a','div.content_detail_outer > div.content_detail_inner > div.content_detail_left > div > div > div:nth-child(1) > div > h1', 'div.content_detail_content_outer > div > article > div > p', 'The Daily Ittefaq','div.row.detail_holder > div > div > div.detail_inner > div.featured_image > span > a', 'src', 'national', 'bn')
    

    # # # international newspapers

    # # # cnn
    # final_data_cnn_international = fetch_article_data('https://edition.cnn.com/', 'div.container_lead-package__cards-wrapper > div > div > div:nth-child(1) > a','#maincontent', 'div.article__content-container > div.article__content > p', 'CNN','div.image__lede.article__lede-wrapper > div > div.image__container > picture > img', 'src', 'international')
    
    # #bbc has some issues, maybe restriction from the website directly
    # final_data_bbc_general = fetch_article_data('https://www.bbc.com/news', 'div.sc-93223220-0.sc-b38350e4-2.cmkdDu.QUMNJ > div.sc-b38350e4-3.gugNoq > div > div > a','#maincontent', 'div.article__content-container > div.article__content > p', 'CNN','div.image__lede.article__lede-wrapper > div > div.image__container > picture > img', 'src', 'international')
    
    # al zazeera
    final_data_alzazeera_general = fetch_article_data('https://www.aljazeera.com/', 'article > div.gc__content > div.gc__header-wrap > h3 > a','#main-content-area > header > h1', '#main-content-area > div.wysiwyg.wysiwyg--all-content.css-ibbk12 > p', 'Al Zazeera','#main-content-area > img', 'src', 'international')
    # final_data_alzazeera_general = fetch_article_data('https://www.aljazeera.com/', '#news-feed-container > article:nth-child(3) > div.gc__content > div.gc__header-wrap > h3 > a:nth-child(1)','#main-content-area > header > h1', '#main-content-area > div.wysiwyg.wysiwyg--all-content.css-ibbk12 > p', 'Al Zazeera','#main-content-area > img', 'src', 'international')

    #news-feed-container > article:nth-child(3) > div.gc__content > div.gc__header-wrap > h3 > a:nth-child(1)

    # for data in article_data:
    #     print(data)

    # for news in article_data:
        # print(news)
        # collection.insert_one(news)

    # print("News data updated successfully")

    #update in the crontab

    file_path = "/home/fateennr/bigL/academics/Projects/Newszen/scrappers/scrapper_update.txt"

    # Get current timestamp
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # Write to file
    with open(file_path, "a") as file:
        file.write(f"Task ran at: {now}\n")

    # print("Cron job executed successfully.")    
    # print("total number of news fetched ", newscount)
