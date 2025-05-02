from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import csv
import time
from selenium.common.exceptions import NoSuchElementException, TimeoutException, StaleElementReferenceException

import requests
from bs4 import BeautifulSoup
import csv
import os
from datetime import datetime
from pymongo import MongoClient

#To send data to mongdb
MONGO_URI = 'mongodb+srv://demo_user:tNwYzQbHbta4j_G@newszen.eup0l.mongodb.net/?retryWrites=true&w=majority&appName=Newszen'
COllECTION_NAME = 'twitter'
DATABASE_NAME = 'mydatabase'
client = MongoClient(MONGO_URI)

database = client[DATABASE_NAME]
collection = database[COllECTION_NAME]

scroll_count = 3

def initialize_driver():
    chrome_options = Options()
    chrome_options.page_load_strategy = 'eager'
    chrome_options.add_argument('--no-sandbox')
    chrome_options.add_argument('--disable-dev-shm-usage')
    chrome_options.add_argument('--disable-gpu')
    chrome_options.add_argument('--disable-software-rasterizer')
    chrome_options.add_argument('--headless')  # Run headless for improved performance
    service = Service(ChromeDriverManager().install())
    return webdriver.Chrome(service=service, options=chrome_options)


def extract_tweets_from_page(driver, tweets, source, tag, csv_writer, unique_posts, file_handle):
    print(f"Found {len(tweets)} tweets for {source}")
    new_found = 0
    for tweet in tweets:
        try:
            # Click "Show" if present to reveal full tweet text.
            try:
                show_button = tweet.find_element(By.XPATH, './/div[contains(text(), "Show")]')
                if show_button.is_displayed():
                    driver.execute_script("arguments[0].click();", show_button)
                    time.sleep(2)
            except NoSuchElementException:
                pass

            # Extract tweet content (Description)
            content = tweet.find_element(By.XPATH, './/div[@data-testid="tweetText"]').text.strip()
            print("content is ", content)

            # Extract timestamp (Date)
            timestamp = tweet.find_element(By.XPATH, './/time').get_attribute('datetime').strip()

            # Extract image URLs (Imgsource)
            image_elements = tweet.find_elements(By.XPATH, './/img[contains(@src, "media")]')
            print("image link is ", image_elements)

            image_urls = [img.get_attribute('src') for img in image_elements]
            print(image_urls)

            video_urls = []
            try:
                video_elements = tweet.find_elements(By.XPATH, './/div[@data-testid="videoPlayer"]//video')
                for video in video_elements:
                    video_url = video.get_attribute('src')
                    if video_url:
                        video_urls.append(video_url)

                metadata_elements = tweet.find_elements(By.XPATH, './/div[contains(@data-testid, "videoPlayer")]')
                for meta in metadata_elements:
                    meta_url = meta.get_attribute('data-video-url')
                    if meta_url:
                        video_urls.append(meta_url)
            except NoSuchElementException:
                pass

            like_count = "0"
            try:
                engagement_buttons = tweet.find_elements(By.XPATH, './/div[@role="group"]/div')
                if len(engagement_buttons) >= 3:
                    like_count_text = engagement_buttons[2].text.strip()
                    like_count = like_count_text if like_count_text else "0"
            except NoSuchElementException:
                pass

            final_tweet = {
                "title": "",  # Title (Empty)
                "content": content,  # Description (Tweet Text)
                "timestamp": timestamp,  # Date (Timestamp)
                "source": source,  # Source (ProfileName, @username)
                "image_urls": ', '.join(image_urls) if image_urls else "null",  # Imgsource (Images)
                "video_urls": ', '.join(video_urls) if video_urls else "null",  # Videosource (Videos)
                "tag": tag,  # Type (Categories)
                "language": "Mixed",  # Language (Set as Mixed)
                "like_count": like_count,  # Likecount (Number of Likes)
                "priority": 0  # Priority (Always 0)
            }

            csv_writer.writerow([
                "",  # Title (Empty)
                content,  # Description (Tweet Text)
                timestamp,  # Date (Timestamp)
                source,  # Source (ProfileName, @username)
                ', '.join(image_urls) if image_urls else "null",  # Imgsource (Images)
                ', '.join(video_urls) if video_urls else "null",  # Videosource (Videos)
                tag,  # Type (Categories)
                "Mixed",  # Language (Set as Mixed)
                like_count,  # Likecount (Number of Likes)
                0  # Priority (Always 0)
            ])
            file_handle.flush()  # Immediately save changes
            collection.insert_one(final_tweet)
            new_found += 1
            print(f"{source}: New Tweet - {timestamp}, {content}")

        except (NoSuchElementException, StaleElementReferenceException) as e:
            print(f"Error processing a tweet for {source}: {e}")
            continue
    return new_found


