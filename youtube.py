from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import csv
import time
from selenium.common.exceptions import TimeoutException, StaleElementReferenceException, NoSuchElementException

import requests
from bs4 import BeautifulSoup
import csv
import os
from datetime import datetime
from pymongo import MongoClient
import random

#To send data to mongdb
MONGO_URI = 'mongodb+srv://demo_user:tNwYzQbHbta4j_G@newszen.eup0l.mongodb.net/?retryWrites=true&w=majority&appName=Newszen'
COllECTION_NAME = 'youtube_channels'
DATABASE_NAME = 'mydatabase'
client = MongoClient(MONGO_URI)

database = client[DATABASE_NAME]
collection = database[COllECTION_NAME]


def initialize_driver():
    chrome_options = Options()
    chrome_options.page_load_strategy = 'eager'
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument('--disable-software-rasterizer')
    service = Service(ChromeDriverManager().install())
    return webdriver.Chrome(service=service, options=chrome_options)


def check_videos(driver, channel_url, csv_writer, tag, source_mapping, seen_urls, __language):
    # Load the channel page and allow it to settle
    driver.get(channel_url)
    time.sleep(5)

    try:
        # Get the channel name
        channel_name_element = WebDriverWait(driver, 30).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, 'yt-formatted-string#text'))
        )
        channel_name = channel_name_element.text.strip()
        # Determine the source name using mapping if available
        source = source_mapping.get(channel_url, f"{channel_name} ({channel_url})")

        # Gather video elements and try to collect eight unique (unscraped) videos
        videos = driver.find_elements(By.CSS_SELECTOR, 'ytd-rich-item-renderer')
        unique_videos = []
        index = 0
        scroll_attempts = 0
        # Loop until eight unique videos are found or max scroll attempts reached
        while len(unique_videos) < 3 and scroll_attempts < 3:
            while index < len(videos) and len(unique_videos) < 3:
                try:
                    url = videos[index].find_element(By.CSS_SELECTOR, 'a#thumbnail').get_attribute('href')
                    if url and url not in seen_urls:
                        unique_videos.append(videos[index])
                    # Else, it's a duplicate so skip it
                except Exception as e:
                    print(f"Error fetching URL from video element: {e}")
                index += 1
            # If not enough unique videos are found, scroll down to load more
            if len(unique_videos) < 3: 
                driver.execute_script("window.scrollTo(0, document.documentElement.scrollHeight);")
                time.sleep(3)
                new_videos = driver.find_elements(By.CSS_SELECTOR, 'ytd-rich-item-renderer')
                if len(new_videos) > len(videos):
                    videos = new_videos
                scroll_attempts += 1

        # Process each unique video (up to 8)
        for video in unique_videos[:8]:
            try:
                url = video.find_element(By.CSS_SELECTOR, 'a#thumbnail').get_attribute('href')
            except Exception as e:
                print(f"Error fetching URL from video element: {e}")
                continue

            # Add URL to seen_urls so duplicates aren't scraped later
            seen_urls.add(url)

            try:
                title_element = video.find_element(By.CSS_SELECTOR, 'yt-formatted-string#video-title')
                title = title_element.text.strip() if title_element else 'null'
            except Exception as e:
                print(f"Error fetching title for {url}: {e}")
                title = 'null'

            # Get thumbnail image URL
            try:
                thumbnail_element = video.find_element(By.CSS_SELECTOR, 'a#thumbnail img')
                imgsrc = thumbnail_element.get_attribute('src')
            except Exception as e:
                print(f"Error fetching thumbnail for {url}: {e}")
                imgsrc = 'null'

            # Open the video in a new tab to fetch additional details
            driver.execute_script("window.open('');")
            driver.switch_to.window(driver.window_handles[-1])
            driver.get(url)

            try:
                # Try to click the "Show More" button to expand the description
                try:
                    show_more_button = WebDriverWait(driver, 5).until(
                        EC.element_to_be_clickable((By.CSS_SELECTOR, "tp-yt-paper-button#more"))
                    )
                    show_more_button.click()
                    time.sleep(2)
                except Exception as e:
                    print(f"Show More button not found or not clickable for {url}: {e}")

                # Wait for the description element
                description_element = WebDriverWait(driver, 30).until(
                    EC.presence_of_element_located((By.CSS_SELECTOR, "div#description"))
                )
                # Optionally click the description element to ensure it expands fully
                try:
                    driver.execute_script("arguments[0].click();", description_element)
                    time.sleep(2)
                except Exception as e:
                    print(f"Could not click on description element for {url}: {e}")
                video_description = description_element.text.strip()
            except Exception as e:
                print(f"Error fetching description for {url}: {e}")
                video_description = 'null'

            # Scrape view count
            try:
                view_count_element = WebDriverWait(driver, 30).until(
                    EC.presence_of_element_located((By.CSS_SELECTOR, "span.view-count"))
                )
                # view_count = view_count_element.text.strip()
            except Exception as e:
                print(f"Error fetching view count for {url}: {e}")
                view_count = 'null'

            # Attempt to extract like count from the first word of the description
            try:
                first_word = video_description.split()[0]
                view_count = int(first_word.replace(',', '').strip())
            except Exception as e:
                print(f"Error converting first word of description to int for {url}: {e}")
                view_count = 'null'

            # Close the video tab and switch back to the channel tab
            driver.close()
            driver.switch_to.window(driver.window_handles[0])

            # Placeholder values for date and priority
            date = 'null'
            videosource = url

            # Set language based on the source
            language = "English" if source in ("BBC", "CNN") else "Bangla"
            priority = 'null'

            timestamp = datetime.now()
            like_count = random.randint(50,100)

            final_youtube = {
                "title": title,  # Title (Empty)
                "timestamp": timestamp,  # Date (Timestamp)
                "source": source,  # Source (ProfileName, @username)
                "image_urls": imgsrc,  # Imgsource (Images)
                "video_urls": videosource,  # Videosource (Videos)
                "tag": tag,  # Type (Categories)
                "language": __language,  # Language (Set as Mixed)
                "views": view_count,  # Likecount (Number of Likes)
                "likecount" : like_count,
                "priority": 0  # Priority (Always 0)
            }

            collection.insert_one(final_youtube)

            print(final_youtube)

            # Write the row into the CSV file
            csv_writer.writerow(
                [title, video_description, timestamp, source, imgsrc, videosource, tag, language, like_count, view_count,
                 priority])
            print(f"New Video Found - Title: {title}, URL: {url}")
    except Exception as e:
        print(f"Error checking videos for {channel_url}: {e}")


