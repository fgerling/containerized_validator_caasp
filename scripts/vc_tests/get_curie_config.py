#!/usr/bin/python3

import os
import sys
import time
from selenium import webdriver

# Parse argument
if len(sys.argv) != 2: sys.exit("Expected single arg: Load Balancer IP")

# Define headless driver
options = webdriver.ChromeOptions()
options.add_argument("headless")
driver = webdriver.Chrome(options=options)

# enable_download_in_headless_chrome
driver.command_executor._commands["send_command"] = ("POST", '/session/$sessionId/chromium/send_command')
params = {'cmd': 'Page.setDownloadBehavior', 'params': {'behavior': 'allow', 'downloadPath': os.getcwd()}}
driver.execute("send_command", params)

# Get gangway
driver.get(f"https://{sys.argv[1]}:32001/")

# Get dex
sign_in = driver.find_element_by_id('download-button').click()

# Login
driver.find_element_by_id('login').send_keys('curie@email.com')
driver.find_element_by_id('password').send_keys('password')
driver.find_element_by_id('submit-login').click()
driver.find_element_by_xpath("//button/span[text()='Grant Access']").submit()

# Get kubeconfig
driver.find_element_by_link_text('DOWNLOAD KUBECONFIG').click()

#for i in range(10):
#	if os.path.exists("Downloads/kubeconf.txt"): break
time.sleep(3)

driver.quit()