def process_profile(driver, profile_name, profile_data, csv_writer, unique_posts, file_handle):
    url = profile_data["url"]
    username = profile_data["username"]
    tag = profile_data["tag"]
    scroll_count = profile_data.get("scroll_count", 10)

    # Build the source string: "ProfileName, @username"
    source = f"{profile_name}, @{username}"

    driver.get(url)
    try:
        WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.XPATH, '//body')))
    except TimeoutException:
        print(f"Page load timeout for {url}")
        return

    # initial_count = len(unique_posts)
    for scroll in range(scroll_count):
        print(f"{source}: Scrolling {scroll + 1} / {scroll_count}")
        try:
            tweets = WebDriverWait(driver, 20).until(
                EC.presence_of_all_elements_located((By.XPATH, '//article[@role="article"]'))
            )
        except TimeoutException:
            print(f"Timeout finding tweets for {source}")
            break

        new_found = extract_tweets_from_page(driver, tweets, source, tag, csv_writer, unique_posts, file_handle)
        driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")

    print("unique posts are ", unique_posts)
    # if len(unique_posts) == initial_count:
    #     print(f"{source}: No new tweets found at this time.")

    

def main():
    driver = initialize_driver()
    profiles = {
        "KKRiders": {"url": "https://x.com/KKRiders", "username": "KolkataKnightRiders", "tag": "Cricket",
                     "scroll_count": scroll_count},
        "zulkarnainsaer": {"url": "https://x.com/zulkarnainsaer", "username": "zulkarnainsaer", "tag": "Bangladesh",
                           "scroll_count": 0},
        "Timesofgaza": {"url": "https://x.com/Timesofgaza", "username": "Timesofgaza", "tag": "Palestine",
                        "scroll_count": 0},
        "muftimenk": {"url": "https://x.com/muftimenk", "username": "muftimenk", "tag": "Islam",
                      "scroll_count": scroll_count},
        "Shahidul": {"url": "https://x.com/shahidul", "username": "shahidul", "tag": "Bangladesh", "scroll_count": scroll_count},
        "Tasneem": {"url": "https://x.com/tasneem?lang=en", "username": "tasneem", "tag": "Bangladesh",
                    "scroll_count": scroll_count},
        "RMadridInfo": {"url": "https://x.com/RMadridInfo", "username": "RMadridInfo", "tag": "Football",
                        "scroll_count": scroll_count},
        "ESPNcricinfo": {"url": "https://x.com/ESPNcricinfo", "username": "ESPNcricinfo", "tag": "Cricket",
                         "scroll_count": scroll_count},
        "OnlinePalEng": {"url": "https://x.com/OnlinePalEng", "username": "OnlinePalEng", "tag": "Palestine",
                         "scroll_count": scroll_count},
        "MuhammadSmiry": {"url": "https://x.com/MuhammadSmiry", "username": "MuhammadSmiry", "tag": "Palestine",
                          "scroll_count": scroll_count},
        "TechCrunch": {"url": "https://x.com/TechCrunch", "username": "TechCrunch", "tag": "Technology",
                       "scroll_count": scroll_count},
        "Engadget": {"url": "https://x.com/engadget", "username": "engadget", "tag": "Technology", "scroll_count": scroll_count},
        "ClarissaWard": {"url": "https://x.com/clarissaward", "username": "clarissaward", "tag": "World",
                         "scroll_count": scroll_count},
        "AC360": {"url": "https://x.com/AC360", "username": "AC360", "tag": "World", "scroll_count": scroll_count}
    }

    csv_filename = "formatted_tweets.csv"
    unique_posts = set()

    with open(csv_filename, mode='a', newline='', encoding='utf-8') as file:
        csv_writer = csv.writer(file)
        file.seek(0, 2)
        if file.tell() == 0:
            csv_writer.writerow(
                ['Title', 'Description', 'Date', 'Source', 'Imgsource', 'Videosource', 'Type', 'Language', 'Likecount',
                 'Priority'])

        for profile_name, profile_data in profiles.items():
            process_profile(driver, profile_name, profile_data, csv_writer, unique_posts, file)

    print("Dynamic fetching complete.")


if __name__ == "__main__":
    main()