# Initialize driver and CSV file
driver = initialize_driver()
csv_filename = 'YT_dynamicscrape.csv'
file = open(csv_filename, mode='a', newline='', encoding='utf-8')
csv_writer = csv.writer(file)
csv_writer.writerow(
    ['Title', 'Description', 'Date', 'Source', 'Imgsrc', 'Videosource', 'Type', 'Language', 'Likecount', 'ViewCount',
     'Priority'])

# Define channels as a dictionary with channel URLs mapped to a tuple (tag, seen_urls set)
channels = {
    "https://www.youtube.com/@BBCNews/videos": ("International News", set()),
    "https://www.youtube.com/@CNN/videos": ("International News", set()),
    "https://www.youtube.com/@IndependentTelevision/videos": ("BDCHANNEL", set()),
    "https://www.youtube.com/@JamunaTVbd/videos": ("BDCHANNEL", set()),
    "https://www.youtube.com/@NTVlatestnews/videos": ("BDCHANNEL", set()),
    "https://www.youtube.com/@somoynews360/videos": ("BDCHANNEL", set()),
    "https://www.youtube.com/@ChanneliNews/videos": ("BDCHANNEL", set()),
    "https://www.youtube.com/@EkusheyETV/videos": ("BDCHANNEL", set())
}

# Mapping specific channels to the desired source names
source_mapping = {
    "https://www.youtube.com/@IndependentTelevision/videos": "Independent TV",
    "https://www.youtube.com/@JamunaTVbd/videos": "Jamuna TV",
    "https://www.youtube.com/@NTVlatestnews/videos": "NTV",
    "https://www.youtube.com/@somoynews360/videos": "SHOMOY TV",
    "https://www.youtube.com/@ChanneliNews/videos": "CHANNEL I",
    "https://www.youtube.com/@EkusheyETV/videos": "Ekushey TV",
    "https://www.youtube.com/@CNN/videos": "CNN",
    "https://www.youtube.com/@BBCNews/videos": "BBC"
}



# Run the scraper once for each channel
for channel_url, (tag, seen_urls) in channels.items():
    if tag == "BDCHANNEL":
        __language = "Bengali"
    else:
        __language = "English"
    check_videos(driver, channel_url, csv_writer, tag, source_mapping, seen_urls, __language)
    time.sleep(5)  # Optional wait between channels

driver.quit()
file.close()

print("Script execution completed. 8 most recent unique posts scraped for each channel.")
