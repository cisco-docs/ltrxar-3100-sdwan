#!/usr/bin/python

## This script takes as input a clear text string and generates:
## - The vManage-encrypted string (specific to each vManage)
## - The SHA512 hash of the string
## - The Cisco Type 7 hash of the string
## - The Cisco Type 9 hash of the string

import os
import sys
import argparse
import logging
import crypt
from catalystwan.session import create_manager_session
from CiscoPWDhasher import type7,type9
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Basic configuration for logging
logging.basicConfig(level=logging.INFO)
log = logging.getLogger("sdwan-encrypt")

def main(argv=None):
    try:
        url = os.environ['SDWAN_URL']
        sdwan_username = os.environ['SDWAN_USERNAME']
        sdwan_password = os.environ['SDWAN_PASSWORD']
    except:
        raise LoginCredentialsError("Missing environment variables with SDWAN credentials: SDWAN_URL, SDWAN_USERNAME, SDWAN_PASSWORD")

    parser = argparse.ArgumentParser()
    parser.add_argument("string", type=str, help='Clear text value to encrypt')
    args = parser.parse_args(argv)

    log.info("*** Connecting to the vManage API... ***")

    with create_manager_session(url=url, username=sdwan_username, password=sdwan_password) as session:
        cluster_enc = session.post(
            "/dataservice/template/security/encryptText/encrypt",
            json={"inputString":args.string},
        ).json()["encryptedText"]

    log.info("Input clear-text string: " + args.string)
    log.info("vManage-encrypted string: " + cluster_enc)
    log.info("SHA512 hash: " + crypt.crypt(args.string))
    log.info("Cisco Type 7 hash: " + type7(args.string).lower())
    log.info("Cisco Type 9 hash: " + type9(args.string))

if __name__ == "__main__":
   main(sys.argv[1:])
